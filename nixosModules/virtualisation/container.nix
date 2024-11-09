{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    neve.virtualisation.container = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      podman.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      distrobox.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf config.neve.virtualisation.container.enable {
    virtualisation = {
      containers.enable = true;
      podman = lib.mkIf config.neve.virtualisation.container.podman.enable {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    environment = {
      systemPackages = with pkgs;
        lib.optionals (config.neve.virtualisation.container.podman.enable) [
          podman-compose
        ]
        ++ lib.optionals (config.neve.virtualisation.container.distrobox.enable) [
          distrobox
        ];
    };
    users.users.${config.neve.config.username} = lib.mkIf config.neve.virtualisation.container.podman.enable {
      packages = with pkgs; [
        podman-tui
        pods
      ];
    };
  };
}
