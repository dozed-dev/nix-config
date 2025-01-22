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
    inputs.microvm.nixosModules.host
    inputs.qiwi-minecraft-modpack.nixosModules.server
    inputs.qiwi-minecraft-modpack.nixosModules.drasl

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ./networking.nix
    ./microvm.nix
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
  boot.kernelPackages = pkgs.linuxPackages;

  # Emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Sysrq
  boot.kernel.sysctl = {
    "kernel.sysrq" = 128;
  };

  hardware.graphics = let fn = oldAttrs: {
    patches = oldAttrs.patches ++ [
      (pkgs.writeText "crash-fix.patch" ''
diff --git a/src/gallium/drivers/radeonsi/si_pipe.c b/src/gallium/drivers/radeonsi/si_pipe.c
index 1e97b19..519a9e5 100644
--- a/src/gallium/drivers/radeonsi/si_pipe.c
+++ b/src/gallium/drivers/radeonsi/si_pipe.c
@@ -200,6 +200,9 @@ static void si_destroy_context(struct pipe_context *context)
 {
    struct si_context *sctx = (struct si_context *)context;
 
+   context->set_debug_callback(context, NULL);
+
+
    /* Unreference the framebuffer normally to disable related logic
     * properly.
     */

      '')
    ];
    #lib.filter (p: !builtins.match ".*cross_clc.patch.*" p)
  };
  in {
    enable = true;
    package = (pkgs.mesa.overrideAttrs fn).drivers;
    package32 = (pkgs.pkgsi686Linux.mesa.overrideAttrs fn).drivers;
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
