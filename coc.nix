{}: {
  diagnostic = {
    virtualText = true;
    virtualTextCurrentLineOnly = false;
  };
  inlayHint.enable = true;
  languageserver = {
    nix = {
      command = "nil";
      filetypes = ["nix"];
    };
  };
}
