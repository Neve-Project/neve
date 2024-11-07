{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    neve.packages = {
      flatpak.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf config.neve.packages.flatpak.enable {
    # Enable flatpak support
    services.flatpak.enable = true;
    xdg.portal.enable = true;

    # Add flatpak remotes
    systemd.services = {
      flatpak-repo = {
        wantedBy = ["multi-user.target"];
        path = [pkgs.flatpak];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
          flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo && \
          flatpak remote-add --if-not-exists gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo && \
          flatpak remote-add --if-not-exists rhel https://flatpaks.redhat.io/rhel.flatpakrepo
        '';
      };
    };
  };
}
