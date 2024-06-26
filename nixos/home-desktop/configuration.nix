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

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../locale.nix
    ../nixpkgs.nix
    ../plasma-desktop.nix
    ../ddcci.nix
    ../yubikey.nix
    ../base-system.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "clearcpuid=304" # Disable AVX-512 to play The Finals
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.firewall.enable = false;
  networking.hostName = "home-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
