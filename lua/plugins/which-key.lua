-- Which-key configuration

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    local which_key = require 'which-key'

    which_key.setup {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the preset / operators plugin above
      operators = { gc = 'Comments' },
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
      },
      icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = '➜', -- symbol used between a key and it's label
        group = '+', -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>', -- binding to scroll up inside the popup
      },
      window = {
        border = 'rounded', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = 'left', -- align columns left, center or right
      },
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      show_help = true, -- show help message on the command line when the popup is visible
      show_keys = true, -- show the currently pressed key and its label as a message in the command line
      triggers = 'auto', -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specify a list manually
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { 'j', 'k' },
        v = { 'j', 'k' },
      },
      -- disable the WhichKey popup for certain buf types and file types.
      -- Disabled by default for Telescope
      disable = {
        buftypes = {},
        filetypes = { 'TelescopePrompt' },
      },
    }

    -- Register key mappings
    which_key.register {
      ['<leader>'] = {
        f = {
          name = 'Find',
          f = { '<cmd>Telescope find_files<cr>', 'Find files' },
          g = { '<cmd>Telescope live_grep<cr>', 'Live grep' },
          b = { '<cmd>Telescope buffers<cr>', 'Find buffers' },
          h = { '<cmd>Telescope help_tags<cr>', 'Help tags' },
          r = { '<cmd>Telescope oldfiles<cr>', 'Recent files' },
          c = { '<cmd>Telescope commands<cr>', 'Commands' },
          k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
          s = { '<cmd>Telescope lsp_document_symbols<cr>', 'Document symbols' },
          S = { '<cmd>Telescope lsp_workspace_symbols<cr>', 'Workspace symbols' },
          d = { '<cmd>Telescope diagnostics<cr>', 'Diagnostics' },
        },
        g = {
          name = 'Git',
          g = { '<cmd>LazyGit<cr>', 'LazyGit' },
          s = {
            function()
              require('gitsigns').stage_hunk()
            end,
            'Stage hunk',
          },
          r = {
            function()
              require('gitsigns').reset_hunk()
            end,
            'Reset hunk',
          },
          S = {
            function()
              require('gitsigns').stage_buffer()
            end,
            'Stage buffer',
          },
          u = {
            function()
              require('gitsigns').undo_stage_hunk()
            end,
            'Undo stage hunk',
          },
          R = {
            function()
              require('gitsigns').reset_buffer()
            end,
            'Reset buffer',
          },
          p = {
            function()
              require('gitsigns').preview_hunk()
            end,
            'Preview hunk',
          },
          b = {
            function()
              require('gitsigns').blame_line { full = true }
            end,
            'Blame line',
          },
          d = {
            function()
              require('gitsigns').diffthis()
            end,
            'Diff this',
          },
          D = {
            function()
              require('gitsigns').diffthis '~'
            end,
            'Diff this ~',
          },
        },
        h = {
          name = 'Harpoon',
          s = {
            function()
              require('harpoon'):list():append()
            end,
            'Add file',
          },
          d = {
            function()
              require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
            end,
            'Toggle menu',
          },
          p = {
            function()
              require('harpoon'):list():prev()
            end,
            'Previous file',
          },
          n = {
            function()
              require('harpoon'):list():next()
            end,
            'Next file',
          },
          ['1'] = {
            function()
              require('harpoon'):list():select(1)
            end,
            'File 1',
          },
          ['2'] = {
            function()
              require('harpoon'):list():select(2)
            end,
            'File 2',
          },
          ['3'] = {
            function()
              require('harpoon'):list():select(3)
            end,
            'File 3',
          },
          ['4'] = {
            function()
              require('harpoon'):list():select(4)
            end,
            'File 4',
          },
          ['5'] = {
            function()
              require('harpoon'):list():select(5)
            end,
            'File 5',
          },
          ['6'] = {
            function()
              require('harpoon'):list():select(6)
            end,
            'File 6',
          },
          ['7'] = {
            function()
              require('harpoon'):list():select(7)
            end,
            'File 7',
          },
          ['8'] = {
            function()
              require('harpoon'):list():select(8)
            end,
            'File 8',
          },
          ['9'] = {
            function()
              require('harpoon'):list():select(9)
            end,
            'File 9',
          },
        },
        l = {
          name = 'LSP',
          a = {
            function()
              vim.lsp.buf.code_action()
            end,
            'Code action',
          },
          d = {
            function()
              vim.lsp.buf.definition()
            end,
            'Go to definition',
          },
          D = {
            function()
              vim.lsp.buf.declaration()
            end,
            'Go to declaration',
          },
          i = {
            function()
              vim.lsp.buf.implementation()
            end,
            'Go to implementation',
          },
          r = {
            function()
              vim.lsp.buf.references()
            end,
            'References',
          },
          t = {
            function()
              vim.lsp.buf.type_definition()
            end,
            'Type definition',
          },
          R = {
            function()
              vim.lsp.buf.rename()
            end,
            'Rename',
          },
          f = {
            function()
              vim.lsp.buf.format { async = true }
            end,
            'Format',
          },
          k = {
            function()
              vim.lsp.buf.hover()
            end,
            'Hover',
          },
          s = {
            function()
              vim.lsp.buf.signature_help()
            end,
            'Signature help',
          },
        },
        t = {
          name = 'LaTeX',
          c = { '<cmd>VimtexCompile<cr>', 'Compile' },
          v = { '<cmd>VimtexView<cr>', 'View PDF' },
          t = { '<cmd>VimtexTocToggle<cr>', 'Toggle TOC' },
          e = { '<cmd>VimtexErrors<cr>', 'Show errors' },
          s = { '<cmd>VimtexStop<cr>', 'Stop compilation' },
          S = { '<cmd>VimtexStopAll<cr>', 'Stop all compilations' },
          i = { '<cmd>VimtexInfo<cr>', 'Show info' },
          I = { '<cmd>VimtexInfoFull<cr>', 'Show detailed info' },
          l = { '<cmd>VimtexLog<cr>', 'Show log' },
          L = { '<cmd>VimtexClean<cr>', 'Clean auxiliary files' },
          k = { '<cmd>VimtexDocPackage<cr>', 'Show package documentation' },
          K = { '<cmd>VimtexCountWords<cr>', 'Count words' },
          x = { '<cmd>VimtexReload<cr>', 'Reload VimTeX' },
        },
        d = {
          name = 'Diagnostics',
          d = {
            function()
              vim.diagnostic.open_float()
            end,
            'Open float',
          },
          n = {
            function()
              vim.diagnostic.goto_next()
            end,
            'Next diagnostic',
          },
          p = {
            function()
              vim.diagnostic.goto_prev()
            end,
            'Previous diagnostic',
          },
          l = {
            function()
              vim.diagnostic.setloclist()
            end,
            'Set loclist',
          },
        },
      },
    }
  end,
}

