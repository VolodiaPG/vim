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
