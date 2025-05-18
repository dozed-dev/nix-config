# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./networking.nix
    ./disko-config.nix
    #./fprint.nix

    ../locale.nix
    ../nixpkgs.nix
    ../plasma-desktop.nix
    #../yubikey.nix
    ../base-system.nix
    ../virt.nix
  ];

  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  # Bootloader
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.extraModprobeConfig = "options thinkpad_acpi force_load=1";

  boot.resumeDevice = "/dev/disk/by-uuid/00bd9f5e-8eb8-483e-a6b4-890de72c3506"; # unlocked dm-crypt partition
  boot.kernelParams = ["resume_offset=58687488"];

  system.autoUpgrade.enable = true;
}
