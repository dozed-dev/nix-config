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
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    #inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.chaotic.nixosModules.default
    inputs.qiwi-minecraft-modpack.nixosModules.server
    inputs.qiwi-minecraft-modpack.nixosModules.drasl

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ./networking.nix
    ../nfs-sharing.nix
    ../locale.nix
    ../nixpkgs.nix
    ../plasma-desktop.nix
    ../ddcci.nix
    ../yubikey.nix
    ../base-system.nix
    ../android.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Sysrq
  boot.kernel.sysctl = {
    "kernel.sysrq" = 128;
  };

  users.users.quitzka = {
    isNormalUser = true;
    description = "quitzka";
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
    extraGroups = [ "networkmanager" "wheel" "i2c" "libvirtd" "dialout" "plugdev" ];
  };

  environment.systemPackages = with pkgs; [
    apparmor-utils
  ];

  system.autoUpgrade.enable = true;
}
