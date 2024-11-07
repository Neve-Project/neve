{
  lib,
  config,
  pkgs,
  ...
}: {
  neve = {
    config = {
      locale = lib.mkForce "it_IT.UTF-8";
      keyboardLayout = lib.mkForce "it";
      timezone = lib.mkForce "Europe/Rome";
      username = lib.mkForce "matteocavestri";
      peripherals.backlight.enable = lib.mkForce true;
      network = {
        hostname = lib.mkForce "nixos-t2";
        bluetooth.enable = lib.mkForce true;
      };
    };
    hardware = {
      apple.apple-t2 = {
        enable = lib.mkForce true;
      };
      intel = {
        cpu.enable = lib.mkForce true;
        gpu.enable = lib.mkForce true;
      };
    };
  };
  users.users.${config.neve.config.username} = {
    packages = with pkgs; [
      delfin
    ];
  };
}
