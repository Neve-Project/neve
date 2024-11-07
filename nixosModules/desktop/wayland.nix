{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.desktop.wayland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.neve.desktop.wayland.enable {
    neve.desktop.services.enable = lib.mkForce true;
    environment = {
      systemPackages = with pkgs; [
        wayland
        wl-clipboard
        wl-clipboard-x11
        xwaylandvideobridge
        wayland-utils
      ];
      sessionVariables = {
        XDG_SESSION_TYPE = "wayland";
        XDG_BACKEND = "wayland";
        NIXOS_OZONE_WL = "1";
        GDK_BACKEND = "wayland,x11,*";
        QT_QPA_PLATFORM = "wayland;xcb";
      };
    };
    # Configure xwayland
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = config.neve.config.keyboardLayout;
          variant = "";
          # options = "caps:escape"; # Useful for vim
        };
        excludePackages = [pkgs.xterm];
      };
    };
  };
}
