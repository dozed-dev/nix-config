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
      ida-portable = /nix/store/x09ld7bgma45m7v65vii1myr22h8ckhw-ida-pro-9.1;
    })
  ];
}
