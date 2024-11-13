# Hardware Options (WIP)

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
