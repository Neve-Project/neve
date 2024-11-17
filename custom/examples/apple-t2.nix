# SPDX-License-Identifier: GPL-2.0-or-later
# These are example options for Apple T2 Hardware
{lib, ...}: {
  neve = {
    hardware = {
      apple.apple-t2.enable = lib.mkForce true;
    };
  };
}
