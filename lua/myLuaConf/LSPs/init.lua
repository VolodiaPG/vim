-- LSP configuration

local catUtils = require 'nixCatsUtils'
if catUtils.isNixCats and nixCats 'lspDebugMode' then
  vim.lsp.set_log_level 'debug'
end

-- NOTE: This file uses lzextras.lsp handler https://github.com/BirdeeHub/lzextras?tab=readme-ov-file#lsp-handler
-- This is a slightly more performant fallback function
-- for when you don't provide a filetype to trigger on yourself.
-- nixCats gives us the paths, which is faster than searching the rtp!
local old_ft_fallback = require('lze').h.lsp.get_ft_fallback()
require('lze').h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixCats.pawsible { 'allPlugins', 'opt', 'nvim-lspconfig' } or nixCats.pawsible { 'allPlugins', 'start', 'nvim-lspconfig' }
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. '/lsp/' .. name .. '.lua')
    if not ok then
      ok, cfg = pcall(dofile, lspcfg .. '/lua/lspconfig/configs/' .. name .. '.lua')
    end
    return (ok and cfg or {}).filetypes or {}
  else
    return old_ft_fallback(name)
  end
end)

require('lze').load {
  {
    'nvim-lspconfig',
    for_cat = 'general.always',
    -- NOTE: Use on_require to load when LSP functionality is needed
    on_require = { 'lspconfig' },
    -- Use keys to load when LSP commands are used
    keys = {
      { 'gd', vim.lsp.buf.definition, 'Goto Definition' },
      { 'gr', require('telescope.builtin').lsp_references, 'Goto References' },
      { 'gI', vim.lsp.buf.implementation, 'Goto Implementation' },
      { 'gD', vim.lsp.buf.declaration, 'Goto Declaration' },
      { 'K', vim.lsp.buf.hover, 'Hover Documentation' },
      { '<C-k>', vim.lsp.buf.signature_help, 'Signature Help' },
      { '<leader>rn', vim.lsp.buf.rename, 'Rename' },
      { '<leader>c,', vim.lsp.buf.code_action, 'Code Action' },
      { '<leader>D', vim.lsp.buf.type_definition, 'Type Definition' },
      { '<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols' },
      { '<leader>dws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols' },
    },
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.lsp.config('*', {
        on_attach = require 'myLuaConf.LSPs.on_attach',
      })
    end,
  },
  {
    'inlay-hints',
    for_cat = 'general.always',
    after = function(_)
      require('inlay-hints').setup {
        only_current_line = false,
        eol = { right_align = false },
      }
    end,
  },
  {
    -- lazydev makes your lsp way better in your config without needing extra lsp configuration.
    'lazydev.nvim',
    for_cat = 'general.always',
    cmd = { 'LazyDev' },
    ft = 'lua',
    after = function(_)
      require('lazydev').setup {
        library = {
          { words = { 'nixCats' }, path = (nixCats.nixCatsPath or '') .. '/lua' },
        },
      }
    end,
  },
  {
    -- name of the lsp
    'lua_ls',
    enabled = nixCats 'always',
    -- provide a table containing filetypes,
    -- and then whatever your functions defined in the function type specs expect.
    -- in our case, it just expects the normal lspconfig setup options,
    -- but with a default on_attach and capabilities
    lsp = {
      -- if you provide the filetypes it doesn't ask lspconfig for the filetypes
      filetypes = { 'lua' },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          formatters = {
            ignoreComments = true,
          },
          signatureHelp = { enabled = true },
          diagnostics = {
            globals = { 'nixCats', 'vim' },
            disable = { 'missing-fields' },
          },
          telemetry = { enabled = false },
        },
      },
    },
    -- also these are regular specs and you can use before and after and all the other normal fields
  },
  {
    'gopls',
    enabled = nixCats 'always',
    -- if you don't provide the filetypes it asks lspconfig for them
    lsp = {
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    },
  },
  {
    'nixd',
    enabled = nixCats 'always',
    lsp = {
      filetypes = { 'nix' },
      settings = {
        nixd = {
          -- nixd requires some configuration.
          -- luckily, the nixCats plugin is here to pass whatever we need!
          -- we passed this in via the `extra` table in our packageDefinitions
          -- for additional configuration options, refer to:
          -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
          -- nixpkgs = {
          --   -- in the extras set of your package definition:
          --   -- nixdExtras.nixpkgs = ''import ${pkgs.path} {}''
          --   expr = nixCats.extra 'nixdExtras.nixpkgs' or [[import <nixpkgs> {}]],
          -- },
          -- options = {
          --   -- If you integrated with your system flake,
          --   -- you should use inputs.self as the path to your system flake
          --   -- that way it will ALWAYS work, regardless
          --   -- of where your config actually was.
          --   nixos = {
          --     -- nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").nixosConfigurations.configname.options''
          --     expr = nixCats.extra 'nixdExtras.nixos_options',
          --   },
          --   -- If you have your config as a separate flake, inputs.self would be referring to the wrong flake.
          --   -- You can override the correct one into your package definition on import in your main configuration,
          --   -- or just put an absolute path to where it usually is and accept the impurity.
          --   ['home-manager'] = {
          --     -- nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").homeConfigurations.configname.options''
          --     expr = nixCats.extra 'nixdExtras.home_manager_options',
          --   },
          -- },
          formatting = {
            command = { 'nixfmt' },
          },
          diagnostic = {
            suppress = {
              'sema-escaping-with',
            },
          },
        },
      },
    },
  },
  { 'r_language_server', enabled = nixCats 'always', lsp = {
    filetypes = { 'R', 'Rmd' },
  } },
  { 'air', enabled = nixCats 'always', lsp = {
    filetypes = { 'R', 'Rmd' },
  } },
  {
    'expert',
    lsp = {
      settings = {

        filetypes = { 'elixir', 'heex', 'eex' },
        expert = {
          cmd = { 'expert', '--stdio' },
          root_markers = { 'mix.exs', '.git' },
        },
      },
    },
  },
  { 'bashls', enabled = nixCats 'always', lsp = {
    filetypes = { 'sh', 'bash' },
  } },
  { 'basedpyright', enabled = nixCats 'always', lsp = {
    filetypes = { 'python' },
  } },
  {
    'texlab',
    enabled = nixCats 'always',
    lsp = {
      filetypes = { 'tex', 'latex' },
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
  },
  {
    'tinymist',
    enabled = nixCats 'always',
    lsp = {
      filetypes = { 'typstyle', 'typst' },
      settings = {
        tinymist = {
          formatterMode = 'typstyle',
          exportPdf = 'onType',
          semanticTokens = 'disable',
        },
      },
    },
  },
  -- load = function(name)
  --   vim.cmd.packadd(name)
  --   vim.cmd.packadd 'fidget.nvim'
  --   vim.cmd.packadd 'inlay-hints.nvim'
  -- end,
  -- after = function(plugin)
  --   -- Setup inlay hints
  --   require('inlay-hints').setup {
  --     only_current_line = false,
  --     eol = { right_align = false },
  --   }
  --
  --   -- Setup fidget for LSP status
  --   require('fidget').setup {}
  --
  --   -- LSP capabilities (for blink.cmp integration)
  --   local capabilities = vim.lsp.protocol.make_client_capabilities()
  --   capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
  --
  --   -- Customize LSP UI
  --   vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  --   vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
  --
  --   vim.diagnostic.config {
  --     underline = true,
  --     update_in_insert = false,
  --     virtual_text = { spacing = 4, prefix = '●' },
  --     severity_sort = true,
  --     float = { border = 'rounded', source = 'always' },
  --   }
  --
  --   -- Get on_attach function
  --   local on_attach = require 'myLuaConf.LSPs.on_attach'
  --
  --   -- LSP server configurations
  --   local servers = {
  --     lua_ls = {
  --       settings = {
  --         Lua = {
  --           workspace = { checkThirdParty = false },
  --           telemetry = { enable = false },
  --           completion = { callSnippet = 'Replace' },
  --           hint = { enable = true },
  --         },
  --       },
  --     },
  --     r_language_server = {},
  --     air = {},
  --     elixirls = {
  --       cmd = { 'elixir-ls' },
  --     },
  --     bashls = {},
  --     basedpyright = {},
  --     nixd = {},
  --     texlab = {
  --       settings = {
  --         texlab = {
  --           build = {
  --             executable = 'latexmk',
  --             onSave = true,
  --             forwardSearchAfter = false,
  --           },
  --           forwardSearch = {
  --             executable = 'displayline',
  --             args = { '%l', '%p', '%f' },
  --           },
  --           chktex = {
  --             onEdit = false,
  --             onOpenAndSave = true,
  --           },
  --           diagnosticsDelay = 300,
  --           latexFormatter = 'latexindent',
  --         },
  --       },
  --     },
  --     tinymist = {
  --       settings = {
  --         formatterMode = 'typstyle',
  --         exportPdf = 'onType',
  --         semanticTokens = 'disable',
  --       },
  --     },
  --   }
  --
  --   -- Setup each LSP server
  --   for server, config in pairs(servers) do
  --     config.capabilities = capabilities
  --     config.on_attach = on_attach
  --     vim.lsp.config(server, config)
  --     vim.lsp.enable(server)
  --   end
  -- end,
}
