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
  "LOCALVERSION" = freeform "-wip-mtx";
  "GOOGLE_COREBOOT_TABLE" = module;
  "GOOGLE_FIRMWARE" = yes;
  "GOOGLE_FRAMEBUFFER_COREBOOT" = module;
  "GOOGLE_MEMCONSOLE" = module;
  "GOOGLE_MEMCONSOLE_COREBOOT" = module;
  "GOOGLE_VPD" = module;
  "CPU_FREQ_DEFAULT_GOV_ONDEMAND" = yes;
  "CRYPTO_MICHAEL_MIC" = module;
  "FB_SIMPLE" = yes;
  "FRAMEBUFFER_CONSOLE_ROTATION" = yes;
  "DRM_VGEM" = no;
  "DEBUG_ATOMIC_SLEEP" = no;
  "DEBUG_IRQFLAGS" = no;
  "DEBUG_LOCK_ALLOC" = no;
  "DEBUG_LOCKDEP" = no;
  "DEBUG_MUTEXES" = no;
  "DEBUG_PAGE_REF" = no;
  "DEBUG_RT_MUTEXES" = no;
  "DEBUG_RWSEMS" = no;
  "DEBUG_SPINLOCK" = no;
  "DEBUG_WW_MUTEX_SLOWPATH" = no;
  "DETECT_HUNG_TASK" = no;
  "DMA_FENCE_TRACE" = no;
  "DYNAMIC_FTRACE" = no;
  "DYNAMIC_FTRACE_WITH_ARGS" = no;
  "FTRACE" = no;
  "DM_AUDIT" = no;
  "DM_FLAKEY" = no;
  "DM_INTEGRITY" = no;
  "DM_VERITY" = no;
  "LOCKDEP" = no;
  "LOCKUP_DETECTOR" = no;
  "PM_ADVANCED_DEBUG" = no;
  "PM_SLEEP_DEBUG" = no;
  "DYNAMIC_DEBUG" = no;
  "DYNAMIC_DEBUG_CORE" = no;
  "LOCK_STAT" = no;
  "PM_DEBUG" = no;
  "REGULATOR_DEBUG" = no;
  "SCHEDSTATS" = no;
  "SHRINKER_DEBUG" = no;
  "ANDROID_BINDERFS" = no;
  "ANDROID_BINDER_DEVICES" = no;
  "ARM_CPUIDLE" = no;
  "ARM_PSCI_CPUIDLE" = no;
  "ARM_PSCI_CPUIDLE_DOMAIN" = no;
  "DRM_GEM_SHMEM_HELPER" = yes;
  "DRM_SCHED" = yes;
  "DRM_ANALOGIX_ANX7625" = yes;
  "DRM_PANFROST" = yes;
  "MODULE_COMPRESS_NONE" = yes;
  "ARM64_DEBUG_PRIORITY_MASKING" = no;
  "BT_DEBUGFS" = no;
  "BT_FEATURE_DEBUG" = no;
  "CFG80211_DEBUGFS" = no;
  "DEBUG_GPIO" = no;
  "GENERIC_IRQ_DEBUGFS" = no;
  "MAC80211_DEBUGFS" = no;
  "MAC80211_DEBUG_MENU" = no;
  "MAC80211_VERBOSE_DEBUG" = no;
  "MTK_LVTS_THERMAL_DEBUGFS" = no;
  "PWM_DEBUG" = no;
  "SCHED_DEBUG" = no;
  "VISL_DEBUGFS" = no;
  "KASAN" = no;
  "BLK_DEV_NVME" = yes;
}
