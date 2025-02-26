{pkgs, inputs, ...}: {
  imports = [
    inputs.t480-fp-sensor.nixosModules."06cb-009a-fingerprint-sensor"
  ];
  # Start the driver at boot
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  
  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    backend = "python-validity";
    #backend = "libfprint-tod";
    #calib-data-file = ~/Documents/fingerprint-calibration-data.bin;
  };
}
