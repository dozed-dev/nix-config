{
  appimageTools,
  buildGoModule,
  fetchgit,
  makeDesktopItem,
  lib,
  xorg,
  wayland,
  wayland-protocols,
  oldLycheeSlicer,
}:
let
  lychee-slicer-patched = buildGoModule {
    pname = "lychee-slicer-patched";
    version = "v1.1";

    src = fetchgit {
      url = "https://vaclive.party/software/lychee-slicer";
      rev = "v1.1";
      sha256 = "sha256-UAbr5F3MkalrP9Ms5wPP4LjLWwGWjQZZ0arqTDuCtF0=";
    };

    vendorHash = "sha256-Ix4JGhFXxv1kZNSyTGdRe3RSuCQ3plaFW4a2iLmogGE=";

    buildFlagsArray = [ "-mod=mod" ];

    # Force normal module mode even if vendor detection occurs
    modMode = "mod";

    ldflags = [ "-s" "-w" ];

    meta = with lib; {
      description = "Patched Lychee Slicer CLI";
      homepage    = "https://vaclive.party/arch/lychee-slicer-patched";
      license     = licenses.wtfpl;
      #maintainers = with maintainers; [ ];
      platforms   = platforms.linux;
    };
  };

  pname = oldLycheeSlicer.pname + "-patched";
  version = oldLycheeSlicer.version;
  src = oldLycheeSlicer.src;

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      ${lychee-slicer-patched}/bin/lychee-slicer -program "$out/lycheeslicer" -patch
      substituteInPlace $out/AppRun \
        --replace-fail 'exec "$BIN"' 'exec ${lychee-slicer-patched}/bin/lychee-slicer -program "$BIN" -proxy'
    '';
  };

  desktopItem = makeDesktopItem {
    name = "Lychee Slicer";
    genericName = "Resin Slicer";
    comment = "All-in-one 3D slicer for Resin and Filament";
    desktopName = "LycheeSlicer";
    icon = "${appimageContents}/usr/share/icons/hicolor/512x512/apps/lycheeslicer.png";
    noDisplay = false;
    exec = "${pname}";
    terminal = false;
    mimeTypes = [ "model/stl" ];
    categories = [ "Graphics" ];
    keywords = [
      "STL"
      "Slicer"
      "Printing"
    ];
  };

in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;
  passthru.src = src;

  extraInstallCommands = ''
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*
  '';

  extraPkgs = _: [
    xorg.libxshmfence
    wayland
    wayland-protocols
  ];

  meta = {
    description = "All-in-one 3D slicer for resin and FDM printers";
    homepage = "https://lychee.mango3d.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      tarinaky
      ZachDavies
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "LycheeSlicer";
  };
}
