{
  config,
  lib,
  pkgs,
  ...
}: let
  # Substituters for Apple T2
  substituters = ["https://cache.soopy.moe"];

  # Setup better audio for Apple T2
  audioFiles = pkgs.fetchFromGitHub {
    owner = "kekrby";
    repo = "t2-better-audio";
    rev = "e46839a28963e2f7d364020518b9dac98236bcae";
    hash = "sha256-x7K0qa++P1e1vuCGxnsFxL1d9+nwMtZUJ6Kd9e27TFs=";
  };

  # Setup Udev rules to audio files
  audioFilesUdevRules = pkgs.runCommand "audio-files-udev-rules" {} ''
    mkdir -p $out/lib/udev/rules.d
    cp ${audioFiles}/files/*.rules $out/lib/udev/rules.d
    substituteInPlace $out/lib/udev/rules.d/*.rules --replace "/usr/bin/sed" "${pkgs.gnused}/bin/sed"
  '';

  # Override Audio Files
  overrideAudioFiles = package: pluginsPath:
    package.overrideAttrs (new: old: {
      preConfigurePhases = old.preConfigurePhases or [] ++ ["postPatchPhase"];
      postPatchPhase = ''
        cp -r ${audioFiles}/files/{profile-sets,paths} ${pluginsPath}/alsa/mixer/
      '';
    });

  # pipewire package definition
  pipewirePackage = overrideAudioFiles pkgs.pipewire "spa/plugins/";

  # tiny-dfr package definition
  tiny-dfrPackage = pkgs.callPackage ./pkgs/tiny-dfr {};

  # Apple osLoader Installer (Disabled by default)
  apple-set-os-loader-installer = pkgs.stdenv.mkDerivation {
    name = "apple-set-os-loader-installer-1.0";
    src = pkgs.fetchFromGitHub {
      owner = "Redecorating";
      repo = "apple_set_os-loader";
      rev = "r33.9856dc4";
      sha256 = "hvwqfoF989PfDRrwU0BMi69nFjPeOmSaD6vR6jIRK2Y=";
    };
    buildInputs = [pkgs.gnu-efi];
    buildPhase = ''
      substituteInPlace Makefile --replace "/usr" '$(GNU_EFI)'
      export GNU_EFI=${pkgs.gnu-efi}
      make
    '';
    installPhase = ''
      install -D bootx64_silent.efi $out/bootx64.efi
    '';
  };
  # Make the code shorter
in {
  # Apple T2 Options definition
  options = {
    neve.hardware.apple.apple-t2 = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Enable all Apple T2 support.";
      };

      enableAppleSetOsLoader = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the appleSetOsLoader activation script.";
      };

      enableTinyDfr = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable the tiny-dfr touchbar service.";
      };
    };
  };

  # Apple T2 Configurations
  config = lib.mkIf config.neve.hardware.apple.apple-t2.enable (
    lib.mkMerge [
      {
        # For keyboard and touchbar
        boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./pkgs/kernel.nix {});
        boot.initrd.kernelModules = ["apple-bce"];

        services.udev.packages = [audioFilesUdevRules];

        # For audio
        boot.kernelParams = ["pcie_ports=compat" "intel_iommu=on" "iommu=pt"];

        hardware.pulseaudio.package = overrideAudioFiles pkgs.pulseaudio "src/modules/";

        services.pipewire.package = pipewirePackage;
        services.pipewire.wireplumber.package = pkgs.wireplumber.override {
          pipewire = pipewirePackage;
        };

        # Make sure post-resume.service exists
        powerManagement.enable = true;

        # Apple T2 kernel Substituters
        nix.settings = {
          inherit substituters;
          trusted-substituters = substituters;
          trusted-public-keys = ["hydra.soopy.moe:IZ/bZ1XO3IfGtq66g+C85fxU/61tgXLaJ2MlcGGXU8Q="];
        };

        # Apple T2 WiFi Firmware
        hardware.firmware = [
          (pkgs.stdenv.mkDerivation (final: {
            name = "brcm-firmware";
            src = /lib/firmware/brcm;
            installPhase = ''
              mkdir -p $out/lib/firmware/brcm
              cp ${final.src}/* "$out/lib/firmware/brcm"
            '';
          }))
        ];
      }
      (lib.mkIf config.neve.hardware.apple.apple-t2.enableAppleSetOsLoader {
        # Activation script to install apple-set-os-loader in order to unlock the iGPU
        system.activationScripts.appleSetOsLoader = ''
          if [[ -e /boot/efi/efi/boot/bootx64_original.efi ]]; then
            true # It's already installed, no action required
          elif [[ -e /boot/efi/efi/boot/bootx64.efi ]]; then
            # Copy the new bootloader to a temporary location
            cp ${apple-set-os-loader-installer}/bootx64.efi /boot/efi/efi/boot/bootx64_temp.efi

            # Rename the original bootloader
            mv /boot/efi/efi/boot/bootx64.efi /boot/efi/efi/boot/bootx64_original.efi

            # Move the new bootloader to the final destination
            mv /boot/efi/efi/boot/bootx64_temp.efi /boot/efi/efi/boot/bootx64.efi
          else
            echo "Error: /boot/efi/efi/boot/bootx64.efi is missing" >&2
          fi
        '';

        # Enable the iGPU by default if present
        environment.etc."modprobe.d/apple-gmux.conf".text = ''
          options apple-gmux force_igd=y
        '';
      })
      (lib.mkIf config.neve.hardware.apple.apple-t2.enableTinyDfr {
        services.udev.packages = [tiny-dfrPackage];

        systemd.services.tiny-dfr = {
          enable = true;
          description = "Tiny Apple silicon touch bar daemon";
          after = ["systemd-user-sessions.service" "getty@tty1.service" "plymouth-quit.service" "systemd-logind.service"];
          bindsTo = ["dev-tiny_dfr_display.device" "dev-tiny_dfr_backlight.device"];
          startLimitIntervalSec = 30;
          startLimitBurst = 2;
          script = "${tiny-dfrPackage}/bin/tiny-dfr";
          restartTriggers = [tiny-dfrPackage];
        };

        environment.etc."tiny-dfr/config.toml" = {
          source = "${tiny-dfrPackage}/share/tiny-dfr/config.toml";
        };
      })
    ]
  );
}
