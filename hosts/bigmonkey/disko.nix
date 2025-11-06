{lib, ...}: let
  # Create a set of devices with the same config, allows for use of device name in overrides
  mkDevs = devices: defaults: fsOverrides: lib.foldl' (acc: device: acc // {"disk-${filterId device}" = lib.recursiveUpdate (defaults device) (fsOverrides device);}) {} devices;

  # Filter last 4 characters of /dev/disk/by-id name
  filterId = device: lib.strings.substring (lib.stringLength device - 4) 4 device;

  fpDevs = [
    "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF66749"
    "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67818"
    "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67847"
    "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67917"
  ];

  bpDevs = [
    "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW603ALH"
    "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW6040NG"
  ];

  # Defaults for bcachefs drives
  bcacheDefaults = device: {
    inherit device;
    type = "disk";
    content = {
      type = "bcachefs";
      extraFormatArgs = ["--discard"];
    };
  };

  # Filesystem-specific overrides for fastpool
  fpOverrides = device: {
    content = {
      filesystem = "fastpool";
      label = "fastpool.${filterId device}";
    };
  };

  # Filesystem-specific overrides for bulkpool
  bpOverrides = device: {
    content = {
      filesystem = "bulkpool";
      label = "bulkpool.${filterId device}";
    };
  };
in {
  disko.devices = {
    disk =
      {
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
                  filesystem = "rootfs";
                  label = "rootfs";
                  extraFormatArgs = ["--discard"];
                };
              };
            };
          };
        };
      }
      // mkDevs fpDevs bcacheDefaults fpOverrides
      // mkDevs bpDevs bcacheDefaults bpOverrides;

    bcachefs_filesystems = {
      rootfs = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression=zstd:1"
        ];
        subvolumes = {
          nix = {
            mountpoint = "/nix";
          };
          root = {
            mountpoint = "/nix/persist";
          };
          home = {
            mountpoint = "/nix/persist/home";
          };
        };
      };
      fastpool = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression=zstd:1"
          "--erasure_code"
          "--data_replicas=1"
          "--metadata_replicas=2"
        ];
        subvolumes = {
          pool = {
            mountpoint = "/nix/persist/fpool";
          };
        };
      };

      bulkpool = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression zstd:5"
          "--background_compression=zstd:10"
          "--replicas=2"
        ];
        subvolumes = {
          pool = {
            mountpoint = "/nix/persist/bpool";
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
