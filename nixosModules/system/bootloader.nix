# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.system.bootloader = {
      systemdBoot.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          This option enables systemdboot as default bootloader.
          Systemdboot is a UEFY-only bootloader.
        '';
        example = "true";
      };
      grub2.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          This option enables grub2 as default bootloader.
        '';
        example = "false";
      };
    };
  };

  config = {
    boot.loader = {
      # General efi configuration --> mount under /boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      # Systemd-boot configuration
      systemd-boot = lib.mkIf (config.neve.system.bootloader.systemdBoot.enable && !config.neve.system.bootloader.grub2.enable) {
        enable = true;
      };

      # Grub2 configuration
      grub = lib.mkIf (config.neve.system.bootloader.grub2.enable && !config.neve.system.bootloader.systemdBoot.enable) {
        enable = true;
        efiSupport = true;
        device = "nodev";
        theme = "${pkgs.catppuccin-grub}";
      };
    };
  };
}
