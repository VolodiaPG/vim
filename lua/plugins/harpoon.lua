-- Harpoon configuration

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local harpoon = require 'harpoon'

    -- Setup harpoon
    harpoon:setup {}

    -- Setup telescope integration
    require('telescope').load_extension 'harpoon'

    -- Set up keymaps
    vim.keymap.set('n', '<leader>hs', function()
      harpoon:list():append()
    end, { desc = 'Harpoon add file' })

    vim.keymap.set('n', '<leader>hd', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon quick menu' })

    -- Navigation keymaps
    vim.keymap.set('n', '&', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon file 1' })

    vim.keymap.set('n', '[', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon file 2' })

    vim.keymap.set('n', '{', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon file 3' })

    vim.keymap.set('n', '(', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon file 4' })

    vim.keymap.set('n', "'", function()
      harpoon:list():select(5)
    end, { desc = 'Harpoon file 5' })

    vim.keymap.set('n', '"', function()
      harpoon:list():select(6)
    end, { desc = 'Harpoon file 6' })

    vim.keymap.set('n', ')', function()
      harpoon:list():select(7)
    end, { desc = 'Harpoon file 7' })

    vim.keymap.set('n', '}', function()
      harpoon:list():select(8)
    end, { desc = 'Harpoon file 8' })

    vim.keymap.set('n', ']', function()
      harpoon:list():select(9)
    end, { desc = 'Harpoon file 9' })

    -- Additional navigation keymaps
    vim.keymap.set('n', '<leader>hp', function()
      harpoon:list():prev()
    end, { desc = 'Harpoon prev file' })

    vim.keymap.set('n', '<leader>hn', function()
      harpoon:list():next()
    end, { desc = 'Harpoon next file' })
  end,
}

