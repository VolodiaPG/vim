-- LaTeX support configuration

return {
  -- VimTeX for LaTeX support
  {
    'lervag/vimtex',
    lazy = false, -- Load immediately to ensure proper filetype detection
    config = function()
      local os_name = vim.loop.os_uname().sysname
      if os_name == 'Linux' then
        -- vim.g.vimtex_view_method = 'mupdf'
        vim.g.vimtex_view_general_viewer = 'qpdfview'
        -- vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
      else
        -- Set viewer method to Skim for macOS
        vim.g.vimtex_view_method = 'skim'
        -- Configure Skim viewer options
        vim.g.vimtex_view_skim_sync = 1 -- Enable forward search after compilation
        vim.g.vimtex_view_skim_activate = 1 -- Activate Skim after forward search
      end

      -- Configure compiler method
      vim.g.vimtex_compiler_method = 'latexmk'
      -- vim.g.vimtex_latexmk_enabled = true

      -- -- Configure compiler options to use LuaTeX
      -- vim.g.vimtex_compiler_latexmk = {
      --   build_dir = '',
      --   callback = 1,
      --   continuous = 1,
      --   executable = 'latexmk',
      --   hooks = {},
      --   options = {
      --     '-verbose',
      --     '-file-line-error',
      --     '-synctex=1',
      --     '-interaction=nonstopmode',
      --     '-pdflatex="lualatex --halt-on-error -interaction=nonstopmode --shell-escape"',
      --   },
      -- }

      -- Set quickfix mode
      vim.g.vimtex_quickfix_mode = 2
    end,
  },

  -- Snippets for LaTeX
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  -- LSP configuration for LaTeX
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = 'latexmk',
                args = { '-pdflatex="lualatex -halt-on-error -interaction=nonstopmode --shell-escape"', '-interaction=nonstopmode', '-synctex=1', '%f' },
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
              latexindent = {
                ['local'] = nil,
                modifyLineBreaks = false,
              },
            },
          },
        },
      },
    },
  },
}
