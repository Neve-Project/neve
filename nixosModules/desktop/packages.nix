# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.desktop.packages.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        It install default Neve desktop packages.
        (Enabled by default if you are using a desktop profile).
      '';
      example = "true";
    };
  };

  config = lib.mkIf config.neve.desktop.packages.enable {
    users.users.${config.neve.config.username} = {
      packages = with pkgs; [
        resources # Resource Monitor
        gnome-maps # Maps
        gapless # Music Player
        decibels # Audio Player
        showtime # Video Player
        papers # Document Reader
        gnome-weather # Weather
        gnome-contacts # Contacts
        gnome-calendar # Calendar
        gnome-clocks # Clocks
        gnome-calculator # Calculator
        gnome-characters # Characters (Emojis and more)
        gnome-font-viewer # Font Viewer
        loupe # Image Viewer
        gnome-connections # Remote Desktop Connection
        simple-scan # Scanner
        geary # Mail Client
        firefox # Web Browser
      ];
    };
  };
}
