{
  config,
  lib,
  ...
}: {
  options = {
    neve.system.zram.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
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
