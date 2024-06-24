# This file defines overlays
{inputs, ...}: {
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    lunarvim = prev.lunarvim.overrideAttrs (oldAttrs: rec {
      version = "1.4.0";
      src = prev.fetchFromGitHub {
        owner = "LunarVim";
        repo = "LunarVim";
        rev = "refs/tags/${version}";
        hash = "sha256-uuXaDvZ9VaRJlZrdu28gawSOJFVSo5XX+JG53IB+Ijw=";
      };
      patches = [ ];
    });
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  nekoray = final: _prev: {
    nekoray = _prev.libsForQt5.callPackage ./nekoray.nix {};
  };
  gost3 = final: _prev: {
    gost3 = _prev.libsForQt5.callPackage ./gost3.nix {};
  };
  fjordlauncher = import ./fjordlauncher.nix;
}
