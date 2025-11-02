{
  inputs,
  lib,
  self,
  ...
}: let
  hostsNames = lib.attrNames (lib.filterAttrs (n: v: v == "directory" && (builtins.readDir ./${n}) ? "default.nix") (builtins.readDir ./.));

  mkHost = hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          hostname
          self
          ;
      };
      modules = [
        ./${hostname}
        # inputs.agenix-rekey.nixosModules.default
        # inputs.agenix.nixosModules.default
        inputs.chaotic.nixosModules.default
        inputs.ff.nixosModules.freedpomFlake
        inputs.home-manager.nixosModules.home-manager
        inputs.preservation.nixosModules.preservation
        inputs.disko.nixosModules.disko
      ];
    };
in {
  flake.nixosConfigurations = lib.genAttrs hostsNames mkHost;
}
