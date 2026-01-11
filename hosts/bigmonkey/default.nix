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
          userOptions = {
            hashedPassword = "$6$i8pqqPIplhh3zxt1$bUH178Go8y5y6HeWKIlyjMUklE2x/8Vy9d3KiCD1WN61EtHlrpWrGJxphqu7kB6AERg6sphGLonDeJvS/WC730";
            openssh.authorizedKeys.keys = [
              "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPygL4EEH3CZXCAGndJzoq+bjKhqrVrUC+WxDKFTYTr0AAAADnNzaDpjb2RtYW4tbHBn codman@lpg"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOODnpB7W2eG+cQlbDMO4TZ5F8mLBADpVTidn7b2MrO codman@spg"
            ];
          };
        };
        quinno = {
          role = "admin";
          userOptions = {
            hashedPassword = "$6$i8pqqPIplhh3zxt1$bUH178Go8y5y6HeWKIlyjMUklE2x/8Vy9d3KiCD1WN61EtHlrpWrGJxphqu7kB6AERg6sphGLonDeJvS/WC730";
            openssh.authorizedKeys.keys = [
              "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICU1ToHVRo5curH9yPzJPhRsf2FkqKMtroVtojTJ6IOZAAAACnNzaDpzaGluanU= slaw_dormitory861@aleeas.com"
            ];
          };
        };
      };
    };
  };

  security.pam = {
    sshAgentAuth.enable = true;
    rssh.enable = true;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [
        "codman"
        "quinno"
      ];
    };

    listenAddresses = [
      {
        addr = "10.1.1.2";
        port = 22;
      }
    ];
  };

  systemd.services.sshd = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
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
