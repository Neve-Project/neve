# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.virtualisation.wine = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable Wine support (Windows programs support)
        '';
        example = "true";
      };
    };
  };
  config = lib.mkIf config.neve.virtualisation.wine.enable {
    # Install wine64 default packages
    environment.systemPackages = with pkgs;
      [
        wineWowPackages.full
        winetricks
        bottles
      ]
      # Install native wayland support if needed
      ++ (lib.optionals config.neve.desktop.wayland.enable [
        wineWowPackages.waylandFull
      ]);
  };
}
