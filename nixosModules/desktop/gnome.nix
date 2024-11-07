{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.desktop.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf config.neve.desktop.gnome.enable {
    neve = {
      desktop.packages.enable = lib.mkForce true;
      packages.flatpak.enable = lib.mkForce true;
    };
    services = {
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        excludePackages = [pkgs.xterm];
      };
      udev.packages = [pkgs.gnome-settings-daemon];
      dbus.packages = with pkgs; [gnome2.GConf];
      sysprof.enable = true;
    };
    programs.dconf.enable = true;

    environment.gnome.excludePackages = with pkgs; [
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
    ];
  };
}
