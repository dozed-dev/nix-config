{ ... }: {

  home.shellAliases = {
    e = "$EDITOR";
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    config = {
      load_dotenv = true;
      strict_env = true;
    };
  };
}
