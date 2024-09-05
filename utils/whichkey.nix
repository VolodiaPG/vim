{
  # TODO: Implement general mappings
  plugins.which-key = {
    enable = true;
    settings = {
      ignore_milling = false;
      icons = {
        breadcrumb = "»";
        group = "+";
        separator = ""; # ➜
      };
      # registrations = {
      #   "<leader>t" = " Terminal";
      # };
      win = {
        border = "none";
        wo.winblend = 0;
      };
    };
  };
}
