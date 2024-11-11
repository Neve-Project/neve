{
  lib,
  config,
  pkgs,
  ...
}: let
  # cockpitOverlay = self: super: {
  #   cockpit = super.cockpit.overrideAttrs (oldAttrs: {
  #     postInstall = ''
  #       rm -rf $out/usr/share/cockpit/packagekit/
  #     '';
  #   });
  # };
  cockpit-apps = pkgs.callPackage ./cockpitPkgs/default.nix {inherit pkgs;};
in {
  options = {
    neve.services.server.cockpit.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.neve.services.server.cockpit.enable {
    # nixpkgs.overlays = [cockpitOverlay];
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
      # cockpit-apps.podman-containers
      # cockpit-apps.virtual-machines
    ];
  };
}
