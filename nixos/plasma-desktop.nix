{ pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:win_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable debuginfod for crash reports
  #services.nixseparatedebuginfod.enable = true;

  # GUI utils
  environment.systemPackages = with pkgs; [
    #adwaita-icon-theme
    wl-clipboard
    steam-run
    kdePackages.drkonqi
    kdePackages.kdialog
    kdePackages.kdenetwork-filesharing
    kdePackages.kio-zeroconf
    kdePackages.kio-fuse

    kdePackages.partitionmanager
    kdePackages.filelight
    kdePackages.kate

    polonium

    # Theming
    kdePackages.kde-gtk-config
    kdePackages.qtstyleplugin-kvantum
    plasma5Packages.qtstyleplugin-kvantum
  ];

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    inter
  ];

  # KDE connect
  programs.kdeconnect.enable = true;

  programs.firejail = {
    enable = true;
  };

}
