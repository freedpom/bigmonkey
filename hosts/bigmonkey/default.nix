{ ... }:
{
  ff = {
    common.enable = true;
    system = {
      nix.enable = true;
      boot.enable = true;
      preservation = {
        enable = true;
        preserveHome = true;
      };
    };

    services.minecraft-server = {
      enable = true;
      dataDir = "/nix/persist/fpool/minecraft";
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

  services.openssh = {
    listenAddresses = [
      {
        addr = "10.1.1.2";
        port = 22;
      }
    ];
    enable = true;
    openFirewall = true;
  };

  networking.defaultGateway = {
    address = "10.1.1.1";
    interface = "eno1";
  };

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./disko.nix
    ./hardware.nix
  ];
}
