-- Neovim configuration
-- Author: Volodia
--
require('nixCatsUtils').setup {
  non_nix_value = true,
}

-- Load main configuration
require 'myLuaConf'

-- filter which-key warnings
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg:match 'which%-key' and level == vim.log.levels.WARN then
    return
  end
  orig_notify(msg, level, opts)
end

-- Load plugins via paq when not on nix
-- require 'myLuaConf.non_nix_download'

vim.g.snacks_animate = false
vim.g.lazyvim_picker = 'snacks'
vim.opt.cmdheight = 0

-- Start the server
local socket_path = '/tmp/nvim_' .. vim.loop.os_getpid()
vim.fn.serverstart(socket_path)

vim.api.nvim_create_user_command('FormatParagraph80', function()
  local save_cursor = vim.fn.getpos '.'

  vim.cmd 'normal! {'
  if vim.fn.getline('.'):match '^%s*$' then
    vim.cmd 'normal! j'
  end

  local start_line = vim.fn.line '.'

  vim.cmd 'normal! }'
  if vim.fn.getline('.'):match '^%s*$' then
    vim.cmd 'normal! k'
  end

  local end_line = vim.fn.line '.'

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, '\n')

  local wrapped_text = vim.fn.system('fmt -w 80', text)
  wrapped_text = wrapped_text:gsub('\n$', '')

  local wrapped_lines = {}
  for line in string.gmatch(wrapped_text, '[^\n]+') do
    table.insert(wrapped_lines, line)
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, wrapped_lines)
  vim.fn.setpos('.', save_cursor)
end, {
  desc = 'Formats the current paragraph to 80 characters',
})

vim.keymap.set('n', '<leader>f80', ':FormatParagraph80<CR>', { desc = 'Format current paragraph to 80 chars' })
