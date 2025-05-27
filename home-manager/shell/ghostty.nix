{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installVimSyntax = true;
    settings = {
      theme = "Adwaita Dark";
      gtk-titlebar = true;
      window-decoration = "client";
    };
  };
}
