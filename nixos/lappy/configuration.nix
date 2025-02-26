# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./networking.nix
    ./fprint.nix

    ../locale.nix
    ../nixpkgs.nix
    ../plasma-desktop.nix
    ../yubikey.nix
    ../base-system.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # Sysrq
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  users.users.quitzka = {
    isNormalUser = true;
    description = "quitzka";
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
    extraGroups = [ "networkmanager" "wheel" "i2c" "libvirtd" "dialout" "plugdev" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    apparmor-utils
  ];

  system.autoUpgrade.enable = true;
}
