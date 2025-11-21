{
  disko.devices = {
    disk = {
      nix = {
        type = "disk";
        device = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003";
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
        # subvolumes = {
        #   root = {
        #     mountpoint = "/";
        #   };
        #   home = {
        #     mountpoint = "/home";
        #   };
        #   nix = {
        #     mountpoint = "/nix";
        #   };
        # };
        # subvolumes = {
        #   nix = {
        #     mountpoint = "/nix";
        #   };
        #   root = {
        #     mountpoint = "/nix/persist";
        #   };
        #   home = {
        #     mountpoint = "/nix/persist/home";
        #   };
        # };
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
