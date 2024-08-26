# Taken from https://github.com/NixOS/nixpkgs/issues/244451#issuecomment-1867327404
{
  stdenv,
  fetchzip,
  makeDesktopItem,
  autoPatchelfHook,
  copyDesktopItems,
  qtbase,
  qtsvg,
  qttools,
  qtx11extras,
  wrapQtAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "nekoray";
  version = "4.0-beta3";
  date = "2024-07-13";

  src = fetchzip {
    url = "https://github.com/MatsuriDayo/nekoray/releases/download/${version}/nekoray-${version}-${date}-linux64.zip";
    hash = "sha256-JA5LuAkqnUzZVUoYImhbZqS4lu9f7bbQn0W7gy70Lgg=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = pname;
      exec = "nekobox";
      icon = "nekobox";
      comment = "Qt based cross-platform GUI proxy configuration manager";
      categories = ["Network" "Utility"];
    })
  ];

  dontWrapQtApps = true;

  nativeBuildInputs = [autoPatchelfHook copyDesktopItems wrapQtAppsHook];
  buildInputs = [
    qtbase
    qtsvg
    qttools
    qtx11extras
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share/icons/hicolor/128x128/apps,usr/lib/nekobox,bin}
    install -Dm755 ./{nekobox_core,nekobox} $out/usr/lib/nekobox/
    install -Dm644 ./{geosite.db,geosite.dat,geoip.db,geoip.dat} $out/usr/lib/nekobox/
    install -Dm644 ./nekobox.png $out/share/icons/hicolor/128x128/apps/

    wrapQtApp $out/usr/lib/nekobox/nekobox \
      --add-flags "-- -appdata"

    mv $out/usr/lib/nekobox/nekobox $out/bin/nekobox

    runHook postInstall
  '';
}
