{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.hardware.intel.gpu = {
      # Enable Intel GPU Support
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      # Intel GPU Version (1st to ...)
      # Tiger Lake generation (11) changes Vaapi and QuickSync Driver
      version = lib.mkOption {
        type = lib.types.str;
        default = "1";
      };

      # Enable IntelGPU Monitoring
      monitoring.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  # Intel GPU Configuration
  config = lib.mkIf config.neve.hardware.intel.gpu.enable {
    # Apply xserver video drivers
    services.xserver.videoDrivers = [
      "i915"
      "intel"
    ];

    # Enable Unfree packages (Needed for QuickSync support)
    nixpkgs.config.allowUnfree = true;

    # Override intel vaapi driver
    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
    };

    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs;
        # Intel graphics driver for GPUs older than Tiger Lake (AKA 11st gen)
          lib.optionals (builtins.compareVersions config.neve.hardware.intel.gpu.version "11" == -1) [
            # OpenGL Driver
            libvdpau-va-gl
            libGLU
            # Intel Vaapi Driver
            intel-vaapi-driver
            # Intel QuickSync Driver (Unfree)
            intel-media-sdk
            # Intel OpenCL Driver
            ocl-icd
          ]
          # Intel graphics driver for GPUs newer than Tiger Lake
          ++ lib.optionals (builtins.compareVersions config.neve.hardware.intel.gpu.version "11" != -1) [
            # OpenGL Driver
            libvdpau-va-gl
            libGLU
            # Vaapi driver
            intel-media-driver
            # Intel QuickSync Driver (Unfree)
            vpl-gpu-rt
            # Intel OpenCL Driver
            ocl-icd
          ];

        # VA-API support for 32-bit for both before and after Tiger Lake
        extraPackages32 = with pkgs.pkgsi686Linux;
          lib.optionals (builtins.compareVersions config.neve.hardware.intel.gpu.version "11" == -1)
          [
            intel-vaapi-driver
          ]
          ++ lib.optionals (builtins.compareVersions config.neve.hardware.intel.gpu.version "11" != -1) [
            intel-media-driver
          ];
      };
    };

    # Setup intel environment and monitoring packages
    environment = {
      systemPackages = lib.mkIf config.neve.hardware.intel.gpu.monitoring.enable [
        pkgs.nvtopPackages.intel
        pkgs.intel-gpu-tools
      ];
      variables = {
        # Video Decode and Presentation API for Unix
        VDPAU_DRIVER = "va_gl";
        # New GPUs use iHD, older only use i965
        LIBVA_DRIVER_NAME = lib.mkDefault (
          if (builtins.compareVersions config.neve.hardware.intel.gpu.version "11" != -1)
          then "iHD"
          else "i965"
        );
        # OpenCL vendors path
        OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors";
      };
    };
  };
}
