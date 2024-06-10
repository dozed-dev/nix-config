{ pkgs, ...}: {

  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [
    yubikey-manager
    pcsclite
    pam_u2f
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  security.pam = {
    u2f.cue = true;
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      kde.u2fAuth = true;
    };
  };
}
