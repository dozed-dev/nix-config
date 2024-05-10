{ config, pkgs, ...}: {
  # Kernel modules

  boot.extraModulePackages =
  let
    kernelPackages = config.boot.kernelPackages.extend (
      final: prev: {
        ddcci-driver = prev.ddcci-driver.overrideAttrs (oldAttrs: rec {
          version = "3eb20df6"; # Latest master as of 2024-05-10
          src = pkgs.fetchFromGitLab {
            owner = "${oldAttrs.pname}-linux";
            repo = "${oldAttrs.pname}-linux";
            rev = version;
            hash = "sha256-bvg/eQiCL/C/RhXZl11f5C36ZFtVgpZeM8RJY9qnw6Q=";
          };
        });
      }
    );
  in
    with kernelPackages; [ ddcci-driver ];

  boot.kernelModules = [ "ddcci" "i2c-dev" ];

  # i2c group
  users.groups.i2c = {};

  environment.systemPackages = with pkgs; [ ddcutil ];

  services.udev.packages = with pkgs; [ ddcutil ];
}
