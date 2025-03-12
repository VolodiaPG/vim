-- Tmux navigation configuration

return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  config = function()
    -- No additional configuration needed as the plugin works out of the box
    -- The plugin automatically sets up the following keybindings:
    -- Ctrl-h: Left (Vim) or Left Pane (tmux)
    -- Ctrl-j: Down (Vim) or Down Pane (tmux)
    -- Ctrl-k: Up (Vim) or Up Pane (tmux)
    -- Ctrl-l: Right (Vim) or Right Pane (tmux)
    -- Ctrl-\: Previous split (Vim) or Previous Pane (tmux)
  end,
} 