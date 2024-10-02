{ config, pkgs, ...}: {
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
}
