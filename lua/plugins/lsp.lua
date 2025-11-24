-- LSP configuration

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'j-hui/fidget.nvim', -- LSP status updates
    'simrat39/inlay-hints.nvim', -- Inlay hints support
  },
  config = function()
    -- LSP server configurations
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            completion = { callSnippet = 'Replace' },
            hint = { enable = true },
          },
        },
      },
      r_language_server = {},
      air = {},
      elixirls = {
        cmd = { 'elixir-ls' },
      },
      bashls = {},
      basedpyright = {},
      nixd = {},
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = 'latexmk',
              onSave = true,
              forwardSearchAfter = false,
            },
            forwardSearch = {
              executable = 'displayline',
              args = { '%l', '%p', '%f' },
            },
            chktex = {
              onEdit = false,
              onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            latexFormatter = 'latexindent',
          },
        },
      },
    }

    -- Setup inlay hints
    require('inlay-hints').setup {
      only_current_line = false,
      eol = { right_align = false },
    }

    -- Setup fidget for LSP status
    require('fidget').setup {}

    -- LSP capabilities (for nvim-cmp integration)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Customize LSP UI
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

    vim.diagnostic.config {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = '●' },
      severity_sort = true,
      float = { border = 'rounded', source = 'always' },
    }

    -- LSP keymaps (set when LSP attaches to buffer)
    local on_attach = function(client, bufnr)
      -- Enable inlay hints if supported
      if client.server_capabilities.inlayHintProvider then
        require('inlay-hints').on_attach(client, bufnr)
      end

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      map('gd', vim.lsp.buf.definition, 'Goto Definition')
      map('gr', require('telescope.builtin').lsp_references, 'Goto References')
      map('gI', vim.lsp.buf.implementation, 'Goto Implementation')
      map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
      map('K', vim.lsp.buf.hover, 'Hover Documentation')
      map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
      map('<leader>rn', vim.lsp.buf.rename, 'Rename')
      map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
      map('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
      map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
      map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
        vim.lsp.buf.format { async = true }
      end, { desc = 'Format buffer with LSP' })
    end

    -- Setup each LSP server
    for server, config in pairs(servers) do
      config.capabilities = capabilities
      config.on_attach = on_attach
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
