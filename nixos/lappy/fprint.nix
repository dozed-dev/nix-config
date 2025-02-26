{config, inputs, ...}: {
  imports = [
    inputs.t480-fp-sensor.nixosModules."06cb-009a-fingerprint-sensor"
  ];

  age.secrets.calib-data.file = ../../secrets/lappy/calib-data.bin.age;

  
  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    #backend = "python-validity";
    backend = "libfprint-tod";
    calib-data-file = config.age.secrets.calib-data.path;
  };
}
