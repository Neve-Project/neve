{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.desktop.services = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          It enables base desktop services.
          (dconf, xdg-desktop-portal, dbus, gvfs, sysprof).
        '';
        example = "true";
      };
    };
  };
  config = lib.mkIf config.neve.desktop.services.enable {
    programs.dconf.enable = true;
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
    services = {
      dbus = {
        enable = true;
        packages = [pkgs.dbus];
      };
      gvfs.enable = true;
      sysprof.enable = true;
    };
  };
}
