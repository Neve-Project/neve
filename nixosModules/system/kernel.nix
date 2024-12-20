# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  ...
}: {
  options = {
    neve.system.kernel = {
      rust.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          This option applys rust overlays in the linux kernel.
        '';
        example = "false";
      };
      inotify = lib.mkOption {
        type = lib.types.int;
        default = 512;
        description = ''
          This option sets inotify kernel parameter.
        '';
        example = "1024";
      };
    };
  };
  config = {
    boot = {
      # Inotify config
      kernel.sysctl."fs.inotify.max_user_instances" = config.neve.system.kernel.inotify;

      # Kernel patches
      kernelPatches = lib.mkIf config.neve.system.kernel.rust.enable [
        # Enable Rust files in the kernel source (More time to compile, memory safe ?)
        {
          name = "Rust Support";
          patch = null;
          features = {
            rust = true;
          };
        }
      ];
    };
  };
}
