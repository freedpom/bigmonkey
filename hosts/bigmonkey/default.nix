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
    enable = true;
    openFirewall = true;
  };

  imports = [
    ./disko.nix
    ./hardware.nix
  ];
}
