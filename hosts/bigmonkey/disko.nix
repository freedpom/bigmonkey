{
  disko.devices = {
    disk = {
      nix = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KINGSTON_OM8SEP41024Q-A0_50026B7686814B14";
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
              };
            };
          };
        };
      };

      nvme-6749 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF66749";
        content = {
          type = "bcachefs";
          filesystem = "np1";
          label = "np1.6749";
        };
      };

      nvme-7818 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67818";
        content = {
          type = "bcachefs";
          filesystem = "np1";
          label = "np1.7818";
        };
      };

      nvme-7847 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67847";
        content = {
          type = "bcachefs";
          filesystem = "np1";
          label = "np1.7847";
        };
      };

      nvme-7917 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67917";
        content = {
          type = "bcachefs";
          filesystem = "np1";
          label = "np1.7917";
        };
      };
    };

    bcachefs_filesystems = {
      root = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--discard"
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
          "--discard"
          "--compression zstd:1"
          "--erasure_code"
          "--data_replicas 3+1"
          "--metadata_replicas 2"
        ];
        subvolumes = {
          root = {
            mountpoint = "/nix/persist/np1";
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
