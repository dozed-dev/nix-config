{pkgs, ...}: {
  # Virtualization host
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    virtiofsd
    podman-tui
    podman-compose
    toolbox
  ];
}
