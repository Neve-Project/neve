{
  config,
  lib,
  ...
}: {
  options = {
    neve.system.zram.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        It enables zram as swap.
        (It uses zstd algorithm).
      '';
      example = "true";
    };
  };

  config = lib.mkIf config.neve.system.zram.enable {
    # Enable zram swap (compression in RAM)
    zramSwap = {
      enable = true;
      memoryMax = 32768000000; # 32GB
      algorithm = "zstd";
      memoryPercent = 200;
    };
  };
}
