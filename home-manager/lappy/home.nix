# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  ...
}: {
  imports = [
    ../base.nix
  ];

  home.packages = with pkgs; [
    #f3d
    #rembg

    # Prod
    libreoffice-qt6-fresh
    #orca-slicer
    unstable.freecad
    orca-slicer

    # Gaming
    steam
    lutris
    wine
    #fjordlauncher
  ];
}
