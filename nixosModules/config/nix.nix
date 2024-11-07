{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options = {
    neve.config = {
      # Configure default nix version
      systemVersion = lib.mkOption {
        type = lib.types.str;
        default = "24.11";
      };

      nix = {
        # Configure dynamic linker for libraries and packages
        linker.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        # Setup Nix Garbage collector to delete-older-than 30 days
        garbageCollect.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };
    };
  };

  # Nix Package manager configurations
  config = {
    # Setup system version by default
    system.stateVersion = config.neve.config.systemVersion;
    nix = {
      # Setup default nixpkgs as this flake
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      settings = {
        # Setup root group as trusted user
        trusted-users = ["@wheel"];
        # Activate flakes
        experimental-features = ["nix-command" "flakes"];
        # Optimize store if set
        auto-optimise-store = lib.mkIf config.neve.config.nix.garbageCollect.enable true;
      };

      # Main garbage collection settings
      gc = lib.mkIf config.neve.config.nix.garbageCollect.enable {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    # Dynamic linker setup for libraries and packages
    systemd = lib.mkIf config.neve.config.nix.linker.enable {
      tmpfiles = {
        rules = [
          "L+ /lib/${builtins.baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
          "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
        ];
      };
    };
  };
}
