{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options = {
    neve.desktop.packages.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.neve.desktop.packages.enable {
    users.users.${config.neve.config.username} = {
      packages = with pkgs; [
        resources
        gnome-maps
        gnome-console
        gnome-music
        gnome-weather
        gnome-contacts
        gnome-calendar
        gnome-clocks
        gnome-calculator
        gnome-characters
        gnome-font-viewer
        loupe
        gnome-connections
        simple-scan
        geary
        evince
        gnome-software
        inputs.nevica.packages.${pkgs.system}.nevica
        neovide
      ];
    };
    services.flatpak.packages = [
      {
        appId = "io.github.zen_browser.zen";
        origin = "flathub";
      }
    ];
  };
}
