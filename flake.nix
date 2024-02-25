{
  description = "A very basic flake";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          config = {
            colorschemes.one.enable = true;
            plugins.nix.enable = true;
            plugins.nix-develop.enable = true;
            plugins.trouble.enable = true;
            plugins.treesitter.enable = true;
            plugins.telescope.enable = true;
            plugins.telescope.keymaps = {
              "<leader>ff" = "find_files";
              "<leader>fg" = "live_grep";
              "<leader>fb" = "buffers";
              "<leader>fh" = "help_tags";
            };
            plugins = {
              lsp = {
                enable = true;
                servers = {
                  nil_ls.enable = true;
                  pyright.enable = true;
                  gopls.enable = true;
                  rust-analyzer.enable = true;
                  jsonls.enable = true;
                };
              };
              lspkind = {
                enable = true;
                cmp = {
                  enable = true;
                  menu = {
                    nvim_lsp = "[LSP]";
                    nvim_lua = "[api]";
                    path = "[path]";
                    luasnip = "[snip]";
                    buffer = "[buffer]";
                    orgmode = "[orgmode]";
                    neorg = "[neorg]";
                  };
                };
              };
              lsp-lines.enable = true;
            };
          };
          nixvim' = nixvim.legacyPackages."${system}";
          nvim = nixvim'.makeNixvim config;
        in {
          formatter = nixpkgs.legacyPackages.${system}.alejandra;
          packages = {
            inherit nvim;
            default = nvim;
          };
        }
      );
}
