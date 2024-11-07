{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.config.peripherals = {
      # Enable display brightness control
      backlight.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      # Enable touchpad and gesture support (Enabled by default)
      touchpad.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      # Enable iio sensors (brightness, accelerometer, light...)
      iio.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  # Configurations for sensors and embedeed peripherals
  config = {
    # Enable support for trackpads
    services.libinput.enable = lib.mkIf config.neve.config.peripherals.touchpad.enable true;

    # Enable support for iio sensors (light, accelerometer, etc)
    hardware.sensor.iio.enable = lib.mkIf config.neve.config.peripherals.iio.enable true;

    # Install brightnessctl to control monitors brightness
    environment = lib.mkIf config.neve.config.peripherals.backlight.enable {
      systemPackages = with pkgs; [
        brightnessctl
      ];
    };
  };
}
