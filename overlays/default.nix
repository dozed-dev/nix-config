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
    LycheeSlicer-patched = prev.callPackage ./LycheeSlicer.nix {};
    orca-slicer = prev.orca-slicer.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [(prev.writeText "bridging-density-backport.patch" ''
        diff --git a/src/libslic3r/PrintConfig.cpp b/src/libslic3r/PrintConfig.cpp
        index 498678a..9063d21 100644
        --- a/src/libslic3r/PrintConfig.cpp
        +++ b/src/libslic3r/PrintConfig.cpp
        @@ -1022,7 +1022,7 @@ void PrintConfigDef::init_fff_params()
                              "around the extruded bridge, improving its cooling speed.");
             def->sidetext = "%";
             def->min = 10;
        -    def->max = 100;
        +    def->max = 150;
             def->mode = comAdvanced;
             def->set_default_value(new ConfigOptionPercent(100));
 
        @@ -1036,7 +1036,7 @@ void PrintConfigDef::init_fff_params()
                              "further improving internal bridging structure before solid infill is extruded.");
             def->sidetext = "%";
             def->min = 10;
        -    def->max = 100;
        +    def->max = 150;
             def->mode = comAdvanced;
             def->set_default_value(new ConfigOptionPercent(100));
      '')];
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
