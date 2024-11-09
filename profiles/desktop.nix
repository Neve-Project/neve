{lib, ...}: {
  imports = [
    ../hardware
    ../custom/nixos
    ../nixosModules
  ];
  neve = {
    hardware.gpu.enable = lib.mkForce true;
    config.peripherals.touchpad.enable = lib.mkForce true;
    config.audio.pipewire.enable = lib.mkForce true;
    desktop.gnome.enable = lib.mkForce true;
    virtualisation.container = {
      enable = lib.mkForce true;
      podman.enable = lib.mkForce true;
      distrobox.enable = lib.mkForce true;
    };
  };
}
