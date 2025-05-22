{
  pkgs,
  ... }: {
  xdg.dataFile."kwin/effects/geometry_change_1_5.tar.gz".source = pkgs.fetchurl {
    url = "https://github.com/peterfajdiga/kwin4_effect_geometry_change/releases/download/v1.5/kwin4_effect_geometry_change_1_5.tar.gz";
    hash = "sha256-dmUaJEZfg8gy65bcnTSzrBLHXRtxKYwqxGGopLLMCFA=";
  };
}
