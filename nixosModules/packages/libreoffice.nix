# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.packages.libreoffice.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Installs libreoffice and english spell check.
        It is enabled by default in desktop and workstation
        profiles. You can add your spellcheck using
        hunspellDicts.{YOUR LOCALE}
      '';
      example = "neve.packages.libreoffice.enable = true;";
    };
  };

  config = lib.mkIf config.neve.packages.libreoffice.enable {
    users.users.${config.neve.config.username} = {
      packages = with pkgs; [
        libreoffice-fresh
        hunspell
        hunspellDicts.en_US-large
      ];
    };
  };
}
