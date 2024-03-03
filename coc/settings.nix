# Would be coc-settings.json
{}: {
  coc.preferences = {
    formatOnSave = true;
  };
  diagnostic = {
    virtualText = true;
    virtualTextCurrentLineOnly = false;
    hintSign = "·";
    errorSign = "✘";
    warningSign = "W";
    infoSign = "I";
  };
  codeLens = {
    enable = false;
  };
  colors.enable = true;
  inlayHint = {
    enable = true;
    display = true;
  };
  go = {
    goplsPath = "gopls";
    goPlsOptions = {
      experimentalPostfixCompletions = true;
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
  python = {
    linting.ruff.enabled = true;
  };
  rust-analyzer = {
    checkOnSave = true;
    diagnostics.experimental.enable = true;
    inlayHints = {
      renderColons = false;
      lifetimeElisionHints.enable = "skip_trivial";
      bindingModeHints.enable = true;
      typeHints.enable = true;
    };
  };
  languageserver = {
    nix = {
      command = "nixd";
      filetypes = ["nix"];
    };
  };
  cSpell = import ./spell.nix;
}
