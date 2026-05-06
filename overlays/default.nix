# This file defines overlays
{inputs, ...}: {
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # from: https://github.com/msanft/ida-pro-overlay
    ida-pro = import ./ida-pro/ida-pro.nix;
    proxmark3-patched = prev.proxmark3.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
        #final.diffutils
      ];
      patches = [ ./proxmark3-mfp.patch ];
    });
    ghidra-qingke = prev.ghidra.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "dozed-dev";
        repo = "ghidra-qingke";
        rev = "qingke";
        sha256 = "sha256-GnI004jA0D638o4pLgoJ87RPJ8m+IHyKqkjpeUhWjLo=";
      };
    });
    orca-slicer = prev.orca-slicer.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "OrcaSlicer";
        repo = "OrcaSlicer";
        rev = "master";
        sha256 = "sha256-gaET/8NBrrVBZZdyi+6tFBUIZxJWrNNSPxZ0U3lwY1w=";
      };
    patches = (builtins.filter
      (p: !(builtins.isPath p && builtins.match ".*0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.*" (toString p) != null))
      (oldAttrs.patches or [])
    ) ++ [
      (prev.writeText "CMakeLists-Link-against-webkit2git.patch" ''
        diff --git a/CMakeLists.txt b/CMakeLists.txt
        index d3ae729277..11cde5d2f2 100644
        --- a/CMakeLists.txt
        +++ b/CMakeLists.txt
        @@ -177,6 +177,12 @@ if (IS_CROSS_COMPILE)
             set(BUILD_TESTS OFF CACHE BOOL "" FORCE)
         endif ()

        +# We link against webkit2gtk symbols in src/slic3r/GUI/Widgets/WebView.cpp
        +if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
        +    target_link_libraries(libslic3r_gui "-lwebkit2gtk-4.1")
        +endif ()
        +
        +
         # Print out the SLIC3R_* cache options
         get_cmake_property(_cache_vars CACHE_VARIABLES)
         list (SORT _cache_vars)
      '')
    ];
    });
    LycheeSlicer-patched = prev.callPackage ./LycheeSlicer.nix { oldLycheeSlicer = prev.LycheeSlicer; };
    uvtools = prev.callPackage ./uvtools {};
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
