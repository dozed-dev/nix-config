# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.modifications
      # If you want to use modules from other flakes (such as nixos-hardware):
      outputs.overlays.nekoray
      outputs.overlays.gost3
      outputs.overlays.fjordlauncher
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

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Network tools
    tcping-go
    gost3
    waypipe
    wireguard-tools
    dig
    iperf3
    inetutils
    rs-tftpd
    nmap

    # GUI Tools
    yubikey-manager
    yubikey-manager-qt
    remmina
    nekoray
    helvum

    # Desktop stuff
    telegram-desktop
    firefox
    ungoogled-chromium
    tor-browser
    kate
    krita
    mpv
    obs-studio
    qbittorrent
    unar

    # Gaming
    steam
    lutris
    wine
    fjordlauncher

    # Dev
    helix
    lunarvim
    lazygit
    godot_4
    blender
    ansible
    python3

    # LSP
    nixd
    nodePackages.bash-language-server

    # Theming
    kde-gtk-config
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum

    ubuntu_font_family
    inter
    fira-code-nerdfont
  ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.shellAliases = {
    e = "$EDITOR";
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = ""; # We are loading p10k as standalone plugin!
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ../p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          hash = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
    ];
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
  home.stateVersion = "23.11";
}
