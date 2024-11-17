# SPDX-License-Identifier: GPL-2.0-or-later
{
  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nevepkgs,
    self,
    ...
  } @ inputs: let
    # -------------------------------------------------------------------
    inherit (nixpkgs) lib;
    currentSystem = "x86_64-linux";
    pkgs = import nixpkgs {system = currentSystem;};
    pkgs-unstable = import nixpkgs-unstable {system = currentSystem;};
    pkgs-neve = nevepkgs.packages.${currentSystem};
  in {
    # -------------------- NixOS Configuration --------------------------
    nixosConfigurations = {
      desktop = lib.nixosSystem {
        system = currentSystem;
        modules = [
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ./profiles/desktop.nix
        ];
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
          inherit pkgs-neve;
        };
      };
      t2-desktop = lib.nixosSystem {
        system = currentSystem;
        modules = [
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ./profiles/t2-desktop.nix
        ];
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
          inherit pkgs-neve;
        };
      };
      asahi-desktop = lib.nixosSystem {
        system = currentSystem;
        modules = [
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ./profiles/asahi-desktop.nix
        ];
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
          inherit pkgs-neve;
        };
      };
      workstation = lib.nixosSystem {
        system = currentSystem;
        modules = [
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ./profiles/workstation.nix
        ];
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
          inherit pkgs-neve;
        };
      };
    };
  };

  # -------------------Inputs -----------------------------------------
  inputs = {
    # ------------------ NixPkgs ----------------------------------------
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nevepkgs.url = "github:Neve-Project/nevepkgs";

    # ------------------ Nevica ------------------------------------------
    nevica = {
      url = "github:matteocavestri/nevica";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
}
