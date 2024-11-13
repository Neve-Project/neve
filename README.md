# Neve: A Customizable NixOS-based Distribution ❄️

Welcome to **Neve**, a distribution based on **NixOS** and managed through the **Nix package manager**, designed to offer optimal hardware compatibility and customization options for every type of user. Whether you’re a beginner seeking simplicity and stability or an advanced user looking for complete control, Neve provides the tools to meet your needs.

⚠️ **Development Status:** Neve is currently in active development, with many components still being implemented. While usable, the project is recommended for **development** purposes and **contributing to the project** at this stage.

## Key Features 🚀

- **Customizable Profiles**: Currently, only the **desktop profile** is available, but additional profiles (e.g., Kubernetes, server) are coming soon.
- **Maximum Hardware Support**: Neve is optimized for a wide range of hardware, allowing for customizable configurations tailored to specific platforms.
- **Stability & Immutability**: Leverages Nix’s stability and immutability to provide a predictable environment, while still allowing advanced customization.
- **Beginner-Friendly**: Designed to be intuitive for Linux newcomers, while still offering powerful features for advanced users.
- **Granular Control**: Easily override system settings via `custom/nixos/userconfig.nix` and adjust configurations to suit your needs.

## Installation 📦

1. **Install NixOS**: Start by installing **NixOS** on either bare-metal or in a virtual machine.
1. **Clone the Neve Repository**: Clone the official **Neve** repository onto your system.
1. **Add Your Hardware Configuration**: Place your `hardware-configuration.nix` file in the `custom/nixos` directory.
1. **Create a Custom Config**: Create a `userconfig.nix` file to fully customize your Neve installation.

Refer to `custom/nixos/userconfig-example.nix` for the latest example configurations.

## Development & Contributing 🤝

Neve is actively under development, and community contributions are encouraged. Whether you’re fixing bugs, adding new features, or expanding hardware support, your input is valuable.

## Nevepkgs: Custom Packages for Neve 📦🔧

Neve includes **nevepkgs**, custom packages specifically tailored for this distribution. These packages may include overrides for `nixpkgs` or additional support for hardware components not yet available in `nixpkgs`. Contributing to `nevepkgs` is a great way to help the project grow.

## Available Options 🖥️⚙️

All currently available options for hardware and software support can be found in the `docs` directory, including detailed configurations for optimizing Neve based on your specific hardware and software needs.

## Roadmap 📝

- **Graphics Management Utilities**: Tools for easier graphical configuration and management.
- **Terminal Utilities**: Additional terminal-based tools for streamlined system management.
- **Additional Profiles**: Including Kubernetes, server, and other profiles based on user feedback.
- **Expanded Hardware Support**: Broader hardware compatibility across more devices.
- **Increase Nevepkgs**: Adding new custom packages to enrich the Neve ecosystem.

## License 📜

This project is licensed under **GNU GPL v2 or later**.

Thank you for choosing Neve! Dive into the code, contribute, and help make it even better. Happy coding! 👨‍💻🎉
