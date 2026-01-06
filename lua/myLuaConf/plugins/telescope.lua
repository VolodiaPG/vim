-- Telescope configuration

-- Custom live_grep function to search in git root
local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  if current_file == '' then
    current_dir = cwd
  else
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

return {
  'telescope.nvim',
  for_cat = 'general.treesitter',
  cmd = { 'Telescope', 'LiveGrepGitRoot' },
  on_require = { 'telescope' },
  keys = {
    { '<leader>sM', '<cmd>Telescope notify<CR>', mode = { 'n' }, desc = '[S]earch [M]essage' },
    { '<leader>sp', live_grep_git_root, mode = { 'n' }, desc = '[S]earch git [P]roject root' },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      mode = { 'n' },
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end,
      mode = { 'n' },
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader><leader>s',
      function()
        return require('telescope.builtin').buffers()
      end,
      mode = { 'n' },
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>s.',
      function()
        return require('telescope.builtin').oldfiles()
      end,
      mode = { 'n' },
      desc = '[S]earch Recent Files ("." for repeat)',
    },
    {
      '<leader>sr',
      function()
        return require('telescope.builtin').resume()
      end,
      mode = { 'n' },
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>sd',
      function()
        return require('telescope.builtin').diagnostics()
      end,
      mode = { 'n' },
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sg',
      function()
        return require('telescope.builtin').live_grep()
      end,
      mode = { 'n' },
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sw',
      function()
        return require('telescope.builtin').grep_string()
      end,
      mode = { 'n' },
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>ss',
      function()
        return require('telescope.builtin').builtin()
      end,
      mode = { 'n' },
      desc = '[S]earch [S]elect Telescope',
    },
    {
      '<leader>sf',
      function()
        return require('telescope.builtin').find_files()
      end,
      mode = { 'n' },
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sk',
      function()
        return require('telescope.builtin').keymaps()
      end,
      mode = { 'n' },
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sh',
      function()
        return require('telescope.builtin').help_tags()
      end,
      mode = { 'n' },
      desc = '[S]earch [H]elp',
    },
    { '<leader>fb', '<cmd>Telescope find_files<cr>', mode = { 'n' }, desc = 'Find files' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', mode = { 'n' }, desc = 'Live grep' },
    { '<leader>fr', '<cmd>Telescope resume<cr>', mode = { 'n' }, desc = 'Resume last search' },
    { '<leader>ft', '<cmd>Telescope search_history<cr>', mode = { 'n' }, desc = 'Search history' },
    { '<leader>fk', '<cmd>Telescope keymaps<cr>', mode = { 'n' }, desc = 'Keymaps' },
    { '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>', mode = { 'n' }, desc = 'Document symbols' },
    { '<leader>fS', '<cmd>Telescope lsp_workspace_symbols<cr>', mode = { 'n' }, desc = 'Workspace symbols' },
    { '<leader>fd', '<cmd>Telescope diagnostics<cr>', mode = { 'n' }, desc = 'Diagnostics' },
  },
  load = function(name)
    vim.cmd.packadd(name)
    vim.cmd.packadd 'telescope-fzf-native.nvim'
    vim.cmd.packadd 'telescope-ui-select.nvim'
  end,
  after = function(plugin)
    local telescope = require 'telescope'

    telescope.setup {
      defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        path_display = { 'truncate' },
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
  end,
}
