{ ... }: {
  microvm = {
    host = {
      enable = true;
      useNotifySockets = true;
    };
    vms = {
      my-microvm.config = {
        networking.hostName = "my-microvm";
        users.users.root.password = "";
        services.getty.autologinUser = "root";
        microvm = {
          #volumes = [ {
          #  mountPoint = "/var";
          #  image = "var.img";
          #  size = 256;
          #} ];
          shares = [ {
            # use proto = "virtiofs" for MicroVMs that are started by systemd
            proto = "9p";
            tag = "ro-store";
            # a host's /nix/store will be picked up so that no
            # squashfs/erofs will be built for it.
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
          } ];

          # "qemu" has 9p built-in!
          hypervisor = "qemu";
          socket = "control.socket";
          interfaces = [
            {
              type = "tap";
              id = "vm-test2";
              mac = "0A:00:00:00:00:01";
            }
          ];
        };
      };
    };
  };
}
