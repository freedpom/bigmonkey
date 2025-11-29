{
  disko.devices = {
    disk = {
      nix = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_107277880";
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
    };

    bcachefs_filesystems = {
      rootfs = {
        mountpoint = "/nix";
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression=zstd:3"
          "--background_compression=zstd:6"
        ];
        subvolumes = {
          persist = {
            mountpoint = "/nix/persist";
          };
          home = {
            mountpoint = "/nix/persist/home";
          };
          os = {
            mountpoint = "/nix/os";
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
