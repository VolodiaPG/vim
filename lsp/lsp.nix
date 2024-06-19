{
  pkgs,
  inputs,
  ...
}: let
  rootDir = ''
    require("lspconfig.util").root_pattern(".envrc", "subflake.nix", "flake.nix", ".git")
  '';
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "inlay-hints.nvim";
      version = "v0.1-2023-10-18";
      src = inputs.plugin-inlay-hints;
    })
    (pkgs.vimUtils.buildVimPlugin {
      pname = "ltex-extra.nvim";
      version = "v0.1-2023-10-18";
      src = inputs.plugin-ltex-extra;
    })
  ];
  plugins = {
    lsp-format = {
      enable = false; # Enable it if you want lsp-format integration for none-ls
      extraOptions = {
        timeoutMs = 60000;
      };
    };
    lsp = {
      enable = true;
      capabilities = "offsetEncoding =  'utf-16'";
      servers = {
        lua-ls = {
          enable = true;
          extraOptions = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace";
                };
                telemetry = {
                  enabled = false;
                };
                hint = {enable = true;};
              };
            };
          };
        };
        # not working because of CVE
        #nixd = {
        #  enable = true;
        #  inherit rootDir;
        #};
        pyright = {
          enable = true;
          extraOptions.settings.python.inlayHints = true;
          onAttach.function = ''
            require("inlay-hints").on_attach(client, bufnr)
          '';
          inherit rootDir;
        };
        ruff-lsp = {enable = true;};
        elixirls = {enable = true;};
        gopls = {
          enable = true;
          onAttach.function = ''
            require("inlay-hints").on_attach(client, bufnr)
          '';
          inherit rootDir;
          extraOptions = {
            settings = {
              gopls = {
                hints = {
                  assignVariableTypes = true;
                  compositeLiteralFields = true;
                  compositeLiteralTypes = true;
                  constantValues = true;
                  functionTypeParameters = true;
                  parameterNames = true;
                  rangeVariableTypes = true;
                };
              };
            };
          };
        };
        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          inherit rootDir;
          extraOptions.settings.rust-analyzer = {
            inlayHints = {
              bindingModeHints = {
                enable = false;
              };
              chainingHints = {
                enable = true;
              };
              closingBraceHints = {
                enable = true;
                minLines = 25;
              };
              closureReturnTypeHints = {
                enable = "never";
              };
              lifetimeElisionHints = {
                enable = "never";
                useParameterNames = false;
              };
              maxLength = 25;
              parameterHints = {
                enable = true;
              };
              reborrowHints = {
                enable = "never";
              };
              renderColons = true;
              typeHints = {
                enable = true;
                hideClosureInitialization = false;
                hideNamedConstructor = false;
              };
            };
          };
          onAttach.function = ''
            require("inlay-hints").on_attach(client, bufnr)
          '';
          settings = {
            checkOnSave = true;
            check = {
              command = "clippy";
            };
            procMacro = {
              enable = false;
            };
          };
        };
        #ltex.enable = true;
        texlab.enable = true;
        r-language-server.enable = true;
        bashls.enable = true;
        ltex = {
          enable = true;
          onAttach.function = ''
            require("ltex_extra").setup {
                -- table <string> : languages for witch dictionaries will be loaded, e.g. { "es-AR", "en-US" }
                -- https://valentjn.github.io/ltex/supported-languages.html#natural-languages
                load_langs = { "en-US", "fr-FR" }, -- en-US as default
                -- boolean : whether to load dictionaries on startup
                init_check = true,
                -- string : relative or absolute path to store dictionaries
                -- e.g. subfolder in the project root or the current working directory: ".ltex"
                -- e.g. shared files for all projects:  vim.fn.expand("~") .. "/.local/share/ltex"
                path = ".ltex", -- project root or current working directory
                -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
                log_level = "none",
                -- table : configurations of the ltex language server.
                -- Only if you are calling the server from ltex_extra
                server_opts = nil
            }
          '';
          filetypes = [
            "bib"
            "gitcommit"
            "markdown"
            "plaintex"
            "tex"
          ];
          settings = {
            additionalRules = {
              enablePickyRules = true;
              motherTongue = "fr-FR";
            };
          };
        };
      };
      #   silent = true;
      #   lspBuf = {
      #   gd = {
      #     action = "definition";
      #     desc = "Goto Definition";
      #   };
      #   gr = {
      #     action = "references";
      #     desc = "Goto References";
      #   };
      #   gD = {
      #     action = "declaration";
      #     desc = "Goto Declaration";
      #   };
      #   gI = {
      #     action = "implementation";
      #     desc = "Goto Implementation";
      #   };
      #   gT = {
      #     action = "type_definition";
      #     desc = "Type Definition";
      #   };
      #   K = {
      #     action = "hover";
      #     desc = "Hover";
      #   };
      #   "<leader>cw" = {
      #     action = "workspace_symbol";
      #     desc = "Workspace Symbol";
      #   };
      #   "<leader>cr" = {
      #     action = "rename";
      #     desc = "Rename";
      #   };
      # "<leader>ca" = {
      #   action = "code_action";
      #   desc = "Code Action";
      # };
      # "<C-k>" = {
      #   action = "signature_help";
      #   desc = "Signature Help";
      # };
      # };
      # diagnostic = {
      #   "<leader>cd" = {
      #     action = "open_float";
      #     desc = "Line Diagnostics";
      #   };
      #   "[d" = {
      #     action = "goto_next";
      #     desc = "Next Diagnostic";
      #   };
      #   "]d" = {
      #     action = "goto_prev";
      #     desc = "Previous Diagnostic";
      #   };
      #   };
      # };
    };
  };
  extraConfigLua = ''
    local _border = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = _border
      }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = _border
      }
    )

    vim.diagnostic.config{
      float={border=_border}
    };

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }
  '';
}
