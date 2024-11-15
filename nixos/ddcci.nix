{ config, pkgs, ...}: {
  # Kernel modules
  #boot.extraModulePackages = config.boot.kernelPackages.ddcci-driver;

  # Use patched version of DDCCI module by Kamila Wojciechowska (nullbytepl)
  boot.extraModulePackages =
  let
    kernelPackages = config.boot.kernelPackages.extend (
      final: prev: {
        ddcci-driver = prev.ddcci-driver.overrideAttrs (oldAttrs: rec {
          version = "0.4.6";
          src = pkgs.fetchFromGitLab {
            owner = "nullbytepl";
            repo = "${oldAttrs.pname}-linux";
            rev = "e0605c9cdff7bf3fe9587434614473ba8b7e5f63";
            hash = "sha256-ic6qmWqj7+Ga5SGgMOckDwa5ouyvpW1LlZhY1OBr9Gk=";
          };
          patches = [];
        });
      }
    );
  in [ kernelPackages.ddcci-driver ];
  boot.kernelModules = [ "ddcci" "i2c-dev" ];

  # Fix autoprobing
  systemd.services.ddcci-autoprobing-fix = {
    script = ''
      echo 'ddcci 0x37' | tee /sys/class/drm/*/ddc/new_device
    '';
    wantedBy = [ "graphical.target" ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # i2c group
  users.groups.i2c = {};

  environment.systemPackages = with pkgs; [ ddcutil ];
  services.udev.packages = with pkgs; [ ddcutil ];
}
