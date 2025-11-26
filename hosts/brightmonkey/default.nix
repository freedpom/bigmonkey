{ lib, ... }:
{
  ff = {
    common.enable = true;
    services = {
      ananicy.enable = true;
      # ntp.enable = true;
      # consoles = {
      #   enable = true;
      #   kmscon = ["tty1" "tty2"];
      #   getty = ["tty3" "tty4"];
      # };
    };

    system = {
      nix.enable = true;
      # performance.enable = true;
      systemd-boot.enable = true;
      preservation = {
        enable = true;
        preserveHome = true;
      };
    };

    userConfig = {
      users = {
        codman = {
          role = "admin";
          hashedPassword = "$6$i8pqqPIplhh3zxt1$bUH178Go8y5y6HeWKIlyjMUklE2x/8Vy9d3KiCD1WN61EtHlrpWrGJxphqu7kB6AERg6sphGLonDeJvS/WC730";
        };
        quinno = {
          role = "admin";
          hashedPassword = "$6$i8pqqPIplhh3zxt1$bUH178Go8y5y6HeWKIlyjMUklE2x/8Vy9d3KiCD1WN61EtHlrpWrGJxphqu7kB6AERg6sphGLonDeJvS/WC730";
        };
      };
    };
  };

  boot.initrd.includeDefaultModules = lib.mkForce true;
  hardware.enableAllFirmware = true;
  hardware.enableAllHardware = true;
  nixpkgs.config.allowUnfree = lib.mkForce true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  imports = [
    ./disko.nix
    ./hardware.nix
  ];
}
