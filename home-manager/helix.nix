{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    # https://docs.helix-editor.com/configuration.html
    settings = {
      theme = "adwaita-dark";
      editor = {
        line-number = "relative";
        auto-save = true;
        cursor-shape = {
          normal = "block";
        };
      };
      keys.normal = {
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        G = "goto_last_line";

        space.q = ":quit";
      };
    };
    # https://docs.helix-editor.com/languages.html
    languages = {
      language-server.nixd = { command = "nixd"; };

      language = [{
        name = "nix";
        language-servers = [ "nixd" ];
      }];
    };
  };
}
