{
  description = "My nVIM config";
  inputs = {
    nixpkgs.follows = "nixvim/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        devshell.follows = "";
        flake-compat.follows = "";
        git-hooks.follows = "";
        home-manager.follows = "";
        nix-darwin.follows = "";
        treefmt-nix.follows = "";
      };
    };
    plugin-inlay-hints = {
      url = "github:MysticalDevil/inlay-hints.nvim";
      flake = false;
    };
    plugin-staline = {
      url = "github:tamton-aquib/staline.nvim";
      flake = false;
    };
    plugin-ltex-extra = {
      url = "github:barreiroleo/ltex_extra.nvim";
      flake = false;
    };
  };

  # Enable caching
  nixConfig = {
    extra-substituters = ["https://vim.cachix.org"];
    extra-trusted-public-keys = ["vim.cachix.org-1:csyY4pnUgltVSD3alxSV6zZG/lRD7FQBfl4K4RNBgXA="];
  };

  outputs = inputs:
    with inputs; (flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = import nixpkgs {
            inherit system;
          };
          configMod = {pkgs, ...}: {
            imports = [
              ./sets.nix
              ./keymaps.nix
              ./telescope/telescope.nix
              #./utils/project.nix
              ./utils/whichkey.nix
              ./utils/harpoon.nix
              ./utils/better-escape.nix
              ./utils/inc-rename.nix
              ./ui/notify.nix
              ./ui/alpha.nix
              ./ui/indent-blankline.nix
              ./ui/noice.nix
              ./ui/nui.nix
              ./ui/tmux.nix
              ./ui/rainbow-delimiters.nix
              ./ui/icons.nix
              #./statusline/lualine.nix
              ./statusline/statline.nix
              ./colorschemes/catppuccin.nix
              ./git/lazygit.nix
              ./git/gitsigns.nix
              ./languages/nvim-lint.nix
              ./languages/treesitter/treesitter.nix
              ./languages/treesitter/treesitter-context.nix
              ./languages/treesitter/treesitter-textobjects.nix
              ./lsp/conform.nix
              ./lsp/fidget.nix
              ./lsp/lsp.nix
              ./lsp/lspsaga.nix
              ./lsp/trouble.nix
              ./lsp/efm.nix
              ./completions/cmp.nix
              ./completions/lspkind.nix
              ./snippets/luasnip.nix
            ];
            extraPackages = with pkgs; [
              ripgrep
              nixd
              lazygit
              statix
              alejandra
              typos
              shellcheck
              shellharden
              statix
              tmux
            ];
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
          tmuxConf = pkgs.substituteAll {
            src = ./tmux.conf;
            catppuccin = "${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux";
            resurrect = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux";
            continuum = "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux";
          };
          tmux = pkgs.tmux.overrideAttrs (oldAttrs: {
            buildInputs = (oldAttrs.buildInputs or []) ++ [pkgs.makeWrapper];

            postInstall =
              (oldAttrs.postInstall or "")
              + ''
                mkdir $out/libexec

                mv $out/bin/tmux $out/libexec/tmux-unwrapped

                makeWrapper $out/libexec/tmux-unwrapped $out/bin/tmux \
                  --add-flags "-f ${tmuxConf}"
              '';
          });
        in {
          formatter = nixpkgs.legacyPackages.${system}.alejandra;
          checks = {
            default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
              nvim = self.outputs.packages.${system}.default;
              name = "Navet"; # Inspiration taken from Neve
            };
          };
          packages = {
            default = nvim "latte";
            dark = nvim "mocha";
            nvim = nvim "mocha";
            inherit tmux tmuxConf;
          };
          apps = {
            tmux = {
              type = "app";
              program = "${tmux}/bin/tmux";
            };
            nvim = {
              type = "app";
              program = "${nvim "mocha"}/bin/nvim";
            };
          };
        }
      )
      // {
        overlay = final: prev: {
          inherit (self.outputs.packages.${prev.system}) nvim tmux;
        };
      });
}
