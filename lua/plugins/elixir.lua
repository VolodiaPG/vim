return {
  'elixir-tools/elixir-tools.nvim',
  version = '*',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local elixir = require 'elixir'
    local elixirls = require 'elixir.elixirls'

    elixir.setup {
      nextls = {
        enable = true,
        cmd = 'nextls',
        init_options = {
          mix_env = 'dev',
          mix_target = 'host',
          experimental = {
            completions = {
              enable = true, -- control if completions are enabled. defaults to false
            },
          },
        },
        on_attach = function(client, bufnr)
          require('which-key').register {
            ['<leader>x'] = { name = 'Eli[x]ir', _ = 'which_key_ignore' },
          }
          vim.keymap.set('n', '<space>xa', ':Elixir nextls alias-refactor<cr>', { desc = '[a]lias refactor', buffer = true, noremap = true })
          vim.keymap.set('n', '<space>xf', ':Elixir nextls from-pipe<cr>', { desc = '[f]rom pipe', buffer = true, noremap = true })
          vim.keymap.set('n', '<space>xt', ':Elixir nextls to-pipe<cr>', { desc = '[t]o pipe', buffer = true, noremap = true })

          require('lspconfig').tailwindcss.setup {
            filetypes = { 'html', 'elixir', 'eelixir', 'heex' },
            init_options = {
              userLanguages = {
                elixir = 'html-eex',
                eelixir = 'html-eex',
                heex = 'html-eex',
              },
            },
            settings = {
              tailwindCSS = {
                experimental = {
                  classRegex = {
                    'class[:]\\s*"([^"]*)"',
                  },
                },
              },
            },
          }
        end,
      },
      credo = {
        enable = false,
      },
      elixirls = {
        enable = false,
        settings = elixirls.settings {
          dialyzerEnabled = true,
          enableTestLenses = false,
        },
        on_attach = function(client, bufnr)
          require('which-key').add {
            { '<leader>x', group = 'Eli[x]ir' },
          }
          vim.keymap.set('n', '<space>xP', ':ElixirFromPipe<cr>', { buffer = true, noremap = true })
          vim.keymap.set('n', '<space>xp', ':ElixirToPipe<cr>', { buffer = true, noremap = true })
          vim.keymap.set('n', '<space>xr', ':ElixirRestart<cr>', { buffer = true, noremap = true })
          vim.keymap.set('n', '<space>xo', ':ElixirOutputPanel<cr>', { buffer = true, noremap = true })
          vim.keymap.set('v', '<space>xm', ':ElixirExpandMacro<cr>', { buffer = true, noremap = true })

          require('lspconfig').tailwindcss.setup {
            filetypes = { 'html', 'elixir', 'eelixir', 'heex' },
            init_options = {
              userLanguages = {
                elixir = 'html-eex',
                eelixir = 'html-eex',
                heex = 'html-eex',
              },
            },
            settings = {
              tailwindCSS = {
                experimental = {
                  classRegex = {
                    'class[:]\\s*"([^"]*)"',
                  },
                },
              },
            },
          }
        end,
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
