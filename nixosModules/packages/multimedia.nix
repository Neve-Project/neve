{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    neve.packages = {
      multimedia.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf config.neve.packages.multimedia.enable {
    users.users.${config.neve.config.username} = {
      packages = with pkgs; [
        ffmpeg-full
        libvpx
        openh264
        x265
      ];
    };
  };
}
