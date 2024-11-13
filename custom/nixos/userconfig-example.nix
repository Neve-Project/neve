{lib, ...}: {
  neve = {
    config = {
      locale = lib.mkForce "it_IT.UTF-8";
      keyboardLayout = lib.mkForce "it";
      timezone = lib.mkForce "Europe/Rome";
      username = lib.mkForce "YOUR-USERNAME";
      network.hostname = lib.mkForce "YOUR-HOSTNAME";
    };
  };
}
