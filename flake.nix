{
  description = "My nVIM config";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
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
        in {
          formatter = nixpkgs.legacyPackages.${system}.alejandra;
          packages = {
            inherit nvim;
            default = nvim;
          };
        }
      );
}
