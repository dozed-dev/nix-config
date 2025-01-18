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
    ../shell/zsh.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.modifications
      # If you want to use modules from other flakes (such as nixos-hardware):
      outputs.overlays.nekoray
      outputs.overlays.rembg
      inputs.fjordlauncher.overlays.default
      outputs.overlays.stable-packages
      outputs.overlays.unstable-packages
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "quitzka";
    homeDirectory = "/home/quitzka";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Network tools
    tcping-go
    waypipe
    wireguard-tools
    dig
    iperf3
    inetutils
    rs-tftpd
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
    f3d
    #rembg

    # Prod
    godot_4
    blender
    krita
    kate
    libreoffice-qt6-fresh
    orca-slicer
    unstable.freecad

    # Gaming
    steam
    lutris
    wine
    fjordlauncher

    # Dev
    neovim
    lazygit
    ansible
    python3
    android-tools
    scrcpy
    minicom
    usbutils

    # LSP
    unstable.nixd
    unstable.nodePackages.bash-language-server

    # Theming
    kde-gtk-config
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
  programs.git.enable = true;

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
  home.stateVersion = "23.11";
}
