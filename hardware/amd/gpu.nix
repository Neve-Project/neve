# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.hardware.amd.gpu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      monitoring.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf config.neve.hardware.amd.gpu.enable {
    # Enable AMDGPU driver for xorg or xwayland
    services.xserver.videoDrivers = ["modsetting"];

    # Setup For 24.05 and older
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        # Amd vulkan support and OpenCL support
        extraPackages = with pkgs; [
          mesa
          mesa.opencl
        ];

        # Vulkan support for 32-bit
        extraPackages32 = with pkgs.driversi686Linux; [
          mesa
          mesa.opencl
        ];
      };
    };

    # Install monitoring tool
    environment = {
      systemPackages = lib.mkIf config.neve.hardware.amd.gpu.monitoring.enable [
        pkgs.nvtopPackages.amd
      ];
    };

    environment.variables = {
      VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
      OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors/rusticl.icd";
      RUSTICL_ENABLE = "radeonsi:0";
      RUSTICL_CL_VERSION = "2.1";
      RUSTICL_DEVICE_TYPE = "gpu";
    };
  };
}
