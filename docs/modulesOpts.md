# Modules Options (WIP)

## config/audio.nix

### neve.config.audio.pipewire.enable

- **type**: bool
- **default**: false
- **description**: It enables pipeware as audio backend.
  (This is default to true if you are using a desktop profile).
- **example**: true

### neve.config.audio.pipewire.alsa32.enable

- **type**: bool
- **default**: false
- **description**: It enables Alsa audio support for 32 bit programs.
- **example**: true

### neve.config.audio.pulseaudio.enable

- **type**: bool
- **default**: false
- **description**: It enables pulseaudio as audio backend.
- **example**: true

## config/locale.nix

### neve.config.locale

- **type**: str
- **default**: en_US.UTF-8
- **description**: This option sets up your locale.
  It sets: LC_ADDRESS, LC_IDENTIFICATION,
  LC_MEASUREMENT, LC_MONETARY, LC_NAME,
  LC_NUMERIC, LC_PAPER, LC_TELEPHONE, LC_TIME.
- **example**: it_IT.UTF-8

### neve.config.keyboardLayout

- **type**: str
- **default**: us
- **description**: This option sets up your keyboard layout
- **example**: it

### neve.config.timezone

- **type**: str
- **default**: Europe/London
- **description**: This option sets up your timezone
- **example**: Europe/Rome

## config/network.nix

### neve.config.network.hostname

- **type**: str
- **default**: nixos
- **description**: This option sets up your network hostname
- **example**: BestPCEver

### neve.config.network.wireguardSupport.enable

- **type**: bool
- **default**: true
- **description**: This option disables checkReversePath if set to true.
  This is necessary for wireguard client support.
- **example**: false

### neve.config.network.wifiBackend

- **type**: str
- **default**: iwd
- **description**: It sets up your wifi backend. By default it is iwd
  because of better support with WPA3 access points.
  It also supports wpa_supplicant
- **example**: wpa_supplicant

### neve.config.network.bluetooth.enable

- **type**: bool
- **default**: false
- **description**: It enables bluetooth support using bluetoothctl.
- **example**: true

## config/nix.nix

### neve.config.systemVersion

- **type**: str
- **default**: 25.05
- **description**: This option specifies your NixOS base version.
  It is recommended to use the default value.
- **example**: ''24.11''

### neve.config.nix.linker.enable

- **type**: bool
- **default**: true
- **description**: This option configures the dynamic linker
  for libraries and packages under /lib
- **example**: false

### neve.config.nix.garbageCollect.enable

- **type**: bool
- **default**: true
- **description**: This option allows nix to garbage collect
  itself after 30 days
- **example**: false

## config/peripherals.nix

### neve.config.peripherals.backlight.enable

- **type**: bool
- **default**: false
- **description**: It enables screen backlight control.
- **example**: true

### neve.config.peripherals.touchpad.enable

- **type**: bool
- **default**: false
- **description**: It enables touchpad gestures (libinput).
  (It is enabled by default if you use a desktop profile)
- **example**: true

### neve.config.peripherals.iio.enable

- **type**: bool
- **default**: false
- **description**: It enables support for iio sensors.
  (brightness, accelerometer, light, ...)
- **example**: true

## config/users.nix

### neve.config.username

- **type**: str
- **default**: neve
- **description**: Username for the first user (1000).
  You have to set your password from root.
  (passwd YOUR_USERNAME)
- **example**: bestGuyEver

## desktop/fonts.nix

### neve.desktop.fonts.enable

- **type**: bool
- **default**: false
- **description**: This option installs different fonts.
  (liberation_ttf, inconsolata-nerdfont,
  font-awesome, noto-fonts-emoji).
  This option is enabled by default if you use a desktop profile.
- **example**: true

## desktop/gnome.nix

### neve.desktop.gnome.enable

- **type**: bool
- **default**: false
- **description**: It installs and enables Gnome and GDM.
  (Enabled by default in desktop profiles).
