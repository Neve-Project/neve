{
  config,
  lib,
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
    xdg.portal.enable = true;
    services.flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
        {
          name = "gnome-nightly";
          location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
        }
        {
          name = "rhel";
          location = "https://flatpaks.redhat.io/rhel.flatpakrepo";
        }
      ];
    };
  };
}
