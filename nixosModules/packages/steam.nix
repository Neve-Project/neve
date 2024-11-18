# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.packages.steam.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  # Enable steam if selected. It also install a steam session.
  config = lib.mkIf config.neve.packages.steam.enable {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      steam
      steam-run
    ];
    programs = {
      gamemode.enable = true;
      steam = {
        enable = true;
        package = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              keyutils
            ];
        };
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    };
  };
}
