{ inputs, ...}: {

  imports = [ inputs.zapret.nixosModules.zapret ];
  services.zapret = {
    enable = true;
    config = "";
  };
}
