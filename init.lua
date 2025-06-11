-- Neovim configuration
-- Author: Volodia
--
require('nixCatsUtils').setup {
  non_nix_value = true,
}

-- filter which-key warnings
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg:match 'which%-key' and level == vim.log.levels.WARN then
    return
  end
  orig_notify(msg, level, opts)
end

-- NOTE: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
  else
    return vim.fn.stdpath 'config' .. '/lazy-lock.json'
  end
end
local lazyOptions = {
  lockfile = getlockfilepath(),
  install = {
    colorscheme = { 'catppuccin' },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = 'rounded',
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

-- Load core settings
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- NOTE: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
  -- { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },
  -- The following configs are needed for fixing lazyvim on nix
  -- force enable telescope-fzf-native.nvim
  { 'nvim-telescope/telescope-fzf-native.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },
  -- disable mason.nvim while using nix
  -- precompiled binaries do not agree with nixos, and we can just make nix install this stuff for us.
  { 'williamboman/mason-lspconfig.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },
  { 'williamboman/mason.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },
  -- import/override with your plugins
  { import = 'plugins' },
}, lazyOptions)

vim.g.snacks_animate = false
vim.g.lazyvim_picker = 'snacks'
vim.opt.cmdheight = 0

vim.api.nvim_create_user_command(
  'FormatParagraph80', -- The name of your custom command
  function()
    -- Save the current position
    local save_cursor = vim.fn.getpos '.'

    -- Get the current paragraph boundaries more precisely
    -- First go to the start of the paragraph
    vim.cmd 'normal! {'

    -- If we're on a blank line, move down to the actual paragraph start
    if vim.fn.getline('.'):match '^%s*$' then
      vim.cmd 'normal! j'
    end

    local start_line = vim.fn.line '.'

    -- Go to the end of the paragraph
    vim.cmd 'normal! }'

    -- If we're on a blank line, move up to the actual paragraph end
    if vim.fn.getline('.'):match '^%s*$' then
      vim.cmd 'normal! k'
    end

    local end_line = vim.fn.line '.'

    -- Get the paragraph content
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local text = table.concat(lines, '\n')

    -- Use fmt to wrap the text
    local wrapped_text = vim.fn.system('fmt -w 80', text)

    -- Remove any trailing newline
    wrapped_text = wrapped_text:gsub('\n$', '')

    -- Split the wrapped text into lines
    local wrapped_lines = {}
    for line in string.gmatch(wrapped_text, '[^\n]+') do
      table.insert(wrapped_lines, line)
    end

    -- Replace the paragraph with the wrapped text
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, wrapped_lines)

    -- Restore the cursor position
    vim.fn.setpos('.', save_cursor)
  end,
  {
    desc = 'Formats the current paragraph to 80 characters', -- Description for :h :FormatParagraph80
    -- range = true,
  }
)

vim.keymap.set('n', '<leader>f80', ':FormatParagraph80<CR>', { desc = 'Format current paragraph to 80 chars' })
