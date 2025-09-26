# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    #inputs.qiwi-minecraft-modpack.nixosModules.server
    #inputs.qiwi-minecraft-modpack.nixosModules.drasl

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ./networking.nix
    ../locale.nix
    ../nixpkgs.nix
    ../plasma-desktop.nix
    ../ddcci.nix
    ../yubikey.nix
    ../base-system.nix
    ../ld.nix
    ../virt.nix
    ../zapret.nix
    ../k3s.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = with pkgs; [
    apparmor-utils
  ];

}
