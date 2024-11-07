{
  imports = [
    ./apple-t2
  ];

  neve.hardware.apple = {
    apple-t2 = {
      enable = false;
      enableAppleSetOsLoader = false;
      enableTinyDfr = true;
    };
  };
}
