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
              updatetime = 300;
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
            extraConfigVim = ''
                          " Use tab for trigger completion with characters ahead and navigate
              " NOTE: There's always complete item selected by default, you may want to enable
              " no select by `"suggest.noselect": true` in your configuration file
              " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
              " other plugin before putting this into your config
              inoremap <silent><expr> <TAB>
                    \ coc#pum#visible() ? coc#pum#next(1) :
                    \ CheckBackspace() ? "\<Tab>" :
                    \ coc#refresh()
              inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

              " Make <CR> to accept selected completion item or notify coc.nvim to format
              " <C-g>u breaks current undo, please make your own choice
              inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

              function! CheckBackspace() abort
                let col = col('.') - 1
                return !col || getline('.')[col - 1]  =~# '\s'
              endfunction

              " Use <c-space> to trigger completion
              if has('nvim')
                inoremap <silent><expr> <c-space> coc#refresh()
              else
                inoremap <silent><expr> <c-@> coc#refresh()
              endif

              " Use `[g` and `]g` to navigate diagnostics
              " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
              nmap <silent> [g <Plug>(coc-diagnostic-prev)
              nmap <silent> ]g <Plug>(coc-diagnostic-next)

              " GoTo code navigation
              nmap <silent> gd <Plug>(coc-definition)
              nmap <silent> gy <Plug>(coc-type-definition)
              nmap <silent> gi <Plug>(coc-implementation)
              nmap <silent> gr <Plug>(coc-references)

              " Use K to show documentation in preview window
              nnoremap <silent> K :call ShowDocumentation()<CR>

              function! ShowDocumentation()
                if CocAction('hasProvider', 'hover')
                  call CocActionAsync('doHover')
                else
                  call feedkeys('K', 'in')
                endif
              endfunction

              " Highlight the symbol and its references when holding the cursor
              autocmd CursorHold * silent call CocActionAsync('highlight')

              " Symbol renaming
              nmap <leader>rn <Plug>(coc-rename)

              " Formatting selected code
              xmap <leader>f  <Plug>(coc-format-selected)
              nmap <leader>f  <Plug>(coc-format-selected)

              augroup mygroup
                autocmd!
                " Setup formatexpr specified filetype(s)
                autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
                " Update signature help on jump placeholder
                autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
              augroup end

              " Applying code actions to the selected code block
              " Example: `<leader>aap` for current paragraph
              xmap <leader>a  <Plug>(coc-codeaction-selected)
              nmap <leader>a  <Plug>(coc-codeaction-selected)

              " Remap keys for applying code actions at the cursor position
              nmap <leader>ac  <Plug>(coc-codeaction-cursor)
              " Remap keys for apply code actions affect whole buffer
              nmap <leader>as  <Plug>(coc-codeaction-source)
              " Apply the most preferred quickfix action to fix diagnostic on the current line
              nmap <leader>qf  <Plug>(coc-fix-current)

              " Remap keys for applying refactor code actions
              nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
              xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
              nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

              " Run the Code Lens action on the current line
              nmap <leader>cl  <Plug>(coc-codelens-action)

              " Map function and class text objects
              " NOTE: Requires 'textDocument.documentSymbol' support from the language server
              xmap if <Plug>(coc-funcobj-i)
              omap if <Plug>(coc-funcobj-i)
              xmap af <Plug>(coc-funcobj-a)
              omap af <Plug>(coc-funcobj-a)
              xmap ic <Plug>(coc-classobj-i)
              omap ic <Plug>(coc-classobj-i)
              xmap ac <Plug>(coc-classobj-a)
              omap ac <Plug>(coc-classobj-a)

              " Remap <C-f> and <C-b> to scroll float windows/popups
              if has('nvim-0.4.0') || has('patch-8.2.0750')
                nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
                nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
                inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
                inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
                vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
                vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
              endif

              " Use CTRL-S for selections ranges
              " Requires 'textDocument/selectionRange' support of language server
              nmap <silent> <C-s> <Plug>(coc-range-select)
              xmap <silent> <C-s> <Plug>(coc-range-select)

              " Add `:Format` command to format current buffer
              command! -nargs=0 Format :call CocActionAsync('format')

              " Add `:Fold` command to fold current buffer
              command! -nargs=? Fold :call     CocAction('fold', <f-args>)

              " Add `:OR` command for organize imports of the current buffer
              command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

              " Add (Neo)Vim's native statusline support
              " NOTE: Please see `:h coc-status` for integrations with external plugins that
              " provide custom statusline: lightline.vim, vim-airline

              " Mappings for CoCList
              " Show all diagnostics
              nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
              " Manage extensions
              nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
              " Show commands
              nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
              " Find symbol of current document
              nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
              " Search workspace symbols
              nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
              " Do default action for next item
              nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
              " Do default action for previous item
              nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
              " Resume latest coc list
              nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
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
