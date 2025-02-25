{inputs, config, ...}: {
  imports = [
    inputs.t480-fp-sensor.nixosModules."06cb-009a-fingerprint-sensor"
    ../sops.nix
  ];

  sops.secrets.lappy-fp-calib = {
    format = "binary";
    sopsFile = ../../secrets/lappy/fingerprint-calibration-data.bin;
  };

  # Start the driver at boot
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  
  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    backend = "python-validity";
    #backend = "libfprint-tod";
    #calib-data-file = config.sops.secrets.lappy-fp-calib.path;
  };

  # Install the driver
  #services.fprintd =
  #{
  #  enable = true;
  #  # If simply enabling fprintd is not enough, try enabling fprintd.tod...
  #  tod.enable = true;
  #  # ...and use one of the drivers
  #  tod.driver = pkgs.libfprint-2-tod1-vfs0090; # Goodix driver module
  #};
}
