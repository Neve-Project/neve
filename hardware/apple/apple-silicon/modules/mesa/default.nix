# SPDX-License-Identifier: GPL-2.0-or-later
{
  options,
  config,
  pkgs,
  lib,
  ...
}: {
  config = let
    isMode = mode: (config.neve.hardware.apple.apple-silicon.useExperimentalGPUDriver
      && config.neve.hardware.apple.apple-silicon.experimentalGPUInstallMode == mode);
  in
    lib.mkIf config.neve.hardware.apple.apple-silicon.enable (lib.mkMerge [
      {
        # required for proper DRM setup even without GPU driver
        services.xserver.config = ''
          Section "OutputClass"
              Identifier "appledrm"
              MatchDriver "apple"
              Driver "modesetting"
              Option "PrimaryGPU" "true"
          EndSection
        '';
      }
      (
        lib.mkIf config.neve.hardware.apple.apple-silicon.useExperimentalGPUDriver (
          # install the drivers
          if builtins.hasAttr "graphics" options.hardware
          then {
            hardware.graphics.package = config.neve.hardware.apple.apple-silicon.pkgs.mesa-asahi-edge.drivers;
          }
          else {
            # for 24.05
            hardware.opengl.package = config.neve.hardware.apple.apple-silicon.pkgs.mesa-asahi-edge.drivers;
          }
        )
      )
      (lib.mkIf config.neve.hardware.apple.apple-silicon.useExperimentalGPUDriver {
        # required for in-kernel GPU driver
        neve.hardware.apple.apple-silicon.kernel.withRust = true;
      })
      (lib.mkIf (isMode "replace") {
        # replace the Mesa linked into system packages with the Asahi version
        # without rebuilding them to avoid rebuilding the world.
        system.replaceRuntimeDependencies = [
          {
            original = pkgs.mesa;
            replacement = config.neve.hardware.apple.apple-silicon.pkgs.mesa-asahi-edge;
          }
        ];
      })
      (lib.mkIf (isMode "overlay") {
        # replace the Mesa used in Nixpkgs with the Asahi version using an overlay,
        # which requires rebuilding the world but ensures it is done faithfully
        # (and in a way compatible with pure evaluation)
        nixpkgs.overlays = [
          (final: prev: {
            # prevent cross-built Mesas that might be evaluated using this config (e.g. Steam emulation via box64) from using the special Asahi Mesa
            mesa =
              if prev.targetPlatform.isAarch64
              then final.mesa-asahi-edge
              else prev.mesa;
          })
        ];
      })
    ]);

  options = {
    neve.hardware.apple.apple-silicon = {
      useExperimentalGPUDriver = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Use the experimental Asahi Mesa GPU driver.

          Do not report issues using this driver under NixOS to the Asahi project.
        '';
      };

      experimentalGPUInstallMode = lib.mkOption {
        type = lib.types.enum ["driver" "replace" "overlay"];
        default = "replace";
        description = ''
          Mode to use to install the experimental GPU driver into the system.

          driver: install only as a driver, do not replace system Mesa.
            Causes issues with certain programs like Plasma Wayland.

          replace (default): use replaceRuntimeDependencies to replace system Mesa with Asahi Mesa.
            Does not work in pure evaluation context (i.e. in flakes by default).

          overlay: overlay system Mesa with Asahi Mesa
            Requires rebuilding the world.
        '';
      };
    };
  };
}
