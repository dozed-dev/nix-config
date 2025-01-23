{

  stdenv,
  lib,
  binutils,
  fetchFromGitHub,
  writeText,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  boost186,
  cereal,
  cgal,
  curl,
  dbus,
  eigen,
  expat,
  ffmpeg,
  gcc-unwrapped,
  glew,
  glfw,
  glib,
  glib-networking,
  gmp,
  gst_all_1,
  gtest,
  gtk3,
  hicolor-icon-theme,
  ilmbase,
  libpng,
  mesa,
  mpfr,
  nlopt,
  opencascade-occt_7_6,
  openvdb,
  opencv,
  pcre,
  systemd,
  tbb_2021_11,
  webkitgtk_4_0,
  wxGTK31,
  xorg,
  withSystemd ? stdenv.hostPlatform.isLinux,}:
let
  wxGTK' =
    (wxGTK31.override {
      withCurl = true;
      withPrivateFonts = true;
      withWebKit = true;
    }).overrideAttrs
      (old: {
        configureFlags = old.configureFlags ++ [
          # Disable noisy debug dialogs
          "--enable-debug=no"
        ];
      });
in
stdenv.mkDerivation rec {
  pname = "orca-slicer";
  version = "v2.2.0-unstable-2025-01-23";

  src = fetchFromGitHub {
    owner = "SoftFever";
    repo = "OrcaSlicer";
    rev = "1b1288c4353afca44edee323061bdd5c87fcafb9";
    hash = "sha256-IPdKusP2cB5jgr6JjQVu8ZjJ2kiG6mfmfZtDVSlAFNg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    wxGTK'
  ];

  buildInputs =
    [
      binutils
      (boost186.override {
        enableShared = true;
        enableStatic = false;
        extraFeatures = [
          "log"
          "thread"
          "filesystem"
        ];
      })
      boost186.dev
      cereal
      cgal
      curl
      dbus
      eigen
      expat
      ffmpeg
      gcc-unwrapped
      glew
      glfw
      glib
      glib-networking
      gmp
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-good
      gtk3
      hicolor-icon-theme
      ilmbase
      libpng
      mesa
      mesa.osmesa
      mesa.drivers
      mpfr
      nlopt
      opencascade-occt_7_6
      openvdb
      pcre
      tbb_2021_11
      webkitgtk_4_0
      wxGTK'
      xorg.libX11
      opencv
    ]
    ++ lib.optionals withSystemd [ systemd ]
    ++ checkInputs;

  patches = [
    # Fix for webkitgtk linking
    (writeText "patch1" ''
From 7eed499898226222a949a792e0400ec10db4a1c9 Mon Sep 17 00:00:00 2001
From: Zhaofeng Li <hello@zhaofeng.li>
Date: Tue, 22 Nov 2022 13:00:39 -0700
Subject: [PATCH] [not for upstream] CMakeLists: Link against webkit2gtk in
 libslic3r_gui

WebView.cpp uses symbols from webkitgtk directly. Upstream setup
links wxGTK statically so webkitgtk is already pulled in.

> /nix/store/039g378vc3pc3dvi9dzdlrd0i4q93qwf-binutils-2.39/bin/ld: slic3r/liblibslic3r_gui.a(WebView.cpp.o): undefined reference to symbol 'webkit_web_view_run_javascript_finish'
> /nix/store/039g378vc3pc3dvi9dzdlrd0i4q93qwf-binutils-2.39/bin/ld: /nix/store/8yvy428jy2nwq4dhmrcs7gj5r27a2pv6-webkitgtk-2.38.2+abi=4.0/lib/libwebkit2gtk-4.0.so.37: error adding symbols: DSO missing from command line
---
 src/CMakeLists.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 9c5cb96..e92a0e3 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -175,6 +175,11 @@ if (WIN32)
     target_link_libraries(BambuStudio_app_gui PRIVATE boost_headeronly)
 endif ()
 
+# We link against webkit2gtk symbols in src/slic3r/GUI/Widgets/WebView.cpp
+if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
+    target_link_libraries(libslic3r_gui "-lwebkit2gtk-4.0")
+endif ()
+
 # Link the resources dir to where Slic3r GUI expects it
 set(output_dlls_Release "")
 set(output_dlls_Debug "")
-- 
2.38.1
    '')
    (writeText "patch2" ''
diff --git a/src/libslic3r/CMakeLists.txt b/src/libslic3r/CMakeLists.txt
index 38a1b2499..00c9060b3 100644
--- a/src/libslic3r/CMakeLists.txt
+++ b/src/libslic3r/CMakeLists.txt
@@ -573,7 +573,8 @@ target_link_libraries(libslic3r
     mcut
     JPEG::JPEG
     qoi
-    opencv_world
+    opencv_core
+    opencv_imgproc
     )
 
 if(NOT WIN32)
    '')
  ];

  doCheck = true;
  checkInputs = [ gtest ];

  separateDebugInfo = true;

  NLOPT = nlopt;

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-ignored-attributes"
    "-I${opencv.out}/include/opencv4"
    "-Wno-error=template-id-cdtor"
    "-Wno-error=incompatible-pointer-types"
    "-Wno-template-id-cdtor"
    "-Wno-uninitialized"
    "-Wno-unused-result"
    "-Wno-deprecated-declarations"
    "-Wno-use-after-free"
    "-Wno-format-overflow"
    "-Wno-stringop-overflow"
    "-DBOOST_ALLOW_DEPRECATED_HEADERS"
    "-DBOOST_MATH_DISABLE_STD_FPCLASSIFY"
    "-DBOOST_MATH_NO_LONG_DOUBLE_MATH_FUNCTIONS"
    "-DBOOST_MATH_DISABLE_FLOAT128"
    "-DBOOST_MATH_NO_QUAD_SUPPORT"
    "-DBOOST_MATH_MAX_FLOAT128_DIGITS=0"
    "-DBOOST_CSTDFLOAT_NO_LIBQUADMATH_SUPPORT"
    "-DBOOST_MATH_DISABLE_FLOAT128_BUILTIN_FPCLASSIFY"
  ];

  NIX_LDFLAGS = toString [
    (lib.optionalString withSystemd "-ludev")
    "-L${mesa.osmesa}/lib"
    "-L${mesa.drivers}/lib"
    "-L${boost186}/lib"
    "-lboost_log"
    "-lboost_log_setup"
  ];

  prePatch = ''
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
  '';

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"
    "-DBBL_RELEASE_TO_PUBLIC=1"
    "-DBBL_INTERNAL_TESTING=0"
    "-DDEP_WX_GTK3=ON"
    "-DSLIC3R_BUILD_TESTS=0"
    "-DCMAKE_CXX_FLAGS=-DBOOST_LOG_DYN_LINK"
    "-DBOOST_LOG_DYN_LINK=1"
    "-DBOOST_ALL_DYN_LINK=1"
    "-DBOOST_LOG_NO_LIB=OFF"
    "-DCMAKE_CXX_FLAGS=-DGL_SILENCE_DEPRECATION"
    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,--no-as-needed"
    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,${mesa.drivers}/lib -Wl,-rpath,${mesa.osmesa}/lib"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib:${
        lib.makeLibraryPath [
          mesa.drivers
          mesa.osmesa
          glew
        ]
      }"
      --prefix LIBGL_DRIVERS_PATH : "${mesa.drivers}/lib/dri"
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    )
  '';

  meta = {
    description = "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc.)";
    homepage = "https://github.com/SoftFever/OrcaSlicer";
    changelog = "https://github.com/SoftFever/OrcaSlicer/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      zhaofengli
      ovlach
      pinpox
      liberodark
    ];
    mainProgram = "orca-slicer";
    platforms = lib.platforms.linux;
  };
}
