{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    neve.services.printing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf config.neve.services.printing.enable {
    # Enable Printing services
    services.printing = {
      enable = true;
      package = pkgs.cups;
    };

    # Enable autodiscovery on Lan
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
