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
      steam-run
      mangohud
      gamemode
    ];
    programs = {
      gamemode.enable = true;
      steam = {
        enable = true;
        extraPackages = with pkgs; [
          gamescope
        ];
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        # extest.enable = true;
        protontricks = {
          enable = true;
          package = pkgs.protontricks;
        };
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };
  };
}
