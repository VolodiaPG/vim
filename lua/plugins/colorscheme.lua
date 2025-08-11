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

    local C = require('catppuccin.palettes').get_palette()
    local mode_colors = {
      ['n'] = { 'NORMAL', '#38b1f0' },
      ['no'] = { 'N-PENDING', '#38b1f0' },
      ['i'] = { 'INSERT', '#9ece6a' },
      ['ic'] = { 'INSERT', '#9ece6a' },
      ['t'] = { 'TERMINAL', C.green },
      ['v'] = { 'VISUAL', '#c678dd' },
      ['V'] = { 'V-LINE', '#c678dd' },
      ['\22'] = { 'V-BLOCK', C.flamingo }, -- The '' character is 0x16 or "\22"
      ['R'] = { 'REPLACE', C.maroon },
      ['Rv'] = { 'V-REPLACE', C.maroon },
      ['s'] = { 'SELECT', C.maroon },
      ['S'] = { 'S-LINE', C.maroon },
      ['\19'] = { 'S-BLOCK', C.maroon }, -- The '' character is 0x13 or "\19"
      ['c'] = { 'COMMAND', C.peach },
      ['cv'] = { 'COMMAND', C.peach },
      ['ce'] = { 'COMMAND', C.peach },
      ['r'] = { 'PROMPT', C.teal },
      ['rm'] = { 'MORE', C.teal },
      ['r?'] = { 'CONFIRM', C.mauve },
      ['!'] = { 'SHELL', C.green },
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
    -- Function to set line number color based on mode
    local function set_line_nr_color()
      local mode = vim.api.nvim_get_mode().mode
      local mode_info = mode_colors[mode]

      -- Use a default color if the mode is not found
      local mode_color = mode_info and mode_info[2] or C.text

      -- Use a dimmer color for the non-cursor line numbers
      local dim_color = dim_color(mode_color, 0.65)

      -- Set the highlight for the dim line numbers
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = mode_color, bold = true })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = dim_color })
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
