# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  pkgs,
  ...
}: rec {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./shell/zsh.nix
    ./shell/ghostty.nix
    ./helix.nix
    ./plasma.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.fjordlauncher.overlays.default
      outputs.overlays.modifications
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
    remmina
    helvum

    # Desktop/media
    unstable.telegram-desktop
    mumble
    unstable.firefox
    unstable.librewolf
    ungoogled-chromium
    unstable.tor-browser
    mpv
    obs-studio
    qbittorrent
    unar
    ffmpeg-full

    # Prod
    krita
    libreoffice-qt6-fresh
    orca-slicer
    unstable.freecad

    # Dev
    lazygit
    python3
    minicom
    usbutils
    binwalk
    ghidra-qingke
    gdb
    teleport

    # LSP
    unstable.nixd
    unstable.nodePackages.bash-language-server

    # Fonts
    unstable.ubuntu_font_family
    unstable.inter
    unstable.nerd-fonts.fira-code
  ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user.name = "dozed-dev";
      user.email = "dev.dozed@aleeas.com";
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {};
    # Common flags for all bksp hosts
    matchBlocks."*.bksp t.bksp.in" = {
      userKnownHostsFile = "${home.homeDirectory}/.tsh/known_hosts";
      identityFile = "${home.homeDirectory}/.tsh/keys/t.bksp.in/forkingu";
      certificateFile = "${home.homeDirectory}/.tsh/keys/t.bksp.in/forkingu-ssh/bksp-cert.pub";
    };
    # Flags for all bksp hosts except the proxy
    matchBlocks."*.bksp !t.bksp.in" = {
      port = 3022;
      proxyCommand = "\"${pkgs.teleport}/bin/tsh\" proxy ssh --cluster=bksp --proxy=t.bksp.in:443 %r@%h:%p";
    };
  };

  xdg.configFile."yt-dlp/config".text = ''
    --extractor-args "youtube:player-client=tv,mweb"
  '';

  fonts.fontconfig.enable = true;

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
