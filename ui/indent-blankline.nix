{
  plugins = {
    indent-blankline = {
      enable = true;
      scope = {
        enabled = true;
        showStart = true;
      };
      settings = {
        indent = {
          char = "│"; # "│" or "▎"
        };
        exclude = {
          buftypes = ["terminal" "nofile"];
          filetypes = [
            "help"
            "alpha"
            "dashboard"
            "neo-tree"
            "Trouble"
            "trouble"
            "lazy"
            "mason"
            "notify"
            "toggleterm"
            "lazyterm"
          ];
        };
      };
    };
  };
}
