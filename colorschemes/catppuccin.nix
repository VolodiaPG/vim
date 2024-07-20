{colorFlavour, ...}: {
  colorschemes = {
    catppuccin = {
      enable = true;
      settings = {
        transparent_background = true;
        background = {
          light = "macchiato";
          dark = "mocha";
        };
        #flavour = "mocha"; # "latte", "mocha", "frappe", "macchiato" or raw lua code
        flavour = colorFlavour;
        no_bold = false;
        no_italics = false;
        no_underline = false;
        transparentBackground = true;
        integrations = {
          cmp = true;
          noice = true;
          notify = true;
          neotree = true;
          harpoon = true;
          gitsigns = true;
          which_key = true;
          illuminate = {
            enabled = true;
          };
          treesitter = true;
          treesitter_context = true;
          telescope.enabled = true;
          indent_blankline.enabled = true;
          mini.enabled = true;
          native_lsp = {
            enabled = true;
            inlay_hints = {
              background = true;
            };
            underlines = {
              errors = ["underline"];
              hints = ["underline"];
              information = ["underline"];
              warnings = ["underline"];
            };
          };
        };
      };
    };
  };
}
