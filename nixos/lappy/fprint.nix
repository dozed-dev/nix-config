{inputs, config, ...}: {
  imports = [
    inputs.t480-fp-sensor.nixosModules."06cb-009a-fingerprint-sensor"
    ../sops.nix
  ];

  sops.secrets.lappy-fp-calib = {
    format = "binary";
    sopsFile = ../../secrets/lappy/calib-data.bin;
    mode = "0444";
    owner = config.users.users.nobody.name;
    group = config.users.users.nobody.group;
  };

  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    #backend = "python-validity";
    backend = "libfprint-tod";
    calib-data-file = config.sops.secrets.lappy-fp-calib.path;
  };
}
