{
  imports = [
    ./bootloader.nix
    ./kernel.nix
    ./zram.nix
  ];

  neve.system = {
    # Bootloader settings
    bootloader = {
      systemdBoot.enable = false;
      grub2.enable = true;
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
