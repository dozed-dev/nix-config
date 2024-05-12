{ pkgs, ... }: {
  # Install git, neovim
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

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

  # Virtualization host
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}
