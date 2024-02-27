{}: {
  diagnostic = {
    virtualText = true;
    virtualTextCurrentLineOnly = false;
    hintSign  =  "✹";
    errorSign = "✘";
    warningSign = "";
    infoSign = "";
  };
  codeLens = {
    enable = false;
  };
  colors.enable = true;
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
    };
  };
  languageserver = {
    nix = {
      command = "nil";
      filetypes = ["nix"];
    };
  };
}
