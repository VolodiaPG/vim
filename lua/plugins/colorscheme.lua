-- Colorscheme configuration

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Make sure to load this before all the other start plugins
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "macchiato",
        dark = "macchiato",
      },
      transparent_background = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        mini = false,
        harpoon = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        which_key = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        native_lsp = {
          enabled = true,
          -- virtual_text = {
          --   errors = { "italic" },
          --   hints = { "italic" },
          --   warnings = { "italic" },
          --   information = { "italic" },
          -- },
          -- underlines = {
          --   errors = { "underline" },
          --   hints = { "underline" },
          --   warnings = { "underline" },
          --   information = { "underline" },
          -- },
        },
        treesitter = true,
        treesitter_context = true,
      },
    })

    -- Set colorscheme
    vim.cmd.colorscheme("catppuccin")
  end,
} 