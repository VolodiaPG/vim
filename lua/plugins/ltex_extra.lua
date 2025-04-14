return {
  'barreiroleo/ltex_extra.nvim',
  ft = {
    'bib',
    'gitcommit',
    'mail',
    'markdown',
    'mdx',
    'org',
    'norg',
    'plaintex',
    'rst',
    'rnoweb',
    'latex',
    'tex',
    'text',
    'pandoc',
  },
  dependencies = 'neovim/nvim-lspconfig',
  opts = {
    -- ltex_extra options
    {
      load_langs = { 'en-US', 'fr-FR' },
      init_check = true,
    },
    -- ltex-ls options
    server_opts = {
      settings = {
        ltex = {
          language = 'fr-FR',
          diagnosticSeverity = 'hint',
          sentenceCacheSize = 2000,
          additionalRules = {
            enablePickyRules = true,
            motherTongue = 'fr-FR',
          },
          dictionary = {},
          disabledRules = {
            ['en-US'] = { 'WHITESPACE_RULE' },
          },
        },
      },
    },
  },
}
