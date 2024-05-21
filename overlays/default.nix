# This file defines overlays
{inputs, ...}: {
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: rec {
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
    fjordlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (oldAttrs: {
      pname = "fjordlauncher-unwrapped";
      version = "8.3.1";

      src = prev.fetchFromGitHub {
        owner = "unmojang";
        repo = "FjordLauncher";
        rev = "13a32a66422e171c59ce861680fd184587057d08";
        hash = "sha256-5ioRE+CawMkVdPWMn1nWqcNglMPRfQisxcKLA5n135A=";
      };

      # Disable DRM again (revert the commit that enables it)
      patches = [
        (prev.fetchpatch {
          url = "https://github.com/unmojang/FjordLauncher/commit/13a32a66422e171c59ce861680fd184587057d08.patch";
          hash = "sha256-/UUTbBq7KIvKuqCWTFSSNmpbN7DnO1/BgQCykl9teCk=";
          revert = true;
        })
      ];

      meta = oldAttrs.meta // {
        mainProgram = "fjordlauncher";
      };
    });
    fjordlauncher = (prev.prismlauncher.override {
      prismlauncher-unwrapped = fjordlauncher-unwrapped;
    }).overrideAttrs (oldAttrs: {
      name = "fjordlauncher-${fjordlauncher-unwrapped.version}";
      qtWrapperArgs = map (str:
        builtins.replaceStrings ["PRISMLAUNCHER"] ["FJORDLAUNCHER"] str
      ) oldAttrs.qtWrapperArgs;
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
}
