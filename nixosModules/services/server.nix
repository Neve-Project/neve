{
  lib,
  config,
  pkgs,
  pkgs-neve,
  ...
}: let
  cockpitOverlay = self: super: {
    cockpit = super.cockpit.overrideAttrs (oldAttrs: {
      postInstall = ''
        rm -rf $out/share/cockpit/packagekit/
        rm -rf $out/share/cockpit/selinux/
        rm -rf $out/share/cockpit/playground/
        cp -r ${pkgs-neve.cockpit-podman}/share/cockpit/* $out/share/cockpit/
        cp -r ${pkgs-neve.cockpit-podman}/share/metainfo/* $out/share/metainfo/
        cp -r ${pkgs-neve.cockpit-machines}/share/cockpit/* $out/share/cockpit/
        cp -r ${pkgs-neve.cockpit-machines}/share/metainfo/* $out/share/metainfo/
      '';
      buildInputs =
        oldAttrs.buildInputs
        ++ [
          pkgs-neve.cockpit-podman
          pkgs-neve.cockpit-machines
        ];
    });
  };
in {
  options = {
    neve.services.server.cockpit.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.neve.services.server.cockpit.enable {
    nixpkgs.overlays = [cockpitOverlay];
    neve.virtualisation.libvirtd.enable = lib.mkForce true;
    services.cockpit = {
      enable = true;
      package = pkgs.cockpit;
      port = 9090;
      settings = {
        WebService = {
          AllowUnencrypted = true;
        };
      };
    };
    environment.systemPackages = with pkgs; [
      kexec-tools
      pkgs-neve.cockpit-podman
      pkgs-neve.cockpit-machines
    ];
  };
}
