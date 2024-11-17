# SPDX-License-Identifier: GPL-2.0-or-later
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
        default = "25.05";
        description = ''
          This option specifies your NixOS base version.
          It is recommended to use the default value.
        '';
        example = ''24.11'';
      };

      nix = {
        # Configure dynamic linker for libraries and packages
        linker.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            This option configures the dynamic linker
            for libraries and packages under /lib
          '';
          example = "false";
        };

        # Setup Nix Garbage collector to delete-older-than 30 days
        garbageCollect.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            This option allows nix to garbage collect
            itself after 30 days
          '';
          example = "false";
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
