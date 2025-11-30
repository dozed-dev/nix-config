{ ... }: {
  services.udev.extraRules = ''
    # WCH-Link
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="8010", GROUP="plugdev"

    # Alientek T80P bootloader
    SUBSYSTEM=="usb", ATTRS{idVendor}=="413d", ATTRS{idProduct}=="2107", GROUP="plugdev"

    # CH32 ISP bootloader
    SUBSYSTEM=="usb", ATTRS{idVendor}=="4348", ATTRS{idProduct}=="55e0", GROUP="plugdev"
  '';
}
