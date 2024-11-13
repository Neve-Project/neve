{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.desktop.gnome.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.neve.desktop.gnome.enable {
    neve = {
      desktop = {
        packages.enable = lib.mkForce true;
        fonts.enable = lib.mkForce true;
        wayland.enable = lib.mkForce true;
      };
      packages = {
        flatpak.enable = lib.mkForce true;
        multimedia.enable = lib.mkForce true;
      };
    };
    services = {
      xserver = {
        displayManager.gdm.enable = true;
        desktopManager.gnome = {
          enable = true;
        };
      };
      udev.packages = [pkgs.gnome-settings-daemon];
    };
    environment.gnome.excludePackages = with pkgs; [
      totem
      epiphany
      gnome-system-monitor
      gnome-maps
      gnome-music
      gnome-weather
      gnome-console
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
    ];
  };
}
