{ config, pkgs, ...}: {
  # Kernel modules
  #boot.extraModulePackages = config.boot.kernelPackages.ddcci-driver;

  # Use patched version of DDCCI module by Kamila Wojciechowska (nullbytepl)
  boot.extraModulePackages =
  let
    kernelPackages = config.boot.kernelPackages.extend (
      final: prev: {
        ddcci-driver = prev.ddcci-driver.overrideAttrs (oldAttrs: rec {
          version = "0.4.5";
          src = pkgs.fetchFromGitLab {
            owner = "nullbytepl";
            repo = "${oldAttrs.pname}-linux";
            rev = "7853cbfc28bc62e87db79f612568b25315397dd0";
            hash = "sha256-QImfvYzMqyrRGyrS6I7ERYmteaTijd8ZRnC6+bA9OyM=";
          };
          patches = [];
        });
      }
    );
  in [ kernelPackages.ddcci-driver ];

  boot.kernelModules = [ "ddcci" "i2c-dev" ];

  # i2c group
  users.groups.i2c = {};

  environment.systemPackages = with pkgs; [ ddcutil ];

  services.udev.packages = with pkgs; [ ddcutil ];
}
