# LSP providers for nvim, add lang.x in settings to enable them in application.
{ ... }: {
  imports = [
    ./lsp/cpp.nix
    ./lsp/go.nix
    ./lsp/lua.nix
    ./lsp/nix.nix
    # ./lsp/python.nix
    # ./lsp/rust.nix
  ];
}