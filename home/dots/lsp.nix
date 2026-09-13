# LSP providers, on the user profile so VSCodium (and anything else) finds them.
#
# Only language servers and formatters belong here. Compilers, build tools and
# language runtimes go in ~/.config/shells/*.nix - see home/dots/shells.nix.
#
# go.nix was dropped: go/gopls/gofumpt had no Go code on the machine and were
# byte-identical duplicates of what lazyvim-nix already wraps into nvim's PATH.
# They now live in shells/go.nix.
{ ... }: {
  imports = [
    ./lsp/cpp.nix
    ./lsp/lua.nix
    ./lsp/nix.nix
    ./lsp/python.nix
    ./lsp/rust.nix
  ];
}
