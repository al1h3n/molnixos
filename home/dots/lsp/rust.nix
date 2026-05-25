{ pkgs, ... }:{
  home.packages = with pkgs; [
    # Rust
    rust-analyzer      # Rust LSP
    rustfmt            # Formatter
  ];
}