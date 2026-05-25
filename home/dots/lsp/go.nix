{ pkgs, ... }:{
  home.packages = with pkgs; [
    # Go
    go                 # Language runtime
    gopls              # Go LSP
    gofumpt            # Formatter
  ];
}