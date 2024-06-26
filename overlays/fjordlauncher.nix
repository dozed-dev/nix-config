# Patches Prism launcher to be Fjord :)
final: prev: rec {
  fjordlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (oldAttrs: {
    pname = "fjordlauncher-unwrapped";
    version = "8.3.2";

    src = prev.fetchFromGitHub {
      owner = "unmojang";
      repo = "FjordLauncher";
      rev = "master";
      hash = "sha256-mRPs20ZLtNEC4FK4eaAdeqHvfrTiz/g+JjghLN5Tzfc=";
    };

    # Disable DRM again (revert the commits that enable it)
    #patches = [
    #  (prev.fetchpatch {
    #    url = "https://github.com/unmojang/FjordLauncher/commit/13a32a66422e171c59ce861680fd184587057d08.patch";
    #    hash = "sha256-/UUTbBq7KIvKuqCWTFSSNmpbN7DnO1/BgQCykl9teCk=";
    #    revert = true;
    #  })
    #];

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
}
