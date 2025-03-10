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
    ./fprint.nix

    ../locale.nix
    ../nixpkgs.nix
    ../plasma-desktop.nix
    #../yubikey.nix
    ../base-system.nix
  ];

  hardware.graphics.enable32Bit = true;

  system.autoUpgrade.enable = true;
}
