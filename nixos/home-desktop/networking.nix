{
  ...
}: {
  networking.hostName = "home-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Enable systemd-networkd
  systemd.network = {
    enable = true;
    wait-online.enable = false;

    netdevs = {
      "br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };

    networks = {
      "10-lan" = {
        matchConfig.Name = ["vm-*"];# "enp112s0"];
        networkConfig = {
          Bridge = "br0";
        };
      };
      "10-lan-bridge" = {
        matchConfig.Name = "br0";
        networkConfig = {
          Address = ["10.101.0.1/24" "fd26:5013::1/64"];
          DHCP = "no";
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "20-unmanaged" = {
        matchConfig.Name = "enp*";
        linkConfig = { 
          Unmanaged = true;
        };
      };
    };
  };
}
