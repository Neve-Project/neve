{
  imports = [
    ./cpu.nix
    ./gpu.nix
  ];

  # Default Intel values
  neve.hardware.intel = {
    cpu.enable = false;
    gpu = {
      enable = false;
      version = "1";
      monitoring.enable = false;
    };
  };
}
