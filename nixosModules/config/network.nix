# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  ...
}: {
  options = {
    neve.config.network = {
      # Setup default network Hostname
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = ''
          This option sets up your network hostname
        '';
        example = "BestPCEver";
      };

      # Enable Wireguard Client Support (checkReversePath set to false)
      wireguardSupport.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          This option disables checkReversePath if set to true.
          This is necessary for wireguard client support.
        '';
        example = "false";
      };

      # wifiBackend (iwd by default --> Better WPA3 support than wpasupplicant)
      wifiBackend = lib.mkOption {
        type = lib.types.str;
        default = "iwd";
        description = ''
          It sets up your wifi backend. By default it is iwd
          because of better support with WPA3 access points.
          It also supports wpa_supplicant
        '';
        example = "wpa_supplicant";
      };

      # Enable Bluetooth support
      bluetooth.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          It enables bluetooth support using bluetoothctl.
        '';
        example = "true";
      };
    };
  };

  # Networking Configurations
  config = {
    # It adds default user to networkmanager group
    users.users.${config.neve.config.username}.extraGroups = ["networkmanager"];
    networking = {
      # Setup the default network hostname
      hostName = config.neve.config.network.hostname;
      networkmanager = {
        enable = true;

        # Setup wifi backend (iwd, wpa_supplicant or null)
        wifi.backend = config.neve.config.network.wifiBackend;
      };

      # iwd wifi backend setup
      wireless.iwd = lib.mkIf (config.neve.config.network.wifiBackend == "iwd") {
        enable = true;
        settings.General.EnableNetworkConfiguration = true;
      };

      # Wireguard Support by disabling checkReversePath
      firewall.checkReversePath = lib.mkIf config.neve.config.network.wireguardSupport.enable false;
    };

    # Bluetooth Support
    hardware.bluetooth = lib.mkIf config.neve.config.network.bluetooth.enable {
      enable = true;
      powerOnBoot = true;
    };
  };
}
