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
            colorschemes.catppuccin = {
              enable = true;
              flavour = "mocha";
              transparentBackground = true;
            };
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
              refactoring.enable = true;
              harpoon = {
                enable = true;
                enableTelescope = true;
                keymaps = {
                  addFile = "<leader>s";
                  toggleQuickMenu = "<leader>d";
                  navFile = {
                    "1" = "&";
                    "2" = "é";
                    "3" = "\"";
                    "4" = "'";
                    "5" = "(";
                    "6" = "§";
                    "7" = "è";
                    "8" = "!";
                    "9" = "ç";
                  };
               };
             };
              lsp = {
                enable = true;
                servers = {
                  nixd.enable = true;
                  pyright.enable = true;
                  gopls.enable = true;
                  rust-analyzer = {
                    enable = true;
                    installRustc = false;
                    installCargo = false;
                  };
                  jsonls.enable = true;
                  yamlls.enable = true;
                };
              };
              nvim-cmp = {
                enable = true;
                snippet.expand = "luasnip";
                sources = [
                  {name = "nvim_lsp";}
                  {name = "path";}
                  {name = "buffer";}
                ];
                mapping = {
                  "<CR>" = "cmp.mapping.confirm({select = true})";
                };
              };
              luasnip.enable = true;
              neogit.enable = true;
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
              lspsaga.enable = true;
              lsp-lines.enable = true;
              lsp-format.enable = true;
            };
            globals.mapleader = " ";
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
