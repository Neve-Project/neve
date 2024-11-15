# Hardware Options (WIP)

## apple/apple-silicon/modules/default.nix

### neve.hardware.apple.apple-silicon.enable

- **type**: bool
- **default**: true
- **description**: Enable the basic Asahi Linux components, such as kernel and boot setup.

### neve.hardware.apple.apple-silicon.pkgsSystem

- **type**: str
- **default**: aarch64-linux
- **description**: System architecture that should be used to build the major Asahi
  packages, if not the default aarch64-linux. This allows installing from
  a cross-built ISO without rebuilding them during installation.

### neve.hardware.apple.apple-silicon.pkgs

- **type**: raw
- **default**:
- **description**: Package set used to build the major Asahi packages. Defaults to the
  ambient set if not cross-built, otherwise re-imports the ambient set
  with the system defined by `neve.hardware.apple.apple-silicon.pkgsSystem`.

### neve.hardware.apple.apple-silicon.overlay

- **type**:
- **default**:
- **description**:

## apple/apple-silicon/modules/boot-m1n1/default.nix

### neve.hardware.apple.apple-silicon.boot.m1n1ExtraOptions

- **type**: str
- **default**:
- **description**: Append extra options to the m1n1 boot binary. Might be useful for fixing
  display problems on Mac minis.
  https://github.com/AsahiLinux/m1n1/issues/159

### neve.hardware.apple.apple-silicon.boot.m1n1CustomLogo

- **type**: nullOr lib.types.path
- **default**: null
- **description**: Custom logo to build into m1n1. The path must point to a 256x256 PNG.

## apple/apple-silicon/modules/kernel/default.nix

### neve.hardware.apple.apple-silicon.kernel.withRust

- **type**: bool
- **default**: false
- **description**: Build the Asahi Linux kernel with Rust support.

## apple/apple-silicon/modules/mesa/default.nix

### neve.hardware.apple.apple-silicon.useExperimentalGPUDriver

- **type**: bool
- **default**: false
- **description**: Use the experimental Asahi Mesa GPU driver.

Do not report issues using this driver under NixOS to the Asahi project.

### neve.hardware.apple.apple-silicon.experimentalGPUInstallMode

- **type**: enum \["driver" "replace" "overlay"\]
- **default**: replace
- **description**: Mode to use to install the experimental GPU driver into the system.

driver: install only as a driver, do not replace system Mesa.
Causes issues with certain programs like Plasma Wayland.

replace (default): use replaceRuntimeDependencies to replace system Mesa with Asahi Mesa.
Does not work in pure evaluation context (i.e. in flakes by default).

overlay: overlay system Mesa with Asahi Mesa
Requires rebuilding the world.

## apple/apple-silicon/modules/peripheral-firmware/default.nix

### options.neve.hardware.apple.apple-silicon.extractPeripheralFirmware

- **type**: bool
- **default**: true
- **description**: Automatically extract the non-free non-redistributable peripheral
  firmware necessary for features like Wi-Fi.

### options.neve.hardware.apple.apple-silicon.peripheralFirmwareDirectory

- **type**: nullOr lib.types.path
- **default**:
- **description**: Path to the directory containing the non-free non-redistributable
  peripheral firmware necessary for features like Wi-Fi. Ordinarily, this
  will automatically point to the appropriate location on the ESP. Flake
  users and those interested in maximum purity will want to copy those
  files elsewhere and specify this manually.

Currently, this consists of the files `all-firmware.tar.gz` and
`kernelcache*`. The official Asahi Linux installer places these files
in the `asahi` directory of the EFI system partition when creating it.

## apple/apple-silicon/modules/sound/default.nix

### options.neve.hardware.apple.apple-silicon.setupAsahiSound

- **type**: bool
- **default**: config.neve.hardware.apple.apple-silicon.enable
- **description**: Set up the Asahi DSP components so that the speakers and headphone jack
  work properly and safely.

## apple/apple-t2/default.nix

### neve.hardware.apple.apple-t2.enable

- **type**: bool
- **default**: false
- **description**: Enable all Apple T2 support.
  This includes custom kernel build.
- **example**: true

### neve.hardware.apple.apple-t2.enableAppleSetOsLoader

- **type**: bool
- **default**: false
- **description**: Whether to enable the appleSetOsLoader activation script.
  Disabled by default. It may cause instabilities.
- **example**: true

### neve.hardware.apple.apple-t2.enableTinyDfr

- **type**: bool
- **default**: true
- **description**: Whether to enable the tiny-dfr touchbar service.
- **example**: true

## intel/cpu.nix

### neve.hardware.intel.cpu.enable

- **type**: bool
- **default**: false
- **description**: It enables Intel CPU specific capabilities
  (kvm-intel as kernel Module and thermald for laptops)
- **example**: true

## intel/gpu.nix

### neve.hardware.intel.gpu.enable

- **type**: bool
- **default**: false
- **description**: It enables Intel GPU drivers. This option enables
  OpenGL, Vulkan and OpenCL drivers.
- **example**: true

### neve.hardware.intel.gpu.version

- **type**: int
- **default**: 1
- **description**: Set your own Intel CPU/GPU version to install the appropriate graphic drivers.
  It starts from intel core 1st generation.
- **example**: 11

### neve.hardware.intel.gpu.monitoring.enable

- **type**: bool
- **default**: false
- **description**: This option installs intel monitoring suite.
  (intel_gpu_top and nvtop).
- **example**: true

## mesa/gpuDeafult.nix

### neve.hardware.gpu.enable

- **type**: bool
- **default**: false
- **description**: This option installs the default Mesa drivers.
  (This is enabled by default if you use a desktop profile).
