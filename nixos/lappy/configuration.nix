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

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./networking.nix
    #./fprint.nix

    ../locale.nix
    ../nixpkgs.nix
    ../plasma-desktop.nix
    #../yubikey.nix
    ../base-system.nix
  ];

  hardware.graphics.enable32Bit = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/03e38f93-77dc-442f-960d-b226e94a56cb"; # unlocked dm-crypt partition
  boot.kernelParams = ["resume_offset=16336896"];

  system.autoUpgrade.enable = true;
}
