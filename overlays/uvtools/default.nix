{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  stdenv,
  # Runtime native dependencies for Avalonia (SkiaSharp / X11 / Wayland)
  xorg,
  libglvnd,
  fontconfig,
  libICE,
  libSM,
  icu,
  openssl,
  zlib,
}:

buildDotnetModule rec {
  pname = "uvtools";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "sn4k3";
    repo = "UVtools";
    rev = "v${version}";
    hash = "sha256-ic82XfX5kqXLD2Jvn3jcb7JON2TtZhrdXBz3Gyrpc4Y=";
  };

  # ---- .NET SDK / runtime ----
  # UVtools v6.x targets net10.0 (see Directory.Build.props).
  # Requires a nixpkgs channel that ships .NET 10 (nixos-unstable as of early 2026).
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  # ---- Projects to build ----
  # Building both produces two executables: UVtools (GUI) and UVtoolsCmd (CLI).
  # UVtools.UI already has a ProjectReference to UVtools.Cmd and UVtools.Core,
  # but we list Cmd separately so its executable is published as a standalone binary.
  projectFile = [
    "UVtools.UI/UVtools.UI.csproj"
    "UVtools.Cmd/UVtools.Cmd.csproj"
  ];

  # ---- NuGet dependency lock ----
  # Generate this file by running:
  #   nix-build -A uvtools.passthru.fetch-deps
  # then execute the resulting script — it will write deps.json.
  #
  # NOTE: The project uses an Avalonia nightly NuGet feed
  #   (https://nuget-feed-nightly.avaloniaui.net/v3/index.json)
  # configured in nuget.config. The fetch-deps script picks this up
  # automatically via `dotnet restore`.
  nugetDeps = ./deps.json; # TODO: generate with fetch-deps

  # ---- Executables to wrap into $out/bin ----
  # These are relative to $out/lib/$pname after publish.
  # AssemblyName in UVtools.UI.csproj is "UVtools",
  # AssemblyName in UVtools.Cmd.csproj is "UVtoolsCmd".
  executables = [
    "UVtools"
    "UVtoolsCmd"
  ];

  # ---- Native library handling ----
  # The repo bundles a pre-built libcvextern.so (OpenCV/EmguCV) at
  #   build/platforms/linux-x64/libcvextern.so
  # and NuGet packages also ship native .so files (SkiaSharp, HarfBuzz).
  # autoPatchelfHook patches the ELF interpreter and RPATH on all of these.
  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib  # libstdc++.so — needed by libcvextern.so and libSkiaSharp.so
    zlib
  ];

  # ---- Libraries needed at runtime (LD_LIBRARY_PATH) ----
  # Avalonia (via SkiaSharp / X11) and OpenCvSharp use dlopen for these.
  runtimeDeps = [
    xorg.libX11
    xorg.libXrandr
    xorg.libXi
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    libglvnd       # libGL, libEGL — needed by Avalonia for GPU rendering
    fontconfig
    libICE
    libSM
    icu
    openssl
    zlib
  ];

  # ---- Desktop entry ----
  desktopItems = [
    (makeDesktopItem {
      name = "uvtools";
      desktopName = "UVtools";
      genericName = "MSLA/DLP File Tool";
      comment = meta.description;
      exec = "UVtools %F";
      icon = "uvtools";
      terminal = false;
      categories = [ "Graphics" "3DGraphics" "Utility" ];
    })
  ];

  # ---- Post-install: icons ----
  postInstall = ''
    # PNG icon (256x256)
    install -Dm644 UVtools.CAD/UVtools.png \
      $out/share/icons/hicolor/256x256/apps/uvtools.png

    # SVG icon
    install -Dm644 build/platforms/linux/AppImage/UVtools.svg \
      $out/share/icons/hicolor/scalable/apps/uvtools.svg
  '';

  meta = with lib; {
    description = "MSLA/DLP, file analysis, calibration, repair, conversion and manipulation";
    longDescription = ''
      UVtools is a comprehensive tool for MSLA and DLP resin 3D printer files.
      It can view, edit, repair, calibrate, and convert between dozens of
      slicer file formats including SL1, CTB, Photon, GOO, and many more.
    '';
    homepage = "https://github.com/sn4k3/UVtools";
    changelog = "https://github.com/sn4k3/UVtools/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Plus;
    maintainers = [ ]; # Add yourself here
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "UVtools";
  };
}
