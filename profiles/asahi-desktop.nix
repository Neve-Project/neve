# SPDX-License-Identifier: GPL-2.0-or-later
{lib, ...}: {
  imports = [
    ../hardware
    ../custom/nixos
    ../nixosModules
  ];
  neve = {
    desktop.gnome.enable = lib.mkForce true;
    config = {
      peripherals.touchpad.enable = lib.mkForce true;
    };
    virtualisation.container = {
      enable = lib.mkForce true;
      podman.enable = lib.mkForce true;
      distrobox.enable = lib.mkForce true;
    };
    services.printing.enable = lib.mkForce true;
    packages.libreoffice.enable = lib.mkForce true;
    hardware.apple.apple-silicon = {
      enable = lib.mkForce true;
      kernel.withRust = lib.mkDefault true;
      peripheralFirmwareDirectory = lib.mkDefault /etc/nixos/firmware;
      useExperimentalGPUDriver = lib.mkDefault true;
      experimentalGPUInstallMode = lib.mkForce "replace";
      setupAsahiSound = lib.mkDefault true;
    };
  };
}
