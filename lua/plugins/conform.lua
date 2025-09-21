-- Formatter configuration

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    -- Define formatters
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      json = { 'prettierd' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      markdown = { 'prettierd' },
      yaml = { 'prettierd' },
      shell = { 'shfmt', 'shellcheck', 'shellharden' },
      rust = { 'rustfmt' },
      go = { 'gofmt' },
      tex = { 'latexindent', 'typos' },
      nix = { 'nixfmt' },
      r = { 'air' },
      elixir = { 'mix', 'credo' },
      ['*'] = { 'trim_whitespace' },
    },

    -- Set up format-on-save
    format_after_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 3000, lsp_fallback = true }
    end,

    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { '-i', '2', '-ci' },
      },
      stylua = {
        prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' },
      },
    },
  },
  init = function()
    -- Create commands to enable/disable format-on-save
    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- FormatDisable! will disable formatting globally
        vim.g.disable_autoformat = true
      else
        -- FormatDisable will disable formatting for the current buffer
        vim.b.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformatting',
      bang = true,
    })

    vim.api.nvim_create_user_command('FormatEnable', function()
      -- FormatEnable will enable formatting for the current buffer
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Enable autoformatting',
    })
  end,
}
