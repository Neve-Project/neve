# SPDX-License-Identifier: GPL-2.0-or-later
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
        description = ''
          It installs multimedia codecs.
          (Enabled by default in desktop profiles).
        '';
        example = "true";
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
