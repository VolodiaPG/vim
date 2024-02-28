{
  description = "A very basic flake";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.neveSource.url = "github:redyf/neve";
  inputs.neveSource.flake = false;

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (nixpkgs) lib;
          configMod = {
            imports = whitelist;
            config = {
              extraPackages = with pkgs; [
                ripgrep
                statix
              ];
              options = {
                number = true;
                relativenumber = true;
                tabstop = lib.mkForce 4;
                shiftwidth = lib.mkForce 4;
                softtabstop = lib.mkForce 4;
                showtabline = lib.mkForce 0;
                expandtab = true;
                smartindent = true;
                signcolumn = "yes";
                #laststatus = lib.mkForce 0;
                guicursor = lib.mkForce [
                  "n-v-c:block" # Normal, visual, command-line: block cursor
                  "i-ci-ve:ver100" # Insert, command-line insert, visual-exclude: vertical bar cursor with block cursor, use "ver25" for 25% width
                  "r-cr:hor20" # Replace, command-line replace: horizontal bar cursor with 20% height
                  "o:hor50" # Operator-pending: horizontal bar cursor with 50% height
                  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor" # All modes: blinking settings
                  "sm:block-blinkwait175-blinkoff150-blinkon175" # Showmatch: block cursor with specific blinking settings
                ];
              };
              colorschemes.catppuccin = {
                enable = true;
                flavour = "mocha";
                transparentBackground = true;
              };
              plugins.nix.enable = true;
              #plugins.nix-develop.enable = true;
              plugins.trouble.enable = true;
              plugins.treesitter-refactor = {
                enable = true;
                highlightCurrentScope.enable = false;
                highlightCurrentScope.disable = [
                  "nix"
                ];
                highlightDefinitions.enable = true;
                navigation.enable = true;
                smartRename.enable = true;
              };
              plugins = {
                lsp = {
                  enable = true;
                  servers = {
                    bashls.enable = true;
                    nixd.enable = true;
                    pyright.enable = true;
                    gopls = {
                      enable = true;
#                      extraOptions.hints = {
#                        assignVariableTypes = true;
#                        compositeLiteralFields = true;
#                        compositeLiteralTypes = true;
#                        constantValues = true;
#                        functionTypeParameters = true;
#                        parameterNames = true;
#                        rangeVariableTypes = true;
#                      };
                    };
                    rust-analyzer = {
                      enable = true;
                      installRustc = lib.mkForce false;
                      installCargo = lib.mkForce false;
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
                rust-tools = {
                  enable = true;
                  inlayHints = {
                    auto = true;
                    onlyCurrentLine = false;
                    showParameterHints = true;
                    parameterHintsPrefix = "<- ";
                    otherHintsPrefix = "=> ";
                    maxLenAlign = false;
                    maxLenAlignPadding = 1;
                    rightAlign = false;
                    rightAlignPadding = 7;
                    highlight = "Comment";
                  };
                };
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
                #lsp-format.enable = true;
                lint.lintersByFt = lib.mkForce {
                  python = ["ruff"];
                };
              };
              extraPlugins = with pkgs.vimPlugins; [
                vim-just
                go-nvim
              ];
              extraConfigLua = ''
                local lspconfig = require('lspconfig')
                local capabilities = require('cmp_nvim_lsp').default_capabilities()
                lspconfig.r_language_server.setup({
                  on_attach = on_attach_custom,
                  -- Debounce "textDocument/didChange" notifications because they are slowly
                  -- processed (seen when going through completion list with `<C-N>`)
                  flags = { debounce_text_changes = 150 },
                  capabilities = capabilities,
                })
                require("lspconfig").gopls.setup({
                  settings = {
                    hints = {
                      rangeVariableTypes = true,
                      parameterNames = true,
                      constantValues = true,
                      assignVariableTypes = true,
                      compositeLiteralFields = true,
                      compositeLiteralTypes = true,
                      functionTypeParameters = true,
                    },
                  }
                })
              '';
            };
          };
          nixvim' = nixvim.legacyPackages."${system}";
          whitelist' = [
            "sets.nix"
            "keymaps.nix"
            "completion/cmp.nix"
            "completion/copilot.nix"
            "completion/lspkind.nix"
            #"dap/dap.nix"
            "git/gitsigns.nix"
            "git/diffview.nix"
            "languages/nvim-lint.nix"
            "languages/treesitter/treesitter.nix"
            "languages/treesitter/treesitter-context.nix"
            "languages/treesitter/treesitter-textobjects.nix"
            "lsp/conform.nix"
            "lsp/fidget.nix"
            "statusline/lualine.nix"
            "statusline/staline.nix"
            "ui/alpha.nix"
            "ui/dressing-nvim.nix"
            "ui/indent-blankline.nix"
            "ui/noice.nix"
            "ui/nvim-notify.nix"
            "ui/nui.nix"
            "utils/better-escape.nix"
            "utils/flash.nix"
            #"utils/hardtime.nix"
            "utils/illuminate.nix"
            "utils/markdown-preview.nix"
            "utils/mini.nix"
            "utils/neodev.nix"
            #"utils/neotest.nix"
            #"utils/nvim-autopairs.nix"
            #"utils/nvim-colorizer.nix"
            #"utils/nvim-surround.nix"
            #"utils/oil.nix"
            #"utils/persistence.nix"
            "utils/plenary.nix"
            "utils/project-nvim.nix"
            #"utils/tmux-navigator.nix"
            #"utils/todo-comments.nix"
            "utils/undotree.nix"
            #"utils/ultimate-autopair.nix"
            #"utils/vim-be-good.nix"
            #"utils/todo-comments.nix"
            "utils/wilder.nix"
            "utils/whichkey.nix"
            "telescope/telescope.nix"
            "snippets/luasnip.nix"
          ];
          whitelist = lib.lists.forEach whitelist' (x: "${neveSource}/config/${x}");
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = configMod;
            extraSpecialArgs = {
              inherit self;
            };
          };
        in {
          formatter = nixpkgs.legacyPackages.${system}.alejandra;
          checks = {
            default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "Neve";
            };
          };
          packages = {
            inherit nvim;
            default = nvim;
          };
        }
      );
}
