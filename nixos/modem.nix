{ pkgs, ... }: {
  hardware.usb-modeswitch.enable = true;
  networking.modemmanager.enable = true;

  environment.systemPackages = with pkgs; [
    usb-modeswitch
    usb-modeswitch-data
  ];
}
