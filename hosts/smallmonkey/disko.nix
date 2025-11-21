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
    };

    bcachefs_filesystems = {
      rootfs = {
        type = "bcachefs_filesystem";
        mountpoint = "/nix";
        extraFormatArgs = [
          "--compression=zstd:1"
        ];
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
