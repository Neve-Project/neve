# SPDX-License-Identifier: GPL-2.0-or-later
{
  lib,
  fetchFromGitLab,
  pkgs,
}:
# don't bother to provide Darwin deps
((pkgs.callPackage ./vendor {
    OpenGL = null;
    Xplugin = null;
  })
  .override {
    galliumDrivers = ["swrast" "asahi"];
    vulkanDrivers = ["swrast" "asahi"];
    enableGalliumNine = false;
    # libclc and other OpenCL components are needed for geometry shader support on Apple Silicon
    enableOpenCL = true;
  })
.overrideAttrs (oldAttrs: {
  # version must be the same length (i.e. no unstable or date)
  # so that system.replaceRuntimeDependencies can work
  version = "24.3.0";

  src = fetchFromGitLab {
    # tracking: https://pagure.io/fedora-asahi/mesa/commits/asahi
    domain = "gitlab.freedesktop.org";
    owner = "asahi";
    repo = "mesa";
    rev = "asahi-20241111";
    hash = "sha256-WRykReDv8XekkumfLqc4P+p+OVYrjUF+bLfAKtx9zTc=";
  };

  mesonFlags =
    # remove flag to configure xvmc functionality as having it
    # breaks the build because that no longer exists in Mesa 23
    (lib.filter (x:
      !(
        (lib.hasPrefix "-Dxvmc-libs-path=" x)
        || (lib.hasPrefix "-Ddri-search-path=" x)
        || (lib.hasPrefix "-Domx-libs-path=" x)
      ))
    oldAttrs.mesonFlags)
    ++ [
      # we do not build any graphics drivers these features can be enabled for
      "-Dgallium-va=disabled"
      "-Dgallium-vdpau=disabled"
      "-Dgallium-xa=disabled"
      # does not make any sense
      "-Dandroid-libbacktrace=disabled"
      "-Dintel-rt=disabled"
      # do not want to add the dependencies
      "-Dlibunwind=disabled"
      "-Dlmsensors=disabled"
    ];

  # replace patches with ones tweaked slightly to apply to this version
  patches = [
    ./disk_cache-include-dri-driver-path-in-cache-key.patch
    ./opencl.patch
  ];
})
