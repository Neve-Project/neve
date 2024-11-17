# SPDX-License-Identifier: GPL-2.0-or-later
{
  description = "Neve: A Customizable NixOS-based Distribution";

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nevepkgs,
    self,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    currentSystem = builtins.currentSystem;
    pkgs = import nixpkgs {system = currentSystem;};
    pkgs-unstable = import nixpkgs-unstable {system = currentSystem;};
    pkgs-neve = nevepkgs.packages.${currentSystem};
  in {
    # -------------------- Desktop Configuration --------------------------
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
      # -------------------- Workstation Configuration --------------------------
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

  # ------------------- Inputs -----------------------------------------
  inputs = {
    # --------------------- Pkgs ----------------------------------------
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nevepkgs.url = "github:Neve-Project/nevepkgs";

    # ------------------ Nevica ------------------------------------------
    nevica = {
      url = "github:matteocavestri/nevica";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # ------------------ Nix Flatpak -------------------------------------
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
}
