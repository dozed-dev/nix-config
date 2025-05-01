{
  pkgs,
  ...
}: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add the packages here.
    gcc
    openssl
    alsa-lib

    dbus
    dbus-glib
    fontconfig
    freetype
    glib
    gtk3
    libffi
    libevent
    libjpeg
    libpng
    libvpx
    libwebp
    nspr
    pango
    xorg.libX11
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXft
    xorg.libXi
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.pixman
    xorg.xorgproto
    zlib
  ];
}
