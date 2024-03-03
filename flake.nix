{
  description = "My nVIM config";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/master";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.coc = {
    url = "github:neoclide/coc.nvim/release";
    flake = false;
  };

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          overlay = final: prev: {
            coc-nvim = prev.buildNpmPackage rec {
              name = "coc.nvim-master";
              version = "1.0";
              src = inputs.coc;
              npmDepsHash = "sha256-auoNekzZIRSy3fRVLs6mHeR0qhUAHWSXu6wbE9QOWrQ=";
              buildInputs = [pkgs.nodePackages_latest.nodejs];
               postInstall = ''
                cp -r $src/plugin $out/lib/node_modules/${name}
              '';
            };
            toto = pkgs.stdenv.mkDerivation{
              name = "toto";
              src = coc;
              installPhase = ''
              ls -a $src/
                cp -r $src/.release $out
              '';
           };
            vimPlugins = prev.vimPlugins // {
              coc-nvim = prev.vimPlugins.coc-nvim.overrideAttrs (old:{
                src= coc;
              });
            };
          };
          pkgs = import nixpkgs {
            inherit system;
            #overlays = [overlay];
          };
          configMod = {pkgs, ...}: {
            imports = [
              ./sets.nix
              ./keymaps.nix
              ./ui/alpha.nix
              ./telescope/telescope.nix
              ./utils/project.nix
              ./utils/whichkey.nix
              ./utils/harpoon.nix
              ./ui/notify.nix
              ./ui/indent-blankline.nix
              ./ui/noice.nix
              ./statusline/lualine.nix
              ./statusline/statline.nix
              ./colorschemes/catppuccin.nix
              ./coc/coc.nix
              ./git/lazygit.nix
              ./git/gitsigns.nix
            ];
            extraPackages = with pkgs; [
              ripgrep
              nixd
              lazygit
            ];
            plugins.trouble.enable = true;
            plugins.treesitter.enable = true;
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
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = configMod;
            extraSpecialArgs = {
              inherit pkgs;
            };
          };
          tmuxWrapper = pkgs.writeShellScript "tmuxWrapper" ''
            ${pkgs.tmux}/bin/tmux -f ${./tmux.conf} "$@"
          '';
        in {
          formatter = nixpkgs.legacyPackages.${system}.alejandra;
          checks = {
            default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "Navet"; # Inspiration taken from Neve
            };
          };
          packages = {
            inherit nvim;
            default = nvim;
            toto = pkgs.coc-nvim;
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
