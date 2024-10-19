{ pkgs, ... }: {

  home.shellAliases = {
    e = "$EDITOR";
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    history = rec {
      size = 2147483647;
      save = size;
    };
    oh-my-zsh = {
      enable = true;
      theme = ""; # We are loading p10k as standalone plugin!
    };

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      INSTANT_PROMPT="''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      if [[ -r "$INSTANT_PROMPT" ]]; then source "$INSTANT_PROMPT"; fi
    '';
    plugins = let
      fileToPlugin = {name, path}:
        let filename = builtins.baseNameOf path; in {
          inherit name;
          src = pkgs.writeTextDir filename (builtins.readFile path);
          file = filename;
        };
    in [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      (fileToPlugin {
        name = "powerlevel10k-config";
        path = ./p10k.zsh;
      })
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          hash = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
    ];
  };
}
