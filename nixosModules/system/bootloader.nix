{
  lib,
  config,
  ...
}: {
  options = {
    neve.system.bootloader = {
      systemdBoot.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      grub2.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = {
    boot.loader = {
      # General efi configuration --> mount under /boot
      efi = {
        canTouchEfiVariables = false;
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
      };
    };
  };
}
