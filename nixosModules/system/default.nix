{
  imports = [
    ./bootloader.nix
    ./kernel.nix
    ./zram.nix
  ];

  neve.system = {
    # Bootloader settings
    bootloader = {
      systemdBoot.enable = true;
      grub2.enable = false;
    };

    # Kernel Settings
    kernel = {
      rust.enable = false;
      inotify = 512;
    };

    # Zram/Swap settings
    zram.enable = false;
  };
}
