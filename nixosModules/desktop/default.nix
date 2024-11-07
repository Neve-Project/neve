{
  imports = [
    ./gnome.nix
    ./packages.nix
    ./fonts.nix
  ];

  neve.desktop.gnome.enable = false;
}
