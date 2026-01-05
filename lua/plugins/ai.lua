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
          modes = { n = 'ga' }, -- Remember this as DiffAccept
        },
        reject_change = {
          modes = { n = 'gr' }, -- Remember this as DiffReject
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

return {
  'olimorris/codecompanion.nvim',

  lazy = false,

  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-lua/plenary.nvim', branch = 'master' },
    'hrsh7th/nvim-cmp',
    'folke/which-key.nvim',
  },

  enabled = true,
  config = function()
    require('codecompanion').setup(opts)

    local wk = require 'which-key'
    wk.add {
      nowait = true,
      remap = false,
      mode = { 'n', 'v' },
      { '<leader>c', ':CodeCompanionChat toggle<CR>', desc = 'AI Chat' },
      { '<leader>A', ':CodeCompanionActions<CR>', desc = 'AI Actions' },
      { '<leader>W', ':CodeCompanion /rewrite<CR>', desc = 'AI rewrite' },
      { '<leader>C', ':CodeCompanion /correct<CR>', desc = 'AI correction' },
    }
  end,
}
