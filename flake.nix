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
            config = {
              extraPackages = with pkgs; [
                ripgrep
              ];
              options = {
                number = true;
                relativenumber = true;
                tabstop = lib.mkForce 4;
                shiftwidth = lib.mkForce 4;
                softtabstop = lib.mkForce 4;
                expandtab = true;
                smartindent = true;
                signcolumn = "yes";
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
              #plugins.telescope.keymaps = {
              #  "<leader>ff" = "find_files";
              #  "<leader>fg" = "live_grep";
              #  "<leader>fb" = "buffers";
              #  "<leader>fh" = "help_tags";
              #};
              plugins = {
                refactoring.enable = true;
                harpoon = lib.mkForce {
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
                nvim-cmp = {
                  enable = true;
                  snippet.expand = "luasnip";
                  sources = [
                    {name = "nvim_lsp";}
                    {name = "path";}
                    {name = "buffer";}
                  ];
                  mapping = {
                    #  "<CR>" = "cmp.mapping.confirm({select = true})";
                    #"<Tab>" = ''cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"})'';
                    #"<S-Tab>" = ''cmp.mapping(cmp.mapping.select_prev_item(), {"i", "s"})'';
                  };
                };
                luasnip.enable = true;
                gitsigns.enable = true;
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
                #lsp-format.enable = true;
              };
              globals.mapleader = " ";
              extraPlugins = with pkgs.vimPlugins; [
                vim-just
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
              '';
            };
          };
          nixvim' = nixvim.legacyPackages."${system}";
          whitelist' = [
            "sets.nix"
            "keymaps.nix"
            "bufferlines/bufferline.nix"
            "completion/cmp.nix"
            "completion/lspkind.nix"
            "dap/dap.nix"
            "git/gitsigns.nix"
            "git/diffview.nix"
            "languages/nvim-lint.nix"
            "languages/treesitter/treesitter.nix"
            "languages/treesitter/treesitter-context.nix"
            "languages/treesitter/treesitter-textobjects.nix"
            "lsp/conform.nix"
            "lsp/fidget.nix"
            "ui/alpha.nix"
            "ui/dressing-nvim.nix"
            "ui/indent-blankline.nix"
            "ui/noice.nix"
            "ui/nvim-notify.nix"
            "ui/nui.nix"
            "utils/harpoon.nix"
            "utils/persistence.nix"
            "utils/undotree.nix"
            "utils/vim-be-good.nix"
          ];
          whitelist = lib.lists.forEach whitelist' (x: import "${neveSource}/config/${x}");
          neveConfig = {imports = whitelist;};
          config' = nixpkgs.lib.foldl nixpkgs.lib.recursiveUpdate {} [neveConfig configMod];
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = config';
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
