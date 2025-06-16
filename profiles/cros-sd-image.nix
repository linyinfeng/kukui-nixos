{
  config,
  pkgs,
  lib,
  ...
}:
let
  rootVolumeLabel = "NIXOS_ROOT";
  rootfsImage = pkgs.callPackage "${pkgs.path}/nixos/lib/make-ext4-fs.nix" {
    inherit (config.crosSdImage) storePaths;
    volumeLabel = rootVolumeLabel;
    compressImage = config.crosSdImage.compressImage;
  };
  inherit (config.system.build) kpartImage;
in
{
  options.crosSdImage = {
    storePaths = lib.mkOption {
      type = with lib.types; listOf package;
      example = lib.literalExpression "[ pkgs.stdenv ]";
      description = ''
        Derivations to be included in the Nix store in the generated SD image.
      '';
    };

    compressImage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether the SD image should be compressed using
        {command}`zstd`.
      '';
    };

    expandOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to configure the sd image to expand it's partition on boot.
      '';
    };

    nixPathRegistrationFile = lib.mkOption {
      type = lib.types.str;
      default = "/nix-path-registration";
      description = ''
        Location of the file containing the input for nix-store --load-db once the machine has booted.
        If overriding fileSystems."/" then you should to set this to the root mount + /nix-path-registration
      '';
    };
  };

  config = {
    boot.loader.grub.enable = false;

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/${rootVolumeLabel}";
        fsType = "ext4";
      };
    };

    crosSdImage.storePaths = [ config.system.build.toplevel ];
    system.build.crosSdImage = pkgs.callPackage (
      {
        stdenvNoCC,
      }:
      stdenvNoCC.mkDerivation rec {
        name = "nixos-cros-sd";

        nativeBuildInputs =
          with pkgs;
          [
            e2fsprogs
            e2tools
            util-linux
            vboot_reference
            gptfdisk
          ]
          ++ lib.optional config.crosSdImage.compressImage pkgs.zstd;

        inherit (config.crosSdImage) compressImage;

        buildCommand = ''
          mkdir -p $out/nix-support $out/sd-image
          export img=$out/sd-image/${name}.img

          echo "${pkgs.stdenv.buildPlatform.system}" > $out/nix-support/system
          if test -n "$compressImage"; then
            echo "file sd-image $img.zst" >> $out/nix-support/hydra-build-products
          else
            echo "file sd-image $img" >> $out/nix-support/hydra-build-products
          fi

          root_fs=${rootfsImage}
          kpart=${kpartImage}

          ${lib.optionalString config.crosSdImage.compressImage ''
            root_fs=./root-fs.img
            echo "Decompressing rootfs image"
            zstd -d --no-progress "${rootfsImage}" -o $root_fs
          ''}

          gapSectors=8192
          tailSectors=2048
          kernelSize=128 # MiB
          rootSectors=$(du -B 512 --apparent-size $root_fs | awk '{ print $1 }')
          imageSize=$((rootSectors * 512 + kernelSize * 2 * 1024 * 1024 + gapSectors * 512 + tailSectors * 512))
          truncate -s $imageSize $img

          sgdisk -Z $img
          sgdisk -C -e -G $img
          cgpt create $img

          # MiB to Sectors: MiB * 2048
          kernelSectors=$((kernelSize * 2048))

          kernelABegin=$gapSectors
          kernelBBegin=$((kernelABegin + kernelSectors))
          rootBegin=$((kernelBBegin + kernelSectors))

          echo "  gapSectors     = $gapSectors"
          echo "  kernelSize     = $kernelSize MiB"
          echo "  rootSectors    = $rootSectors sectors"
          echo "  rootSize       = $(($rootSectors / 2048)) MiB"
          echo "  imageSize      = $imageSize bytes = $((imageSize / 1024 / 1024)) MiB"
          echo "  kernelSectors  = $kernelSectors sectors"
          echo "  kernelABegin   = $kernelABegin"
          echo "  kernelBBegin   = $kernelBBegin"
          echo "  rootBegin      = $rootBegin"

          cgpt add -i 1 -t kernel -b $kernelABegin -s $kernelSectors -l KernelA -S 1 -T 2 -P 10 $img
          cgpt add -i 2 -t kernel -b $kernelBBegin -s $kernelSectors -l KernelB -S 0 -T 2 -P 5 $img
          cgpt add -i 3 -t data -b $rootBegin -s $rootSectors -l ${rootVolumeLabel} $img

          # Copy the kernel kpart into the first kernel partition
          dd conv=notrunc if=$kpart of=$img seek=$kernelABegin count=$kernelSectors

          # Write root partition
          dd conv=notrunc if=$root_fs of=$img seek=$rootBegin count=$rootSectors
        '';
      }
    ) { };

    boot.postBootCommands =
      let
        expandOnBoot = lib.optionalString config.crosSdImage.expandOnBoot ''
          # Figure out device names for the boot device and root filesystem.
          rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE /)
          bootDevice=$(lsblk -npo PKNAME $rootPart)
          partNum=$(lsblk -npo MAJ:MIN $rootPart | ${pkgs.gawk}/bin/awk -F: '{print $2}')

          # Resize the root partition and the filesystem to fit the disk
          echo ",+," | sfdisk -N$partNum --no-reread $bootDevice
          ${pkgs.parted}/bin/partprobe
          ${pkgs.e2fsprogs}/bin/resize2fs $rootPart
        '';
        nixPathRegistrationFile = config.crosSdImage.nixPathRegistrationFile;
      in
      ''
        # On the first boot do some maintenance tasks
        if [ -f ${nixPathRegistrationFile} ]; then
          set -euo pipefail
          set -x

          ${expandOnBoot}

          # Register the contents of the initial Nix store
          ${config.nix.package.out}/bin/nix-store --load-db < ${nixPathRegistrationFile}

          # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag.
          touch /etc/NIXOS
          ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

          # Prevents this from running on later boots.
          rm -f ${nixPathRegistrationFile}
        fi
      '';
  };
}
