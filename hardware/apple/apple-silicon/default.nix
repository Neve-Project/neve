# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  ...
}: {
  imports = [
    ./modules
  ];

  # Setup the default graphics card for wayland
  config = lib.mkIf config.neve.hardware.apple.apple-silicon.enable {
    environment.sessionVariables = {
      WLR_DRM_DEVICES = "/dev/dri/card0";
    };
  };
}
