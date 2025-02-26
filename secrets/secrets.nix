let
  quitzka-lappy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAS5iBqgIIMty3YXwBvo2KWhcYc62loD6OjU/Ix6TwYL quitzka@lappy";
  lappy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMkT1gv+9Pe6hCn5afBL6J42mPQPAJc0YfqrguEcLE2 root@lappy";
in {
  "lappy/calib-data.bin.age".publicKeys = [quitzka-lappy lappy];
}
