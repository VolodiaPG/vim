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
          coc = import ./coc.nix;
          cocSettings' = builtins.toFile "coc-settings.json" (builtins.toJSON (coc {}));
          cocSettings = pkgs.stdenv.mkDerivation {
            name = "coc-settings";
            buildInputs = [pkgs.coreutils];
            src = cocSettings';
            dontUnpack = true;

            installPhase = ''
              mkdir -p $out
              cp $src $out/coc-settings.json
            '';
          };
          config = {
            extraPackages = with pkgs; [
              ripgrep
              nil
            ];
            options = {
              number = true;
              relativenumber = true;
              tabstop = 4;
              shiftwidth = 4;
              softtabstop = 4;
              expandtab = true;
              smartindent = true;
              wrap = false;
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
              gitsigns.enable = true;
            };
            globals.mapleader = " ";
            globals.coc_config_home = "${cocSettings}";
            extraPlugins = with pkgs.vimPlugins; [
              vim-just
              coc-highlight
              coc-pyright
              coc-rust-analyzer
              coc-go
              coc-spell-checker
              coc-nvim
              coc-sh
              coc-yaml
              coc-toml
              coc-r-lsp
              coc-diagnostic
              coc-nvim
            ];
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
