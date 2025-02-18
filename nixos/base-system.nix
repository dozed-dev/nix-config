{ pkgs, ... }: {
  # Install git, neovim
  programs.git.enable = true;

  # Set Zsh as the default user shell for all users
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Other basic system utils
  environment.systemPackages = with pkgs; [
    wget
    pciutils
    htop
    sshfs
    netcat-gnu
    ripgrep
    fd
    file
    tree
    killall
    virtiofsd
  ];

  # SSH server. Very important if you're setting up a headless system.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # Preload
  services.preload.enable = true;

  # OOM killer
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
  };

  # Virtualization host
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # RTL-SDR
  services.udev.packages = [ pkgs.rtl-sdr pkgs.ledger-udev-rules ];
  boot.extraModprobeConfig = ''
    blacklist dvb_usb_rtl28xxu
  '';
  users.groups.plugdev = {};

  services.flatpak.enable = true;
}
