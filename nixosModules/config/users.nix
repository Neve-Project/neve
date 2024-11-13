{
  config,
  lib,
  ...
}: {
  options = {
    # Default Username ( You can override it from custom )
    neve.config.username = lib.mkOption {
      type = lib.types.str;
      default = "neve";
      description = ''
        Username for the first user (1000).
        You have to set your password from root.
        (passwd YOUR_USERNAME)
      '';
      example = "bestGuyEver";
    };
  };

  # Main user configuration
  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.neve.config.username} = {
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
      packages = [
      ];
    };
  };
}
