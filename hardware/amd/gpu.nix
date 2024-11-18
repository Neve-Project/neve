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
      rocm.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      preVega.enable = lib.mkOption {
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
    # Enable AMDGPU driver
    boot.initrd.kernelModules = ["amdgpu"];

    # Enable AMDGPU driver for xorg or xwayland
    services.xserver.videoDrivers = ["amdgpu"];

    # Setup For 24.05 and older
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        driSupport = true;
        driSupport32Bit = true;
        # Amd vulkan support and OpenCL support
        extraPackages = with pkgs;
          [
            mesa
          ]
          # Rocm packages
          ++ (lib.optionals config.neve.hardware.amd.gpu.rocm.enable [
            rocmPackages.rocm-core
            rocmPackages.rocm-runtime
            rocmPackages.clr.icd
            rocmPackages.rocm-smi
            rocmPackages.rocminfo
          ]);

        # Vulkan support for 32-bit
        extraPackages32 = with pkgs.driversi686Linux; [
          mesa
        ];
      };
    };

    # Install monitoring tool
    environment = {
      systemPackages = lib.mkIf config.neve.hardware.amd.gpu.monitoring.enable [pkgs.nvtopPackages.amd];
      # Setup Rocm for Pre Vega GPUs
      variables = lib.mkIf (config.neve.hardware.amd.gpu.rocm.enable && config.neve.hardware.amd.gpu.preVega.enable) {
        ROC_ENABLE_PRE_VEGA = "1";
      };
    };

    # Make Hip libraries linked to /opt/rocm/hip
    systemd = lib.mkIf config.neve.hardware.amd.gpu.rocm.enable {
      tmpfiles.rules = let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
        };
      in [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ];
    };
  };
}