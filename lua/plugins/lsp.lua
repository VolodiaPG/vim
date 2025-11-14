-- LSP configuration

return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', opts = {} },

    -- Useful plugin to show you pending keybinds
    { 'folke/which-key.nvim', opts = {} },

    -- Inlay hints
    'simrat39/inlay-hints.nvim',
  },
  build = require('nixCatsUtils').lazyAdd ':TSUpdate',
  opts_extend = require('nixCatsUtils').lazyAdd(nil, false),
  config = function()
    -- Enable the following language servers
    -- First value is the lsp, second repetition are the args passed as
    -- config
    local servers = {
      lua_ls = {
        settings = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          completion = { callSnippet = 'Replace' },
          hint = { enable = true },
        },
        filetypes = { 'lua' },
      },
      r_language_server = {},
      air = {
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
      -- lexical = {
      --   cmd = { os.getenv 'LEXICAL' },
      --   cmd = { 'lexical' },
      -- },
      -- nextls = {
      --   cmd = { 'nextls' },
      -- },
      elixirls = {
        flags = {
          debounce_text_changes = 150,
        },
        cmd = { 'elixir-ls' },
        -- settings = {
        --   elixirLS = {
        --     dialyzerEnabled = false,
        --   },
        -- },
        filetypes = { 'elixir', 'eelixir', 'heex' },
      },
      bashls = {},
      basedpyright = {},
      -- Add other servers as needed
      -- rust_analyzer = {},
      -- tsserver = {},
      -- html = { filetypes = { 'html', 'twig', 'hbs'} },
      nixd = {},
      texlab = {},
    }

    -- Setup inlay hints
    local inlay_hints = require 'inlay-hints'
    inlay_hints.setup {
      only_current_line = false,
      eol = {
        right_align = false,
      },
    }

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    capabilities.offsetEncoding = { 'utf-16' }

    -- Setup LSP handlers
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
    })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = 'rounded',
    })

    -- Customize diagnostics
    vim.diagnostic.config {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = '●' },
      severity_sort = true,
      float = {
        border = 'rounded',
        source = 'always',
      },
    }

    for server_name, cfg in pairs(servers) do
      -- Keymaps
      local on_attach = function(client, bufnr)
        -- Enable inlay hints if supported
        if client.server_capabilities.inlayHintProvider then
          inlay_hints.on_attach(client, bufnr)
        end

        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
        nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
        nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
        nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'Workspace List Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format { async = true }
        end, { desc = 'Format current buffer with LSP' })

        if cfg.on_attach then
          cfg.on_attach(client, bufnr)
        end
      end
      vim.lsp.config[server_name] = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = (cfg or {}).settings,
        filetypes = (cfg or {}).filetypes,
        cmd = (cfg or {}).cmd,
        root_pattern = (cfg or {}).root_pattern,
      }
    end
  end,
}
