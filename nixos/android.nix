{ config, pkgs, ...}: {
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  #boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0003", MODE="0666", TAG+="uaccess"
  '';
}
