-- Colorscheme configuration

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Make sure to load this before all the other start plugins
  config = function()
    require('catppuccin').setup {
      flavour = 'macchiato', -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = 'macchiato',
        dark = 'macchiato',
      },
      transparent_background = true,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = 'dark',
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
      -- custom_highlights = function(colors)
      --   return {
      --     LineNr = { fg = colors.mauve },
      --     CursorLineNr = { fg = colors.peach, bold = true },
      --   }
      -- end,
    }

    -- Set colorscheme
    vim.cmd.colorscheme 'catppuccin'

    local mode_colors = {
      n = '#38b1f0',
      i = '#9ece6a',
      c = '#e27d60',
      v = '#c678dd',
      V = '#c678dd',
    }

    local function dim_color(hex_color, dim_factor)
      -- Remove the leading '#' if it exists
      hex_color = hex_color:gsub('^#', '')

      -- Convert hex to RGB values
      local r = tonumber(hex_color:sub(1, 2), 16)
      local g = tonumber(hex_color:sub(3, 4), 16)
      local b = tonumber(hex_color:sub(5, 6), 16)

      -- Apply the dimming factor, ensuring values don't go below 0
      r = math.floor(r * dim_factor)
      g = math.floor(g * dim_factor)
      b = math.floor(b * dim_factor)

      -- Convert RGB back to hex, padding with a leading zero if needed
      return string.format('#%02x%02x%02x', r, g, b)
    end

    local function set_line_nr_color()
      local mode = vim.api.nvim_get_mode().mode
      -- local color_name = mode_colors[mode] or 'text' -- Default to 'text' if mode is not in the table
      -- local colors = require('catppuccin.palettes').get_palette()
      local mode_color = mode_colors[mode]

      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = mode_color, bold = true })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = dim_color(mode_color, 0.65) })
      -- vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = mode_color })
      -- vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = mode_color })
    end

    vim.api.nvim_create_augroup('ModeChangeLineNr', { clear = true })

    vim.api.nvim_create_autocmd('ModeChanged', {
      group = 'ModeChangeLineNr',
      callback = set_line_nr_color,
    })

    -- It's a good idea to run the function once on startup to set the initial color
    set_line_nr_color()
  end,
}
