{}: {
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
  colors.enable = false;
  inlayHint = {
    enable = true;
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
}
