{
  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    self,
    ...
  } @ inputs: let
    # -------------------------------------------------------------------
    inherit (nixpkgs) lib;
    currentSystem = "x86_64-linux";
    pkgs = import nixpkgs {system = currentSystem;};
    pkgs-unstable = import nixpkgs-unstable {system = currentSystem;};
  in {
    # -------------------- NixOS Configuration --------------------------
    nixosConfigurations = {
      desktop = lib.nixosSystem {
        system = currentSystem;
        modules = [
          ./profiles/desktop.nix
        ];
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
      };
    };
  };

  # -------------------Inputs -----------------------------------------
  inputs = {
    # ------------------ NixPkgs ----------------------------------------
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # ------------------ Nevica ------------------------------------------
    nevica = {
      url = "github:matteocavestri/nevica";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
}
