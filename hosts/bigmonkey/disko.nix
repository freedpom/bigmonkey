{
  disko.devices = {
    disk = {
      nix = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_234252800502";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "bcachefs";
                filesystem = "root";
                label = "root";
                extraFormatArgs = ["--discard"];
              };
            };
          };
        };
      };

      # NVME raid drives
      nvme-6749 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF66749";
        content = {
          type = "bcachefs";
          filesystem = "np1";
          label = "np1.6749";
          extraFormatArgs = ["--discard"];
        };
      };

      nvme-7818 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67818";
        content = {
          type = "bcachefs";
          filesystem = "np1";
          label = "np1.7818";
          extraFormatArgs = ["--discard"];
        };
      };

      nvme-7847 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67847";
        content = {
          type = "bcachefs";
          filesystem = "np1";
          label = "np1.7847";
          extraFormatArgs = ["--discard"];
        };
      };

      nvme-7917 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67917";
        content = {
          type = "bcachefs";
          filesystem = "np1";
          label = "np1.7917";
          extraFormatArgs = ["--discard"];
        };
      };

      # HDD raid drives
      hdd-3ALH = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW603ALH";
        content = {
          type = "bcachefs";
          filesystem = "dp1";
          label = "dp1.3ALH";
          extraFormatArgs = ["--discard"];
        };
      };

      hdd-40NG = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW6040NG";
        content = {
          type = "bcachefs";
          filesystem = "dp1";
          label = "dp1.40NG";
          extraFormatArgs = ["--discard"];
        };
      };
    };

    bcachefs_filesystems = {
      root = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression zstd:1"
        ];
        subvolumes = {
          root = {
            mountpoint = "/nix/persist";
          };
          home = {
            mountpoint = "/nix/persist/home";
          };
        };
      };

      np1 = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression zstd:1"
          "--erasure_code"
          "--data_replicas 1"
          "--metadata_replicas 2"
        ];
        subvolumes = {
          root = {
            mountpoint = "/nix/persist/npool";
          };
        };
      };

      dp1 = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression zstd:10"
          "--replicas 2"
        ];
        subvolumes = {
          root = {
            mountpoint = "/nix/persist/dpool";
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=6G"
        "mode=755"
      ];
    };
  };
}
