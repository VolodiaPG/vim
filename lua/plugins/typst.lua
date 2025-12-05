return {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  -- version = '1.*',
  opts = {
    extra_args = { '--font-path=./' },
  }, -- lazy.nvim will implicitly calls `setup {}`
}
