{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.ff.services.minecraft-server;
in
{
  options.ff.services.minecraft-server = {
    enable = lib.mkEnableOption "MIENCRAFT SERVER!!!";
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/minecraft";
      description = ''
        Where minecraft go
      '';
    };
    minMem = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = ''
        minimum memory
      '';
    };
    maxMem = lib.mkOption {
      type = lib.types.int;
      default = cfg.minMem;
      description = ''
        maximum memory
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
    services.minecraft-server = {
      dataDir = "";
      declarative = true;
      enable = true;
      eula = true;
      jvmOpts = "-Xms${builtins.toString cfg.minMem}G -Xmx${builtins.toString cfg.maxMem}G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paperclip.jar nogui";
      openFirewall = true;
      package = pkgs.fabricServers.fabric-1_18_2;
      serverProperties = {
        server-port = 43000;
        difficulty = 3;
        gamemode = 1;
        max-players = 5;
        motd = "NixOS Minecraft server!";
        white-list = true;
        enable-rcon = true;
        "rcon.password" = "hunter2";
      };
      whitelist = {
        username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
        username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
      };
    };
  };
}
