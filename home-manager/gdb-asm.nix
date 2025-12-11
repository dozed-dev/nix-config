{
  pkgs,
 ...
}: {
  home.packages = [
    pkgs.gdb
  ];
  xdg.configFile."gdb/gdbinit".text = ''
    display/i $pc
    set disassemble-next-line on
    layout reg
  '';
}
