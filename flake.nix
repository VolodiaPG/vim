{
  description = "My nVIM config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Get version 0.10 of neovim
    nvim-master = {
      url = "github:neovim/neovim";
      flake = false;
    };
    plugin-inlay-hints = {
      url = "github:MysticalDevil/inlay-hints.nvim";
      flake = false;
    };
    plugin-staline = {
      url = "github:tamton-aquib/staline.nvim";
      flake = false;
    };
  };

  # Enable caching
  nixConfig = {
    extra-substituters = ["https://vim.cachix.org"];
    extra-trusted-public-keys = ["vim.cachix.org-1:csyY4pnUgltVSD3alxSV6zZG/lRD7FQBfl4K4RNBgXA="];
  };

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          overlay = final: prev: {
            neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
              version = "0.10";
              src = nvim-master;
            });
          };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [overlay];
          };
          configMod = {pkgs, ...}: {
            imports = [
              ./sets.nix
              ./keymaps.nix
              ./telescope/telescope.nix
              #./utils/project.nix
              ./utils/whichkey.nix
              ./utils/harpoon.nix
              ./ui/notify.nix
              ./ui/alpha.nix
              ./ui/indent-blankline.nix
              ./ui/noice.nix
              ./ui/nui.nix
              #./statusline/lualine.nix
              ./statusline/statline.nix
              ./colorschemes/catppuccin.nix
              ./git/lazygit.nix
              ./git/gitsigns.nix
              ./languages/nvim-lint.nix
              ./languages/treesitter/treesitter-context.nix
              ./languages/treesitter/treesitter-textobjects.nix
              ./languages/treesitter/treesitter.nix
              ./lsp/conform.nix
              ./lsp/fidget.nix
              ./lsp/lsp.nix
              ./lsp/lspsaga.nix
              ./lsp/trouble.nix
              ./completions/cmp.nix
              ./completions/lspkind.nix
              ./snippets/luasnip.nix
            ];
            extraPackages = with pkgs; [
              ripgrep
              #nixd
              lazygit
              statix
              alejandra
              #codespell
            ];
            plugins.trouble.enable = true;
            plugins.treesitter.enable = true;
            extraPlugins = with pkgs.vimPlugins; [
              vim-just
            ];
          };
          nixvim' = nixvim.legacyPackages."${system}";
          nvim = colorFlavour:
            nixvim'.makeNixvimWithModule {
              inherit pkgs;
              module = configMod;
              extraSpecialArgs = {
                inherit pkgs colorFlavour inputs;
              };
            };
          tmuxWrapper = pkgs.writeShellScript "tmuxWrapper" ''
            ${pkgs.tmux}/bin/tmux -f ${./tmux.conf} "$@"
          '';
        in {
          formatter = nixpkgs.legacyPackages.${system}.alejandra;
          checks = {
            default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
              nvim = self.outputs.packages.${system}.default;
              name = "Navet"; # Inspiration taken from Neve
            };
          };
          packages = {
            default = nvim "mocha";
            light = nvim "latte";
          };
          apps = {
            tmux = {
              type = "app";
              program = "${tmuxWrapper}";
            };
          };
        }
      );
}
