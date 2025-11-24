{ config, pkgs, ...}: {
  # Kernel modules
  #boot.extraModulePackages = config.boot.kernelPackages.ddcci-driver;

  # Use patched version of DDCCI module by Kamila Wojciechowska (nullbytepl)
  boot.extraModulePackages =
  let
    kernelPackages = config.boot.kernelPackages.extend (
      final: prev: {
        ddcci-driver = prev.ddcci-driver.overrideAttrs (oldAttrs: rec {
          version = "0.4.6-unstable";
          src = pkgs.fetchFromGitLab {
            owner = "ddcci-driver-linux";
            repo = "ddcci-driver-linux";
            rev = "master";
            hash = "sha256-fQjsDjbtFKhs0bUCFfKRgCg516TXdwIkhKEbIISjgs0=";
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
