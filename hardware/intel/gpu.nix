# SPDX-License-Identifier: GPL-2.0-or-later
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
        description = ''
          It enables Intel GPU drivers. This option enables
          OpenGL, Vulkan and OpenCL drivers.
        '';
        example = "true";
      };

      # Intel GPU Version (1st to ...)
      # Tiger Lake generation (11) changes Vaapi and QuickSync Driver
      version = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = ''
          Set your own Intel CPU/GPU version to install the appropriate graphic drivers.
          It starts from intel core 1st generation.
        '';
        example = "11";
      };

      # Enable IntelGPU Monitoring
      monitoring.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          This option installs intel monitoring suite.
          (intel_gpu_top and nvtop).
        '';
        example = "true";
      };
    };
  };

  # Intel GPU Configuration
  config = lib.mkIf config.neve.hardware.intel.gpu.enable {
    # Apply xserver video drivers
    services.xserver.videoDrivers = ["modsetting"];

    # Enable Unfree packages (Needed for QuickSync support)
    nixpkgs.config.allowUnfree = true;

    # Override intel vaapi driver
    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs;
        # Intel graphics driver for GPUs older than Tiger Lake (AKA 11st gen)
          lib.optionals (config.neve.hardware.intel.gpu.version < 5) [
            # OpenGL Driver
            libvdpau-va-gl
            libGLU
            # Intel Vaapi Driver
            intel-vaapi-driver
            # Intel QuickSync Driver (Unfree)
            intel-media-sdk
            # Intel OpenCL Driver
            intel-ocl
          ]
          # Intel graphics driver for GPUs between Broadwell and Tiger Lake
          ++ lib.optionals (config.neve.hardware.intel.gpu.version >= 5 && config.neve.hardware.intel.gpu.version <= 11) [
            # OpenGL Driver
            libvdpau-va-gl
            libGLU
            # Vaapi driver
            intel-media-driver
            # Intel QuickSync Driver (Unfree)
            intel-media-sdk
            # Intel OpenCL Driver
            intel-ocl
          ]
          # Intel graphics driver for GPUs newer than Tiger Lake
          ++ lib.optionals (config.neve.hardware.intel.gpu.version > 11) [
            # OpenGL Driver
            libvdpau-va-gl
            libGLU
            # Vaapi driver
            intel-media-driver
            # Intel QuickSync Driver (Unfree)
            vpl-gpu-rt
            # Intel OpenCL Driver
            intel-ocl
          ];

        # VA-API support for 32-bit for both before and after Tiger Lake
        extraPackages32 = with pkgs.pkgsi686Linux;
          lib.optionals (config.neve.hardware.intel.gpu.version < 5)
          [
            intel-vaapi-driver
          ]
          ++ lib.optionals (config.neve.hardware.intel.gpu.version >= 5) [
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
          if (config.neve.hardware.intel.gpu.version >= 5)
          then "iHD"
          else "i965"
        );
        # OpenCL vendors path
        OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors";
      };
    };
  };
}
