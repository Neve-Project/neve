# SPDX-License-Identifier: GPL-2.0-or-later
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    neve.desktop.fonts.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        This option installs different fonts.
        (liberation_ttf, inconsolata-nerdfont,
        font-awesome, noto-fonts-emoji).
        This option is enabled by default if you use a desktop profile.
      '';
      example = "true";
    };
  };

  config = lib.mkIf config.neve.desktop.fonts.enable {
    fonts = {
      enableDefaultPackages = true;

      # Default fonts for productivity and terminal (Nerd Fonts)
      packages = with pkgs; [
        liberation_ttf
        inconsolata-nerdfont
        font-awesome
        noto-fonts-emoji
      ];
    };
  };
}
