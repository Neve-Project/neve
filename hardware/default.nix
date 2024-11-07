{
  imports = [
    ./intel
    ./mesa
    ./apple
  ];

  # Default values
  neve.hardware = {
    # Intel hardware support
    intel = {
      cpu.enable = false;
      gpu = {
        enable = false;
        version = "1";
        monitoring.enable = false;
      };
    };

    # Generic Mesa GPU support
    gpu.enable = false;

    # Apple Devices and SoC support
    apple = {
      apple-t2 = {
        enable = false;
        enableAppleSetOsLoader = false;
        enableTinyDfr = true;
      };
    };
  };
}
