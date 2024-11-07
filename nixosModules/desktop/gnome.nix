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
    services = {
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        excludePackages = [pkgs.xterm];
      };
    };
    programs.dconf.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      gnome-system-monitor
    ];
  };
}
