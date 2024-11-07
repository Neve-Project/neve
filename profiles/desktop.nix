{lib, ...}: {
  imports = [
    ../hardware/default.nix
    ../custom/nixos/default.nix
    ../nixosModules/default.nix
  ];
  neve = {
    hardware.gpu.enable = lib.mkForce true;
    config.peripherals.touchpad.enable = lib.mkForce true;
    config.audio.pipewire.enable = lib.mkForce true;
    desktop.gnome.enable = lib.mkForce true;
  };
}
