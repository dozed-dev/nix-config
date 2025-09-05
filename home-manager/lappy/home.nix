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
    # Gaming
    steam
    wine
    #fjordlauncher

    flashprog
  ];
}
