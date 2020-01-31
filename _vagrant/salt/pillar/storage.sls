# Ports:
# * 2000 RPC mountd
# * 2001 statd listen
# * 2002 statd outgoing
# * 2003 quotad
# * 2004 NLM TCP/UDP
# * 2005 NFS callback
# * 7790 drbd block replication

lvm:
  services:
    'lvm2-lvmetad.socket': False
  config:
    lvm.conf: |
      config {
          checks = 1
          abort_on_errors = 0
          profile_dir = "/etc/lvm/profile"
      }

      devices {
          dir = "/dev"
          scan = [ "/dev" ]
          obtain_device_list_from_udev = 1
          external_device_info_source = "none"

          cache_dir = "/run/lvm"
          cache_file_prefix = ""
          write_cache_state = 0

          filter = [ "a|^/dev/drbd_vd[a-z]+[0-9]+$|", "r|.*|" ]
          global_filter = [ "a|^/dev/drbd_vd[a-z]+[0-9]+$|", "r|.*|" ]

          sysfs_scan = 1
          multipath_component_detection = 1
          md_component_detection = 1
          fw_raid_component_detection = 0
          md_chunk_alignment = 1

          data_alignment_detection = 1
          data_alignment = 0
          data_alignment_offset_detection = 1
          ignore_suspended_devices = 0
          ignore_lvm_mirrors = 1
          disable_after_error_count = 0
          require_restorefile_with_uuid = 1
          pv_min_size = 2048
          issue_discards = 1
          allow_changes_with_duplicate_pvs = 0
      }

      allocation {
          maximise_cling = 1
          use_blkid_wiping = 1
          wipe_signatures_when_zeroing_new_lvs = 1
          mirror_logs_require_separate_pvs = 0

          cache_pool_metadata_require_separate_pvs = 0

          thin_pool_metadata_require_separate_pvs = 0
      }

      log {
          verbose = 0
          silent = 0
          syslog = 1

          overwrite = 0
          level = 0
          indent = 1
          command_names = 0
          prefix = "  "
          activation = 0
          debug_classes = [ "memory", "devices", "activation", "allocation", "lvmetad", "metadata", "cache", "locking", "lvmpolld", "dbus" ]
      }

      backup {
          backup = 1
          backup_dir = "/etc/lvm/backup"
          archive = 1
          archive_dir = "/etc/lvm/archive"
          retain_min = 10
          retain_days = 30
      }

      shell {
          history_size = 100
      }

      global {
          umask = 077
          test = 0
          units = "r"
          si_unit_consistency = 1
          suffix = 1
          activation = 1

          proc = "/proc"
          etc = "/etc"
          locking_type = 1
          wait_for_locks = 1
          fallback_to_clustered_locking = 1
          fallback_to_local_locking = 1
          locking_dir = "/run/lock/lvm"
          prioritise_write_locks = 1

          abort_on_internal_errors = 0
          detect_internal_vg_cache_corruption = 0
          metadata_read_only = 0
          mirror_segtype_default = "raid1"
          raid10_segtype_default = "raid10"
          sparse_segtype_default = "thin"

          use_lvmetad = 0
          use_lvmlockd = 0

          system_id_source = "none"

          use_lvmpolld = 1
          notify_dbus = 1
      }

      activation {
          checks = 0
          udev_sync = 1
          udev_rules = 1
          verify_udev_operations = 0
          retry_deactivation = 1
          missing_stripe_filler = "error"
          use_linear_target = 1
          reserved_stack = 64
          reserved_memory = 8192
          process_priority = -18

          volume_list = []

          raid_region_size = 2048

          readahead = "auto"
          raid_fault_policy = "warn"
          mirror_image_fault_policy = "remove"
          mirror_log_fault_policy = "allocate"
          snapshot_autoextend_threshold = 100
          snapshot_autoextend_percent = 20
          thin_pool_autoextend_threshold = 100
          thin_pool_autoextend_percent = 20

          use_mlockall = 0
          monitoring = 1
          polling_interval = 15

          activation_mode = "degraded"
      }

      dmeventd {
          mirror_library = "libdevmapper-event-lvm2mirror.so"

          snapshot_library = "libdevmapper-event-lvm2snapshot.so"
          thin_library = "libdevmapper-event-lvm2thin.so"
      }

