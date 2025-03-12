-- Statusline configuration

return {
  "tamton-aquib/staline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("staline").setup({
      sections = {
        left = {
          "▊", " ", { "Evil", "mode" }, " ", "file_name", " ", "branch"
        },
        mid = { "lsp" },
        right = {
          "lsp_name", " ", "file_size", " ", "line_column"
        }
      },
      mode_colors = {
        n = "#38b1f0",
        i = "#9ece6a",
        c = "#e27d60",
        v = "#c678dd",
        V = "#c678dd",
      },
      defaults = {
        true_colors = true,
        line_column = " [%l/%L] :%c ",
        branch_symbol = " ",
        mod_symbol = "  ",
      },
      special_table = {
        NvimTree = { "File Explorer", " " },
        packer = { "Packer", " " },
        TelescopePrompt = { "Telescope", " " },
        mason = { "Mason", " " },
        lazy = { "Lazy", "󰒲 " },
      },
      lsp_symbols = {
        Error = " ",
        Info = " ",
        Warn = " ",
        Hint = " ",
      },
    })
  end,
} 