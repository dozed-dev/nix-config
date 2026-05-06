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
