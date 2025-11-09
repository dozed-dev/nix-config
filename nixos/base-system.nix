{ pkgs, ... }: {

  services.v2raya = {
    enable = true;
    cliPackage = pkgs.stable.xray;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.git.enable = true;

  # The kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # Sysrq
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # Other basic system utils
  environment.systemPackages = with pkgs; [
    wget
    pciutils
    htop
    sshfs
    ripgrep
    fd
    file
    tree
    killall
    cntr
    lsof
    cntr
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
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDjBF39he6/uZfi/1u4AFiXRpGMjLhphCAMeV+cw1O0bAAAABHNzaDo= Yubikey 5 NFC"
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

  services.udev.packages = [ pkgs.saleae-logic-2 ];
  #users.groups.plugdev = {};

  services.flatpak.enable = true;
  system.autoUpgrade.enable = true;
}
