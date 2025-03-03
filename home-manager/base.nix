# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./shell/zsh.nix
    ./helix.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.nekoray
      outputs.overlays.rembg
      inputs.fjordlauncher.overlays.default
      outputs.overlays.stable-packages
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "quitzka";
    homeDirectory = "/home/quitzka";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Network tools
    waypipe
    wireguard-tools
    dig
    iperf3
    inetutils
    nmap
    unstable.yt-dlp

    # GUI Tools
    yubikey-manager
    yubikey-manager-qt
    remmina
    nekoray
    helvum
    kdePackages.partitionmanager
    kdePackages.filelight

    # Desktop/media
    unstable.telegram-desktop
    mumble
    unstable.firefox
    ungoogled-chromium
    unstable.tor-browser
    mpv
    obs-studio
    qbittorrent
    unar
    ffmpeg-full
    #f3d
    #rembg

    # Prod
    krita
    kdePackages.kate
    libreoffice-qt6-fresh
    #orca-slicer
    unstable.freecad

    # Dev
    lazygit
    python3
    minicom
    usbutils

    # LSP
    unstable.nixd
    unstable.nodePackages.bash-language-server

    # Theming
    kdePackages.kde-gtk-config
    kdePackages.qtstyleplugin-kvantum
    plasma5Packages.qtstyleplugin-kvantum

    # Fonts
    unstable.ubuntu_font_family
    unstable.inter
    unstable.nerd-fonts.fira-code
  ];

  xdg.configFile."yt-dlp/config".text = ''
    --extractor-args "youtube:player-client=tv,mweb"
  '';

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "dozed-dev";
    userEmail = "dev.dozed@aleeas.com";
  };


  # VM host
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
