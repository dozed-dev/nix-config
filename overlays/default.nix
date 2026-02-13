# This file defines overlays
{inputs, ...}: {
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # from: https://github.com/msanft/ida-pro-overlay
    ida-pro = import ./ida-pro.nix;
    ghidra-qingke = prev.ghidra.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "dozed-dev";
        repo = "ghidra-qingke";
        rev = "qingke";
        sha256 = "sha256-GnI004jA0D638o4pLgoJ87RPJ8m+IHyKqkjpeUhWjLo=";
      };
    });
    LycheeSlicer-patched = prev.callPackage ./LycheeSlicer.nix { oldLycheeSlicer = prev.LycheeSlicer; };
    orca-slicer-patched = prev.orca-slicer.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "mnott";
        repo = "OrcaSlicer";
        rev = "6a398a03472dc4206bc1fddfbb6ce79db8e7de40";
        sha256 = "sha256-xNedalhtLD65/EbwnxokvC70vs6lfJZVcK+t0uJnDKw=";
      };
      cmakeFlags =
        let
          filtered =
            builtins.filter
              (flag:
                !(prev.lib.hasInfix "LIBNOISE_LIBRARY" flag))
              oldAttrs.cmakeFlags;
        in
          filtered ++ [
            (prev.lib.cmakeFeature "LIBNOISE_LIBRARY_RELEASE" "${prev.libnoise}/lib/libnoise-static.a")
          ];
      patches = oldAttrs.patches ++ [
        ./revert-draco.patch
        #(prev.fetchpatch {
        #  name = "revert-draco.patch";
        #  url = "https://github.com/SoftFever/OrcaSlicer/commit/bb30999673cdac7644f7c4529259cce236c3b813.patch";
        #  hash = "sha256-3hedO+z4x1Cgs6HLL+XR83MJCTqLB3TniChiNPGM4Dk=";
        #  revert = true;
        #})
      ];
    });
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
