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
