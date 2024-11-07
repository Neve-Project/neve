{
  lib,
  config,
  ...
}: {
  options = {
    neve.config.audio = {
      pipewire = {
        # Enable Pipewire support as audio/video backend
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        # Enable Asa 32 Bit support
        alsa32.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      # Enable Pulseaudio as audio backend
      pulseaudio.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  # Audio Configurations
  config = {
    # Pulseaudio configuration
    hardware.pulseaudio.enable = lib.mkIf config.neve.config.audio.pulseaudio.enable true;

    # Pipewire configuration
    services.pipewire = lib.mkIf config.neve.config.audio.pipewire.enable {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = lib.mkIf config.neve.config.audio.pipewire.alsa32.enable true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    # RealtimeKit is enabled if sound is enabled
    security.rtkit.enable = lib.mkIf (config.neve.config.audio.pipewire.enable || config.neve.config.audio.pulseaudio.enable) true;
  };
}
