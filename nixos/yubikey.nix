{ pkgs, ...}: {

  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [
    yubikey-manager pcsclite
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];
}
