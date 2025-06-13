{ lib }:
let
  inherit (lib.kernel)
    yes
    no
    module
    freeform
    ;
in
{
  "CRYPTO_SHA256_ARM" = yes;
  "CRYPTO_AES_ARM" = yes;
  "CRYPTO_AES_ARM_BS" = yes;
  "CRYPTO_AES_ARM_CE" = yes;
  "CRYPTO_CHACHA20_NEON" = yes;
  "CRYPTO_NHPOLY1305_NEON" = yes;
  "DT_IDLE_STATES" = yes;
  "ARM_CPUIDLE" = yes;
  "ARM_PSCI_CPUIDLE" = yes;
  "ARM_PSCI_CPUIDLE_DOMAIN" = yes;
  "VLAN_8021Q" = module;
  "VLAN_8021Q_GVRP" = yes;
  "VLAN_8021Q_MVRP" = yes;
  "WQ_POWER_EFFICIENT_DEFAULT" = yes;
  "CGROUP_BPF" = yes;
}
