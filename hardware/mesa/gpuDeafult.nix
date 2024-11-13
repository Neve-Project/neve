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
      description = ''
        This option installs the default Mesa drivers.
        (This is enabled by default if you use a desktop profile).
      '';
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
