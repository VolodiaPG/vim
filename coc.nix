{}: {
  diagnostic = {
    virtualText = true;
    virtualTextCurrentLineOnly = false;
  };
  inlayHints.enable = true;
  languageserver = {
    nix = {
      command = "nil";
      filetypes = ["nix"];
    };
  };
}
