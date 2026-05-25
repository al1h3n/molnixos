{ pkgs, ... }: {
  home.packages = with pkgs; [
    basedpyright # LSP
    ruff # Formatter
  ];
}