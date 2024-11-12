{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    neve.virtualisation.libvirtd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf config.neve.virtualisation.libvirtd.enable {
    environment.systemPackages = with pkgs; [
      spice
      spice-protocol
      win-virtio
      win-spice
      virt-manager
    ];
    virtualisation = {
      libvirtd = {
        enable = true;
        package = pkgs.libvirt;

        # Main Qemu config
        qemu = {
          package = pkgs.qemu_full;
          runAsRoot = false;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              })
              .fd
            ];
          };
        };
        allowedBridges = [
          "nm-bridge"
          "virbr0"
        ];
      };
      spiceUSBRedirection.enable = true; # Provide USB redirection support
    };
    services.spice-vdagentd.enable = true;
    users.users.${config.neve.config.username}.extraGroups = ["libvirtd"];
  };
}
