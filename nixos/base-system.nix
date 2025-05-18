{ pkgs, ... }: {
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.git.enable = true;

  # The kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # Sysrq
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

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
    cntr
    appimage-run
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

  users.users.quitzka = {
    isNormalUser = true;
    description = "quitzka";
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
    extraGroups = [ "networkmanager" "wheel" "i2c" "libvirtd" "dialout" "plugdev" ];
    shell = pkgs.zsh;
  };

  # Preload
  services.preload.enable = true;

  # OOM killer
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
  };

  # RTL-SDR
  #services.udev.packages = [ pkgs.rtl-sdr pkgs.ledger-udev-rules ];
  #boot.extraModprobeConfig = ''
  #  blacklist dvb_usb_rtl28xxu
  #'';
  #users.groups.plugdev = {};

  services.flatpak.enable = true;
  system.autoUpgrade.enable = true;
}
