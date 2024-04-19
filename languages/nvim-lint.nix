{
  plugins.lint = {
    enable = true;
    lintersByFt = {
      nix = ["statix"];
      lua = ["selene"];
      python = ["ruff"];
      json = ["jsonlint"];
      yaml = ["yamllint"];
      tex = ["chktex"];
    };
  };
}