- **example**: true

## desktop/packages.nix

### neve.desktop.packages.enable

- **type**: bool
- **default**: false
- **description**: It install default Neve desktop packages.
  (Enabled by default if you are using a desktop profile).
- **example**: true

## desktop/services.nix

### neve.desktop.services.enable

- **type**: bool
- **default**: false
- **description**: It enables base desktop services.
  (dconf, xdg-desktop-portal, dbus, gvfs, sysprof).
- **example**: true

## desktop/wayland.nix

### neve.desktop.wayland.enable

- **type**: bool
- **default**: false
- **description**: It sets up wayland server.
- **example**: true

## packages/basepkgs.nix

### neve.packages.basepkgs.enable

- **type**: bool
- **default**: true
- **description**: It installs basepkgs for the system.
- **example**: false

## packages/flatpak.nix

### neve.packages.flatpak.enable

- **type**: bool
- **default**: false
- **description**: It installs and enable Flatpak support.
  It also adds flathub, flathub-beta,
  gnome-nightly and rhel repos.
  (Enabled by default in desktop profiles).
- **example**: true

## packages/libreoffice.nix

### neve.packages.libreoffice.enable

- **type**: bool
- **default**: false
- **description**: Installs libreoffice and english spell check.
  It is enabled by default in desktop and workstation
  profiles. You can add your spellcheck using
  hunspellDicts.{YOUR LOCALE}
- **example**: neve.packages.libreoffice.enable = true

## packages/multimedia.nix

### neve.packages.multimedia.enable

- **type**: bool
- **default**: false
- **description**: It installs multimedia codecs.
  (Enabled by default in desktop profiles).
- **example**: true

## services/printing.nix

### neve.services.printing.enable

- **type**: bool
- **default**: false
- **description**: It installs and enables CUPS server.
- **example**: true

## services/server.nix

### neve.services.server.cockpit.enable

- **type**: bool
- **default**: false
- **description**: It installs and run (9090 port) cockpit as server
  dashboard. This option builds a custom version of cockpit.
- **example**: true

## system/bootloader.nix

### neve.system.bootloader.systemdBoot.enable

- **type**: bool
- **default**: false
- **description**: This option enables systemdboot as default bootloader.
  Systemdboot is a UEFY-only bootloader.
- **example**: true

### neve.system.bootloader.grub2.enable

- **type**: bool
- **default**: true
- **description**: This option enables grub2 as default bootloader.
- **example**: false

## system/kernel.nix

### neve.system.kernel.rust.enable

- **type**: bool
- **default**: true
- **description**: This option applys rust overlays in the linux kernel.
- **example**: false

### neve.system.kernel.inotify

- **type**: int
- **default**: 512
- **description**: This option sets inotify kernel parameter.
- **example**: 1024

## system/zram.nix

### neve.system.zram.enable

- **type**: bool
- **default**: false
- **description**: It enables zram as swap.
  (It uses zstd algorithm).
- **example**: true

## virtualisation/container.nix

### neve.virtualisation.container.enable

- **type**: bool
- **default**: false
- **description**: This option enables container support
  (Enabled by default in desktop profiles).
- **example**: true

### neve.virtualisation.container.podman.enable

- **type**: bool
- **default**: false
- **description**: This option enables podman as container backend.
- **example**: true

### neve.virtualisation.container.distrobox.enable

- **type**: bool
- **default**: false
- **description**: This option installs distrobox.
  (Enabled by default in desktop profiles).
- **example**: true

## virtualisation/libvirtd.nix

### neve.virtualisation.libvirtd.enable

- **type**: bool
- **default**: false
- **description**: This option enables qemu/libvirt.
  It also adds support for win-virtio and win-spice.
- **example**: true

## virtualisation/wine.nix

### neve.virtualisation.wine.enable

- **type**: bool
- **default**: false
- **description**: Enable Wine support (Windows programs support)
- **example**: true
