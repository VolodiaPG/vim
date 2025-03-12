-- LaTeX support configuration

return {
  -- VimTeX for LaTeX support
  {
    "lervag/vimtex",
    lazy = false, -- Load immediately to ensure proper filetype detection
    config = function()
      -- Set viewer method to Skim for macOS
      vim.g.vimtex_view_method = 'skim'
      
      -- Configure Skim viewer options
      vim.g.vimtex_view_skim_sync = 1 -- Enable forward search after compilation
      vim.g.vimtex_view_skim_activate = 1 -- Activate Skim after forward search
      
      -- Configure compiler method
      vim.g.vimtex_compiler_method = 'latexmk'
      
      -- Configure compiler options to use LuaTeX
      vim.g.vimtex_compiler_latexmk = {
        build_dir = '',
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        hooks = {},
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
          '-pdflatex="lualatex -halt-on-error -interaction=nonstopmode --shell-escape"',
        },
      }
      
      -- Set quickfix mode
      vim.g.vimtex_quickfix_mode = 2
      
      -- -- Configure TOC settings
      -- vim.g.vimtex_toc_config = {
      --   name = 'TOC',
      --   layers = {'content', 'todo', 'include'},
      --   split_width = 25,
      --   todo_sorted = 0,
      --   show_help = 1,
      --   show_numbers = 1,
      -- }
      
      -- Set up colorscheme for LaTeX files
    --   vim.api.nvim_create_autocmd("FileType", {
    --     pattern = {"tex", "latex"},
    --     callback = function()
    --       -- Enable conceal
    --       vim.opt_local.conceallevel = 2
    --       vim.opt_local.concealcursor = "nc"
          
    --       -- Enable spell checking
    --       vim.opt_local.spell = true
    --       vim.opt_local.spelllang = "en_us"
          
    --       -- Set text width for automatic line breaks
    --       vim.opt_local.textwidth = 80
          
    --       -- Enable automatic indentation
    --       vim.opt_local.autoindent = true
    --       vim.opt_local.smartindent = true
          
    --       -- Set tab settings
    --       vim.opt_local.tabstop = 2
    --       vim.opt_local.shiftwidth = 2
    --       vim.opt_local.expandtab = true
          
    --       -- Enable folding
    --       vim.opt_local.foldmethod = "expr"
    --       vim.opt_local.foldexpr = "vimtex#fold#level(v:lnum)"
    --       vim.opt_local.foldtext = "vimtex#fold#text()"
    --       vim.opt_local.foldenable = false  -- Don't fold by default
    --     end,
      -- })
    end,
  },
  
  -- Snippets for LaTeX
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  
  -- LSP configuration for LaTeX
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = "latexmk",
                args = { '-pdflatex="lualatex -halt-on-error -interaction=nonstopmode --shell-escape"', "-interaction=nonstopmode", "-synctex=1", "%f" },
                onSave = true,
                forwardSearchAfter = false,
              },
              forwardSearch = {
                executable = "displayline",
                args = { "%l", "%p", "%f" },
              },
              chktex = {
                onEdit = false,
                onOpenAndSave = true,
              },
              diagnosticsDelay = 300,
              latexFormatter = "latexindent",
              latexindent = {
                ["local"] = nil,
                modifyLineBreaks = false,
              },
            },
          },
        },
      },
    },
  },
} 