drbd:
  drbd.d:
    global_common.conf: |
      global {
        usage-count no;
      }

      common {
        handlers {
          fence-peer "/usr/lib/drbd/crm-fence-peer.sh";
          after-resync-target "/usr/lib/drbd/crm-unfence-peer.sh";
          split-brain "/usr/lib/drbd/notify-split-brain.sh root";
          pri-lost-after-sb "/usr/lib/drbd/notify-pri-lost-after-sb.sh; /usr/lib/drbd/notify-emergency-reboot.sh; echo b > /proc/sysrq-trigger ; reboot -f";
        }
        startup {
          wfc-timeout 0;
        }
        disk {
          md-flushes yes;
          disk-flushes yes;
          c-plan-ahead 1;
          c-min-rate 100M;
          c-fill-target 20M;
          c-max-rate 4G;
        }
        net {
          after-sb-0pri discard-younger-primary;
          after-sb-1pri discard-secondary;
          after-sb-2pri call-pri-lost-after-sb;
          protocol C;
          tcp-cork yes;
          max-buffers 20000;
          max-epoch-size 20000;
          sndbuf-size 0;
          rcvbuf-size 0;
        }
      }
    export-data.res: |
      resource export-data-vda {
        protocol C;
        disk {
          on-io-error detach;
        }
        on storage0 {
          address 192.168.120.70:7790;
          device /dev/drbd_vda1 minor 0;
          disk /dev/mapper/crypt_vda1;
          meta-disk internal;
        }
        on storage1 {
          address 192.168.120.71:7790;
          device /dev/drbd_vda1 minor 0;
          disk /dev/mapper/crypt_vda1;
          meta-disk internal;
        }
      }

      resource export-data-vdb {
        protocol C;
        disk {
          on-io-error detach;
        }
        on storage0 {
          address 192.168.120.70:7791;
          device /dev/drbd_vdb1 minor 1;
          disk /dev/mapper/crypt_vdb1;
          meta-disk internal;
        }
        on storage1 {
          address 192.168.120.71:7791;
          device /dev/drbd_vdb1 minor 1;
          disk /dev/mapper/crypt_vdb1;
          meta-disk internal;
        }
      }

pacemaker:
  user:
    # "P4$$word"; hashed with openssl passwd -1
    password: '$1$URnGoZlt$sIaFZZgRqBzNUZjWhQOCu1'
  cluster_setup:
    - pcsclustername: ubiquitous
    - nodes:
      - storage0.ubiquitous
      - storage1.ubiquitous
  properties:
    stonith-enabled: 'false'
    no-quorum-policy: 'ignore'
  resources: {}

# Only allow local services to bind
tcpwrappers:
  hosts.deny:
    nfs:
      - 'rpcbind mountd nfsd statd lockd rquotad : ALL'
  hosts.allow:
    nfs:
      - 'rpcbind mountd nfsd statd lockd rquotad : 127.0.0.1 192.168.120.0/24'

nfs:
  common:
    default:
      NEED_IDMAPD: 'yes'
  kernel_server:
    default:
      RPCMOUNTDOPTS: --manage-gids --port 2000
  modprobe:
    lockd:
      - nlm_udpport=2004
      - nlm_tcpport=2004
    nfs:
      - callback_tcpport=2005
      - nfs4_disable_idmapping=N
    nfsd:
      - nfs4_disable_idmapping=N
  sysctl:
    parameters:
      fs.nfs.nlm_tcpport: 2004
      fs.nfs.nlm_udpport: 2004
