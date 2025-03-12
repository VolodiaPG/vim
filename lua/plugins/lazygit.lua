-- LazyGit plugin configuration

return {
  "kdheepak/lazygit.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    -- Load the telescope extension
    require("telescope").load_extension("lazygit")
    
    -- Set up keymaps
    vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", {
      desc = "LazyGit (root dir)",
    })
    
    vim.keymap.set("n", "<leader>gG", function()
      vim.cmd("Telescope lazygit")
    end, {
      desc = "LazyGit repositories",
    })
  end,
} 