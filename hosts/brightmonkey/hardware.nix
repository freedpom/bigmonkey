{ pkgs, ... }:
{

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "sd_mod"
      "sr_mod"
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
    ];
    initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
      "dm-snapshot"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  systemd.network.networks."30-wan" = {
    matchConfig.Name = "eth0";
    networkConfig.DHCP = "no";
    address = [
      "5.161.179.69/32"
      "2a01:4ff:f0:3776::/64"
    ];
    routes = [
      {
        Gateway = "172.31.1.1";
        GatewayOnLink = true;
      }
      { Gateway = "fe80::1"; }
    ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
