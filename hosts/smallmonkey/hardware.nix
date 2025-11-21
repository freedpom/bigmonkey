{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-server;
    initrd.availableKernelModules = [
      "mpt3sas"
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    kernelModules = [ "kvm-amd" ];
    supportedFilesystems = [ "bcachefs" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
