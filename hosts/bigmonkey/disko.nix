{
  disko.devices = let
    getIdFromDevice = device: let
      parts = builtins.split "/" device;
      devName = builtins.elemAt parts (builtins.length parts - 1);
      len = builtins.stringLength devName;
    in
      builtins.substring (len - 4) 4 devName;

    bcachefsCommon = {
      filesystem,
      extraFormatArgs ? [],
      ...
    }: {
      type = "bcachefs";
      inherit filesystem extraFormatArgs;
    };

    fastpoolArgs = [
      "--discard"
      "--compression=zstd"
      "--background_compression=zstd"
      "--data_replicas=1"
      "--metadata_replicas=2"
    ];

    bulkpoolArgs = [
      "--discard"
      "--compression=zstd"
      "--background_compression=zstd"
      "--replicas=2"
    ];

    mkDisk = {
      device,
      pool,
      args,
    }: let
      id = getIdFromDevice device;
    in {
      type = "disk";
      inherit device;
      content =
        (bcachefsCommon {
          filesystem = pool;
          extraFormatArgs = args;
        })
        // {
          label = "${pool}_${id}";
        };
    };

    fastpoolDevices = [
      "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF66749"
      "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67818"
      "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67847"
      "/dev/disk/by-id/nvme-CT2000P310SSD8_24514CF67917"
    ];

    bulkpoolDevices = [
      "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW603ALH"
      "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW6040NG"
    ];

    fastpoolDiskMap = builtins.listToAttrs (
      map (dev: {
        name = "nvme-${getIdFromDevice dev}";
        value = mkDisk {
          device = dev;
          pool = "fastpool";
          args = fastpoolArgs;
        };
      })
      fastpoolDevices
    );

    bulkpoolDiskMap = builtins.listToAttrs (
      map (dev: {
        name = "hdd-${getIdFromDevice dev}";
        value = mkDisk {
          device = dev;
          pool = "bulkpool";
          args = bulkpoolArgs;
        };
      })
      bulkpoolDevices
    );
  in {
    disk =
      fastpoolDiskMap
      // bulkpoolDiskMap
      // {
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
                  label = "root";
                  extraFormatArgs = ["--discard"];
                };
              };
            };
          };
        };
      };

    bcachefs_filesystems = {
      rootfs = {
        type = "bcachefs_filesystem";
        extraFormatArgs = ["--compression=zstd"];
        subvolumes = {
          nix = {
            mountpoint = "/nix";
          };
          persist = {
            mountpoint = "/nix/persist";
          };
          home = {
            mountpoint = "/nix/persist/home";
          };
        };
      };

      fastpool = {
        type = "bcachefs_filesystem";
        extraFormatArgs = fastpoolArgs;
        subvolumes.root.mountpoint = "/nix/persist/fastpool";
      };

      bulkpool = {
        type = "bcachefs_filesystem";
        extraFormatArgs = bulkpoolArgs;
        subvolumes.root.mountpoint = "/nix/persist/bulkpool";
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
