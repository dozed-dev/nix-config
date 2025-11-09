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
    (callPackage ida-pro {
      runfile = /nix/store/s9gq70w56355yrg33054g97zscr3r64i-ida-pro_91_x64linux.run;
    })
  ];
}
