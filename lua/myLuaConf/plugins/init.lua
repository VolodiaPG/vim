local colorschemeName = nixCats 'colorscheme'
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'catppuccin'
end

require('lze').load {
  -- Import split plugin files
  { import = 'myLuaConf.plugins.telescope' },
  { import = 'myLuaConf.plugins.treesitter' },
  { import = 'myLuaConf.plugins.completion' },

  -- Colorscheme - load first with high priority
  {
    'catppuccin',
    name = 'catppuccin',
    priority = 1000,
    for_cat = 'themer',
    -- event = 'DeferredUIEnter',
    after = function(plugin)
      require('catppuccin').setup {
        flavour = 'macchiato',
        background = {
          light = 'macchiato',
          dark = 'macchiato',
        },
        transparent_background = true,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = 'dark',
          percentage = 0.15,
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = true,
          mini = false,
          harpoon = true,
          which_key = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          native_lsp = {
            enabled = true,
          },
          treesitter = true,
          treesitter_context = true,
        },
      }
      vim.cmd.colorscheme(colorschemeName)

      local C = require('catppuccin.palettes').get_palette()
      local mode_colors = {
        ['n'] = { 'NORMAL', '#38b1f0' },
        ['no'] = { 'N-PENDING', '#38b1f0' },
        ['i'] = { 'INSERT', '#9ece6a' },
        ['ic'] = { 'INSERT', '#9ece6a' },
        ['t'] = { 'TERMINAL', C.green },
        ['v'] = { 'VISUAL', '#c678dd' },
        ['V'] = { 'V-LINE', '#c678dd' },
        ['\22'] = { 'V-BLOCK', C.flamingo },
        ['R'] = { 'REPLACE', C.maroon },
        ['Rv'] = { 'V-REPLACE', C.maroon },
        ['s'] = { 'SELECT', C.maroon },
        ['S'] = { 'S-LINE', C.maroon },
        ['\19'] = { 'S-BLOCK', C.maroon },
        ['c'] = { 'COMMAND', C.peach },
        ['cv'] = { 'COMMAND', C.peach },
        ['ce'] = { 'COMMAND', C.peach },
        ['r'] = { 'PROMPT', C.teal },
        ['rm'] = { 'MORE', C.teal },
        ['r?'] = { 'CONFIRM', C.mauve },
        ['!'] = { 'SHELL', C.green },
      }

      local function dim_color(hex_color, dim_factor)
        hex_color = hex_color:gsub('^#', '')
        local r = tonumber(hex_color:sub(1, 2), 16)
        local g = tonumber(hex_color:sub(3, 4), 16)
        local b = tonumber(hex_color:sub(5, 6), 16)
        r = math.floor(r * dim_factor)
        g = math.floor(g * dim_factor)
        b = math.floor(b * dim_factor)
        return string.format('#%02x%02x%02x', r, g, b)
      end

      local function set_line_nr_color()
        local mode = vim.api.nvim_get_mode().mode
        local mode_info = mode_colors[mode]
        local mode_color = mode_info and mode_info[2] or C.text
        local dim_color = dim_color(mode_color, 0.65)
        vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = mode_color, bold = true })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = dim_color })
      end

      vim.api.nvim_create_augroup('ModeChangeLineNr', { clear = true })
      vim.api.nvim_create_autocmd('ModeChanged', {
        group = 'ModeChangeLineNr',
        callback = set_line_nr_color,
      })
      set_line_nr_color()
    end,
  },

  -- Notify
  {
    'nvim-notify',
    for_cat = 'general.always',
    event = 'DeferredUIEnter',
    keys = {
      {
        '<Leader>un',
        function()
          require('notify').dismiss { silent = true, pending = true }
        end,
        desc = 'Dismiss all notifications (Notify)',
      },
    },
    after = function(plugin)
      vim.notify = require 'notify'
      vim.notify.setup {
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { focusable = false })
        end,
        stages = 'static',
        timeout = 3000,
      }
      vim.keymap.set('n', '<Esc>', function()
        require('notify').dismiss { silent = true }
      end, { desc = 'dismiss notify popup and clear hlsearch' })
    end,
  },

  -- Noice
  {
    'noice.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',
    load = function(name)
      vim.cmd.packadd 'nui.nvim'
      vim.cmd.packadd 'nvim-notify'
    end,
    after = function(plugin)
      require('noice').setup {}
    end,
  },

  -- Statusline
  {
    'staline.nvim',
    for_cat = 'general.always',
    -- event = 'DeferredUIEnter',
    load = function(name)
      vim.cmd.packadd 'nvim-web-devicons'
    end,
    after = function(plugin)
      require('staline').setup {
        sections = {
          left = {
            '▊',
            ' ',
            { 'Evil', 'mode' },
            ' ',
            'file_name',
            ' ',
            'branch',
          },
          mid = { 'lsp' },
          right = {
            'lsp_name',
            ' ',
            'file_size',
            ' ',
            'line_column',
          },
        },
        mode_colors = {
          n = '#38b1f0',
          i = '#9ece6a',
          c = '#e27d60',
          v = '#c678dd',
          V = '#c678dd',
        },
        defaults = {
          true_colors = true,
          line_column = ' [%l/%L] :%c ',
          branch_symbol = ' ',
          mod_symbol = '  ',
        },
        special_table = {
          NvimTree = { 'File Explorer', ' ' },
          packer = { 'Packer', ' ' },
          TelescopePrompt = { 'Telescope', ' ' },
          mason = { 'Mason', ' ' },
          lze = { 'lze', ' ' },
        },
        lsp_symbols = {
          Error = ' ',
          Info = ' ',
          Warn = ' ',
          Hint = ' ',
        },
      }
    end,
  },

  -- Gitsigns
  {
    'gitsigns.nvim',
    for_cat = 'general.always',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('gitsigns').setup {
        signs = {
          add = { text = '│' },
          change = { text = '│' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = 'rounded',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Next hunk' })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Previous hunk' })

          map('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset hunk' })
          map('v', '<leader>gs', function()
            gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'Stage selected hunk' })
          map('v', '<leader>gr', function()
            gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'Reset selected hunk' })
          map('n', '<leader>gS', gs.stage_buffer, { desc = 'Stage buffer' })
          map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
          map('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset buffer' })
          map('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview hunk' })
          map('n', '<leader>gb', function()
            gs.blame_line { full = true }
          end, { desc = 'Blame line' })
          map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
          map('n', '<leader>gd', gs.toggle_word_diff, { desc = 'Diff this inline buffer' })
          map('n', '<leader>gD', gs.diffthis, { desc = 'Diff this buffer side by side' })
          map('n', '<leader>gtd', gs.toggle_deleted, { desc = 'Toggle deleted' })

          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
        end,
      }
    end,
  },

  -- Which-key
  {
    'which-key.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('which-key').setup {
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        icons = {
          breadcrumb = '»',
          separator = '➜',
          group = '+',
        },
        show_help = true,
        disable = {
          buftypes = {},
          filetypes = { 'TelescopePrompt' },
        },
      }

      require('which-key').add {
        { '<leader><leader>', group = 'buffer commands' },
        { '<leader><leader>_', hidden = true },
        { '<leader>c', group = '[c]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>d', group = '[d]ocument' },
        { '<leader>d_', hidden = true },
        { '<leader>g', group = '[g]it' },
        { '<leader>g_', hidden = true },
        { '<leader>h', group = '[h]arpoon' },
        { '<leader>h_', hidden = true },
        { '<leader>l', group = '[l]sp' },
        { '<leader>l_', hidden = true },
        { '<leader>t', group = '[t]oggles' },
        { '<leader>t_', hidden = true },
      }
    end,
  },

  -- LazyGit
  {
    'lazygit.nvim',
    for_cat = 'general.always',
    keys = {
      { '<leader>gg', '<cmd>LazyGit<CR>', mode = { 'n' }, desc = 'LazyGit (root dir)' },
      {
        '<leader>gG',
        function()
          vim.cmd 'Telescope lazygit'
        end,
        mode = { 'n' },
        desc = 'LazyGit repositories',
      },
    },
    load = function(name)
      vim.cmd.packadd 'plenary.nvim'
      vim.cmd.packadd 'telescope.nvim'
    end,
    before = function(_)
      vim.fn.sign_define('LazyGitAugend', { text = '+', texthl = 'GreenSign' })
      vim.fn.sign_define('LazyGitReword', { text = '~', texthl = 'YellowSign' })
      vim.fn.sign_define('LazyGitDelete', { text = '-', texthl = 'RedSign' })
    end,
    after = function(plugin)
      require('telescope').load_extension 'lazygit'
    end,
  },

  -- Harpoon
  {
    'harpoon',
    for_cat = 'general.always',
    load = function(name)
      vim.cmd.packadd 'plenary.nvim'
      vim.cmd.packadd 'telescope.nvim'
    end,
    after = function(plugin)
      local harpoon = require 'harpoon'
      harpoon:setup {}
      require('telescope').load_extension 'harpoon'

      vim.keymap.set('n', '<leader>hs', function()
        harpoon:list():add()
      end, { desc = 'Harpoon add file' })

      vim.keymap.set('n', '<leader>hd', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon quick menu' })

      vim.keymap.set('n', '&', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon file 1' })

      vim.keymap.set('n', 'é', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon file 2' })

      vim.keymap.set('n', '"', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon file 3' })

      vim.keymap.set('n', "'", function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon file 4' })

      vim.keymap.set('n', '(', function()
        harpoon:list():select(5)
      end, { desc = 'Harpoon file 5' })

      vim.keymap.set('n', '§', function()
        harpoon:list():select(6)
      end, { desc = 'Harpoon file 6' })

      vim.keymap.set('n', 'è', function()
        harpoon:list():select(7)
      end, { desc = 'Harpoon file 7' })

      vim.keymap.set('n', '!', function()
        harpoon:list():select(8)
      end, { desc = 'Harpoon file 8' })

      vim.keymap.set('n', 'ç', function()
        harpoon:list():select(9)
      end, { desc = 'Harpoon file 9' })

      vim.keymap.set('n', '<leader>hp', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon prev file' })

      vim.keymap.set('n', '<leader>hn', function()
        harpoon:list():next()
      end, { desc = 'Harpoon next file' })
    end,
  },

  -- Tmux navigator
  {
    'vim-tmux-navigator',
    event = 'DeferredUIEnter',
  },
  --
  -- VimTeX
  {
    'vimtex',
    for_cat = 'general.always',
    ft = 'tex',
    lazy = false,
    after = function(_)
      local os_name = vim.loop.os_uname().sysname
      if os_name == 'Linux' then
        vim.g.vimtex_view_general_viewer = 'qpdfview'
      else
        vim.g.vimtex_view_method = 'skim'
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_activate = 1
      end
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_quickfix_mode = 2
      vim.g.vimtex_syntax_enabled = false

      vim.keymap.set('n', '<leader>tc', '<cmd>VimtexCompile<cr>', { desc = 'Compile Tex' })
      vim.keymap.set('n', '<leader>tS', '<cmd>VimtexStopAll<cr>', { desc = 'Stop all Tex compilations' })
    end,
  },

  -- Typst preview
  {
    'typst-preview.nvim',
    for_cat = 'general.always',
    ft = 'typst',
    after = function(plugin)
      require('typst-preview').setup {
        extra_args = { '--font-path=./' },
      }
    end,
  },

  {
    'opencode-nvim',
    for_cat = { cat = 'general.ai', default = false },
    keys = {
      -- opencode.nvim exposes a general, flexible API — customize it to your workflow!
      -- But here are some examples to get you started :)
      {
        '<leader>ct',
        function()
          require('opencode').toggle()
        end,
        desc = 'Toggle opencode',
      },
      {
        '<leader>ca',
        function()
          require('opencode').ask()
        end,
        desc = 'Ask opencode',
        mode = { 'n', 'v' },
      },
      {
        '<leader>cA',
        function()
          require('opencode').ask '@file '
        end,
        desc = 'Ask opencode about current file',
        mode = { 'n', 'v' },
      },
      {
        '<leader>cn',
        function()
          require('opencode').command '/new'
        end,
        desc = 'New session',
      },
      {
        '<leader>ce',
        function()
          require('opencode').prompt 'Explain @cursor and its context'
        end,
        desc = 'Explain code near cursor',
      },
      {
        '<leader>cr',
        function()
          require('opencode').prompt 'Review @file for correctness and readability'
        end,
        desc = 'Review file',
      },
      {
        '<leader>cf',
        function()
          require('opencode').prompt 'Fix these @diagnostics'
        end,
        desc = 'Fix errors',
      },
      {
        '<leader>co',
        function()
          require('opencode').prompt 'Optimize @selection for performance and readability'
        end,
        desc = 'Optimize selection',
        mode = 'v',
      },
      {
        '<leader>cd',
        function()
          require('opencode').prompt 'Add documentation comments for @selection'
        end,
        desc = 'Document selection',
        mode = 'v',
      },
      {
        '<leader>ct',
        function()
          require('opencode').prompt 'Add tests for @selection'
        end,
        desc = 'Test selection',
        mode = 'v',
      },
    },
    after = function()
      ---@type opencode.Config
      vim.g.opencode_opts = {
        auto_register_cmp_sources = { 'opencode', 'buffer' },
        auto_reload = false, -- Automatically reload buffers edited by opencode
        auto_focus = false, -- Focus the opencode window after prompting
        command = 'opencode', -- Command to launch opencode
        context = { -- Context to inject in prompts
          ['@file'] = require('opencode.context').file,
          ['@files'] = require('opencode.context').files,
          ['@cursor'] = require('opencode.context').cursor_position,
          ['@selection'] = require('opencode.context').visual_selection,
          ['@diagnostics'] = require('opencode.context').diagnostics,
          ['@quickfix'] = require('opencode.context').quickfix,
          ['@diff'] = require('opencode.context').git_diff,
        },
        win = {
          position = 'right',
          -- See https://github.com/folke/snacks.nvim/blob/main/docs/win.md for more window options
        },
        -- See https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md for more terminal options
      }
    end,
  },

  {
    'supermaven-nvim',
    for_cat = 'general.ai',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('supermaven-nvim').setup {
        disable_inline_completion = false,
        disable_keymaps = false,
      }
    end,
  },

  -- Codecompanion (AI)
  {
    'codecompanion.nvim',
    for_cat = 'general.ai',
    event = 'DeferredUIEnter',
    load = function(name)
      vim.cmd.packadd 'nvim-treesitter'
      vim.cmd.packadd 'plenary.nvim'
      vim.cmd.packadd 'nvim-cmp'
      vim.cmd.packadd 'which-key.nvim'
    end,
    after = function(plugin)
      local prompt_library = {
        ['Academic Rewrite'] = {
          strategy = 'inline',
          description = 'Write better academic papers for me',
          prompts = {
            {
              role = 'user',
              content = function(context)
                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                return [[
                I want you act as a proofreader and experienced academic writer.
                I will provide you texts and I would like you to review them, and rephrase them to provide a better version according to the folowing standards:

                - Correct any spelling, grammar, or punctuation errors.
                - Do not use any contractions like I'm or you're.
                - Just send me the revised text without anything else.

                Also beware to make your response follow these requirements:

                *   **Feel:** No language or vocabulary that would make the output feel like AI generated.
                *   **Sentence Length:** A mix of short and medium-length sentences.
                *   **Vocabulary:** As precise as possible.
                *   **Voice:** Use the active voice.
                *   **Content:** The idea should be clear and concise.
                *   **Flow:** The ideas should flow logically.
                *   **Latex:** Dot not change the custom LaTeX commands that may be used.

                The text is here

                ```
                ]] .. text .. [[
                ```
                ]]
              end,
            },
          },
          opts = {
            modes = { 'v' },
            short_name = 'rewrite',
            auto_submit = true,
            stop_context_insertion = true,
          },
        },
        ['Academic correct'] = {
          strategy = 'inline',
          description = 'Write better academic papers for me',
          prompts = {
            {
              role = 'user',
              content = function(context)
                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                return [[
                I want you act as a proofreader and experienced academic writer.
                I will provide you texts and I would like you to review them, and rephrase them as little as possible to provide a better version according to the folowing standards:

                - Correct any spelling, grammar, or punctuation errors.
                - Do not use any contractions like I'm or you're.
                - Just send me the revised text without anything else.

                Also beware to make your response follow these requirements:

                *   **Feel:** No language or vocabulary that would make the output feel like AI generated.
                *   **Sentence Length:** A mix of short and medium-length sentences.
                *   **Vocabulary:** As precise as possible.
                *   **Voice:** Use the active voice.
                *   **Content:** The idea should be clear and concise.
                *   **Flow:** The ideas should flow logically.
                *   **Latex:** Dot not change the custom LaTeX commands that may be used.

                Most importantly: you must change the orginal text the least possible.

                The text is here

                ```
                ]] .. text .. [[
                ```
                ]]
              end,
            },
          },
          opts = {
            modes = { 'v' },
            short_name = 'correct',
            auto_submit = true,
            stop_context_insertion = true,
          },
        },
      }

      local opts = {
        adapters = {
          http = {
            opts = { show_defaults = false },
            openrouter = function()
              return require('codecompanion.adapters').extend('openai_compatible', {
                env = {
                  url = 'https://openrouter.ai/api',
                  api_key = 'OPENROUTER_API_KEY',
                  chat_url = '/v1/chat/completions',
                },
                schema = {
                  model = {
                    default = 'google/gemini-3-flash-preview',
                  },
                },
              })
            end,
          },
        },
        strategies = {
          chat = { adapter = 'openrouter', model = 'anthropic/claude-4.5-sonnet' },
          inline = {
            adapter = 'openrouter',
            model = 'google/gemini-3-flash-preview',
            keymaps = {
              accept_change = {
                modes = { n = 'ga' },
              },
              reject_change = {
                modes = { n = 'gr' },
              },
            },
          },
        },
        display = {
          chat = {
            window = { position = 'right' },
          },
          diff = { provider = 'inline' },
        },
        prompt_library = prompt_library,
      }

      require('codecompanion').setup(opts)

      local wk = require 'which-key'
      wk.add {
        nowait = true,
        remap = false,
        mode = { 'n', 'v' },
        -- { '<leader>c', ':CodeCompanionChat toggle<CR>', desc = 'AI Chat' },
        -- { '<leader>A', ':CodeCompanionActions<CR>', desc = 'AI Actions' },
        { '<leader>W', ':CodeCompanion /rewrite<CR>', desc = 'AI rewrite' },
        { '<leader>C', ':CodeCompanion /correct<CR>', desc = 'AI correction' },
      }
    end,
  },

  -- Comment
  {
    'comment.nvim',
    for_cat = 'general.always',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('Comment').setup()
    end,
  },

  -- Nvim-surround
  {
    'nvim-surround',
    for_cat = 'general.always',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('nvim-surround').setup()
    end,
  },

  -- Indent-blankline
  {
    'indent-blankline.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('ibl').setup()
    end,
  },

  -- Vim-sleuth
  {
    'vim-sleuth',
    for_cat = 'general.always',
    event = 'DeferredUIEnter',
  },

  -- Trouble
  {
    'trouble.nvim',
    for_cat = 'general.always',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
    },
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('trouble').setup {}
    end,
  },

  -- Skkeleton (Japanese input)
  {
    'skkeleton',
    for_cat = 'general.extra',
    keys = {
      { '<C-j>', '<Plug>(skkeleton-enable)', mode = 'i', desc = 'Enable skkeleton' },
      { '<C-j>', '<Plug>(skkeleton-disable)', mode = 'i', desc = 'Disable skkeleton' },
      { '<C-j>', '<Plug>(skkeleton-toggle)', mode = 'c', desc = 'Toggle skkeleton' },
    },
    load = function(name)
      vim.cmd.packadd 'denops.vim'
      vim.cmd.packadd 'skkeleton_indicator.nvim'
    end,
    after = function(plugin)
      vim.fn['skkeleton#config'] {
        globalDictionaries = { '~/.skkeleton/SKK-JISYO.L' },
        eggLikeNewline = true,
        registerConvertResult = true,
        useSkkServer = true,
        serverAddr = '127.0.0.1',
        serverPort = 1178,
      }
    end,
  },

  -- -- Spellwarn
  -- {
  --   'spellwarn.nvim',
  --   for_cat = 'general.extra',
  --   event = { 'BufEnter' },
  --   after = function(plugin)
  --     require('spellwarn').setup {}
  --   end,
  -- },

  -- Colorizer
  {
    'colorizer',
    for_cat = 'general.extra',
    event = { 'BufReadPost', 'BufNewFile' },
    after = function(plugin)
      require('colorizer').setup {
        user_default_options = {
          names = false,
          RGB = true,
          RRGGBB = true,
          RRGGBBAA = true,
          AARRGGBB = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = 'background',
          tailwind = true,
          sass = { enable = false },
        },
      }
    end,
  },
}
