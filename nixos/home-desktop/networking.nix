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
      "10-microvm" = {
        netdevConfig = {
          Name = "microvm-br0";
          Kind = "bridge";
        };
      };
    };

    networks = {
      "10-microvm" = {
        matchConfig.Name = "microvm-br0";
        networkConfig = {
          Address = ["" ""];
          DHCPServer = true;
          IPv6SendRA = true;
        };
        addresses = [
          { Address = "10.101.0.1/24"; }
          { Address = "fd26:5013::1/64"; }
        ];
        ipv6Prefixes = [
          { Prefix = "fd26:5013::/64"; }
        ];
      };
      "11-microvm" = {
        matchConfig.Name = "vm-*";
        # Attach to the bridge that was configured above
        networkConfig.Bridge = "microvm-br0";
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
