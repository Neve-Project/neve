{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.packages.basepkgs.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        It installs basepkgs for the system.
      '';
      example = "false";
    };
  };

  # Enable basepkgs
  config = lib.mkIf config.neve.packages.basepkgs.enable {
    environment = {
      defaultPackages = [];
      systemPackages = with pkgs; [
        vim
        wget
        git
      ];
    };
  };
}
