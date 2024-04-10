{ config, pkgs, ...}: {
  # Kernel modules
  boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
  boot.kernelModules = [ "ddcci" "i2c-dev" ];

  # i2c group
  users.groups.i2c = {};

  environment.systemPackages = with pkgs; [ ddcutil ];

  services.udev.packages = with pkgs; [ ddcutil ];
}
