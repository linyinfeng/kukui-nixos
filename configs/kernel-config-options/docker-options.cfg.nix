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
  "POSIX_MQUEUE" = yes;
  "MEMCG" = yes;
  "BLK_CGROUP" = yes;
  "CGROUP_SCHED" = yes;
  "CGROUP_PIDS" = yes;
  "CGROUP_FREEZER" = yes;
  "CPUSETS" = yes;
  "CGROUP_DEVICE" = yes;
  "CGROUP_CPUACCT" = yes;
  "CGROUP_PERF" = yes;
  "NAMESPACES" = yes;
  "CGROUP_NET_PRIO" = yes;
  "EXT4_FS_POSIX_ACL" = yes;
  "EXT4_FS_SECURITY" = yes;
  "NET_NS" = yes;
  "PID_NS" = yes;
  "IPC_NS" = yes;
  "UTS_NS" = yes;
  "NF_NAT_NEEDED" = yes;
  "USER_NS" = yes;
  "MEMCG_SWAP" = yes;
  "MEMCG_SWAP_ENABLED" = yes;
  "BLK_DEV_THROTTLING" = yes;
  "CGROUP_HUGETLB" = yes;
  "CFS_BANDWIDTH" = yes;
  "FAIR_GROUP_SCHED" = yes;
  "RT_GROUP_SCHED" = yes;
  "IP_VS_NFCT" = yes;
  "NETFILTER" = yes;
  "NETFILTER_ADVANCED" = yes;
  "NETFILTER_FAMILY_BRIDGE" = yes;
  "NET_SCHED" = yes;
  "NET_CLS" = yes;
  "CGROUP_NET_CLASSID" = yes;
  "MD" = yes;
  "BTRFS_FS_POSIX_ACL" = yes;
  "VETH" = module;
  "BRIDGE" = module;
  "BRIDGE_NETFILTER" = module;
  "NF_NAT_IPV4" = module;
  "IP_NF_FILTER" = module;
  "IP_NF_TARGET_MASQUERADE" = module;
  "NETFILTER_XT_MATCH_ADDRTYPE" = module;
  "NETFILTER_XT_MATCH_CONNTRACK" = module;
  "NETFILTER_XT_MATCH_IPVS" = module;
  "IP_NF_NAT" = module;
  "NF_NAT" = module;
  "IOSCHED_CFQ" = module;
  "CFQ_GROUP_IOSCHED" = module;
  "NET_CLS_CGROUP" = module;
  "IP_VS" = module;
  "IP_VS_RR" = module;
  "VXLAN" = module;
  "XFRM_USER" = module;
  "INET_ESP" = module;
  "IPVLAN" = module;
  "MACVLAN" = module;
  "DUMMY" = module;
  "NF_NAT_FTP" = module;
  "NF_CONNTRACK_FTP" = module;
  "NF_NAT_TFTP" = module;
  "NF_CONNTRACK_TFTP" = module;
  "AUFS_FS" = module;
  "BLK_DEV_DM" = module;
  "DM_THIN_PROVISIONING" = module;
  "OVERLAY_FS" = module;
  "NF_CONNTRACK" = module;
  "IP_NF_IPTABLES" = module;
  "DAX" = module;
  "BTRFS_FS" = module;
}
