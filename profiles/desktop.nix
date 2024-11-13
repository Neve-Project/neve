# SPDX-License-Identifier: GPL-2.0-or-later
{lib, ...}: {
  imports = [
    ../hardware
    ../custom/nixos
    ../nixosModules
  ];
  neve = {
    hardware.gpu.enable = lib.mkForce true;
    desktop.gnome.enable = lib.mkForce true;
    config = {
      peripherals.touchpad.enable = lib.mkForce true;
      audio.pipewire.enable = lib.mkForce true;
    };
    virtualisation.container = {
      enable = lib.mkForce true;
      podman.enable = lib.mkForce true;
      distrobox.enable = lib.mkForce true;
    };
    services.printing.enable = lib.mkForce true;
    packages.libreoffice.enable = lib.mkForce true;
  };
}
