{ pkgs, ... }:{
  home.packages = with pkgs; [
    # Rust
    rustc              # Compiler
    cargo              # Package manager
    rust-analyzer      # Rust LSP
    rustfmt            # Formatter
  ];
}