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
    tcping-go
    blender
    orca-slicer

    # Gaming
    steam
    wine
    fjordlauncher
  ];
  services.syncthing = {
    enable = true;
    overrideDevices = true;
    overrideFolders = false;
    settings = {
      devices = {
        "pixel".id = "ZDEBKB5-RWBSLHI-W5CMYTU-IWHINHF-QMTAJ6F-JTLYLHK-DXS6LDF-4YUILQB";
      };
      folders = {
        "Notes" = {
          id = "1niqp-yl9hp";
          path = "/home/quitzka/Documents/Notes";
          devices = ["pixel"];
          versioning = {
            type = "simple";
            params.keep = 10;
          };
        };
      };
    };
  };
}
