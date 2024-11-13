{
  lib,
  config,
  ...
}: {
  options = {
    neve.config = {
      # Setup the system locale (Address type, numeric, telephone, time, monetary...)
      locale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = ''
          This option sets up your locale.
          It sets: LC_ADDRESS, LC_IDENTIFICATION,
          LC_MEASUREMENT, LC_MONETARY, LC_NAME,
          LC_NUMERIC, LC_PAPER, LC_TELEPHONE, LC_TIME.
        '';
        example = "it_IT.UTF-8";
      };

      # Setup the keyboard layout
      keyboardLayout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = ''
          This option sets up your keyboard layout
        '';
        example = "it";
      };

      # Setup the system timezone
      timezone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/London";
        description = ''
          This option sets up your timezone
        '';
        example = "Europe/Rome";
      };
    };
  };

  # Locale, language and layout configurations
  config = {
    # Timezone config
    time.timeZone = config.neve.config.timezone;

    # Keyboard layout setup
    console = {
      keyMap = config.neve.config.keyboardLayout;
    };

    # System locale setup
    i18n = {
      defaultLocale = config.neve.config.locale;
      extraLocaleSettings = {
        LC_ADDRESS = config.neve.config.locale;
        LC_IDENTIFICATION = config.neve.config.locale;
        LC_MEASUREMENT = config.neve.config.locale;
        LC_MONETARY = config.neve.config.locale;
        LC_NAME = config.neve.config.locale;
        LC_NUMERIC = config.neve.config.locale;
        LC_PAPER = config.neve.config.locale;
        LC_TELEPHONE = config.neve.config.locale;
        LC_TIME = config.neve.config.locale;
      };
    };
  };
}
