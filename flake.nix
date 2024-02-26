{
  description = "A very basic flake";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
          config = {
            extraPackages = with pkgs;[
              ripgrep
            ];
            options = {
              number = true;
              relativenumber= true;
            };
            colorschemes.catppuccin = {
              enable = true;
              flavour = "mocha";
              transparentBackground = true;
            };
            plugins.nix.enable = true;
            plugins.nix-develop.enable = true;
            plugins.trouble.enable = true;
            plugins.treesitter.enable = true;
            plugins.cmp-treesitter.enable = true;
            plugins.treesitter-refactor = {
              enable = true;
              highlightCurrentScope.enable = true;
              highlightCurrentScope.disable = [
                "nix"
              ];
              highlightDefinitions.enable = true;
              navigation.enable = true;
              smartRename.enable = true;
            };
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
                  bashls.enable = true;
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
                #lspBuf = {
                #  "gd" = "definition";
                #  "gD" = "references";
                #  "gt" = "type_definition";
                #  "gi" = "implementation";
                #  "K" = "hover";
                #};
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
              lspsaga = {
                enable = true;
                lightbulb.sign = false;
              };
              lsp-lines.enable = true;
              lsp-format.enable = true;
            };
            globals.mapleader = " ";
            extraPlugins = with pkgs.vimPlugins;[
              vim-just
              virtual-types-nvim
            ];
            extraConfigLua= ''
              local lspconfig = require('lspconfig')
              local capabilities = require('cmp_nvim_lsp').default_capabilities()
              lspconfig.r_language_server.setup({
                on_attach = on_attach_custom,
                -- Debounce "textDocument/didChange" notifications because they are slowly
                -- processed (seen when going through completion list with `<C-N>`)
                flags = { debounce_text_changes = 150 },
                capabilities = capabilities,
              })
            '';
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
