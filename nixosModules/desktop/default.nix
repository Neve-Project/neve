{
  imports = [
    ./gnome.nix
    ./packages.nix
    ./fonts.nix
    ./wayland.nix
    ./services.nix
  ];

  neve.desktop.gnome.enable = false;
}
