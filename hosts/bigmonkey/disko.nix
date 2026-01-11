{ lib, ... }:
let
  # Create a set of devices with the same config, allows for use of device name in overrides
  mkPool =
    filesystem: devices:
    lib.foldl' (
      acc: device:
      acc
      // {
        "disk-${filterId device}" = {
          inherit device;
          type = "disk";
          content = {
            inherit filesystem;
            type = "bcachefs";
            label = "${filesystem}.${filterId device}";
            extraFormatArgs = [ "--discard" ];
          };
        };
      }
    ) { } devices;

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

in
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
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "bcachefs";
                filesystem = "rootfs";
                label = "rootfs";
                extraFormatArgs = [ "--discard" ];
              };
            };
          };
        };
      };
    }
    // mkPool "fastpool" fpDevs
    // mkPool "bulkpool" bpDevs;

    bcachefs_filesystems = {
      rootfs = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression=zstd:1"
          "--background_compression=zstd:3"
        ];
        subvolumes = {
          nix.mountpoint = "/nix";
          root.mountpoint = "/nix/persist";
          home.mountpoint = "/nix/persist/home";
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
          fpool.mountpoint = "/nix/persist/fpool";
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
          bpool.mountpoint = "/nix/persist/bpool";
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=3G"
        "mode=755"
      ];
    };
  };
}
