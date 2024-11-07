{
  lib,
  config,
  ...
}: {
  options = {
    # Install and enable mesa default drivers
    neve.hardware.gpu.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  # Generic Mesa Configurations
  config = lib.mkIf config.neve.hardware.gpu.enable {
    hardware = {
      graphics = {
        # Enable generic graphics support
        enable = true;
      };
    };
  };
}
