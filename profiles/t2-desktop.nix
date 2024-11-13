{lib, ...}: {
  imports = [
    ../hardware
    ../custom/nixos
    ../nixosModules
  ];
  neve = {
    desktop.gnome.enable = lib.mkForce true;
    hardware = {
      gpu.enable = lib.mkForce true;
      apple.apple-t2 = {
        enable = lib.mkForce true;
      };
    };
    config = {
      peripherals.touchpad.enable = lib.mkForce true;
      audio.pipewire.enable = lib.mkForce true;
      network.bluetooth.enable = lib.mkForce true;
    };
    virtualisation.container = {
      enable = lib.mkForce true;
      podman.enable = lib.mkForce true;
      distrobox.enable = lib.mkForce true;
    };
    services.printing.enable = lib.mkForce true;
  };
}
