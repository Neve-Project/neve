# SPDX-License-Identifier: GPL-2.0-or-later
# These are example options for Apple Silicon Hardware
{lib, ...}: {
  neve = {
    hardware.apple.apple-silicon = {
      enable = lib.mkForce true;
      kernel.withRust = lib.mkDefault true;
      peripheralFirmwareDirectory = lib.mkDefault /etc/nixos/firmware;
      useExperimentalGPUDriver = lib.mkDefault true;
      experimentalGPUInstallMode = lib.mkForce "replace";
      setupAsahiSound = lib.mkDefault true;
    };
  };
}
