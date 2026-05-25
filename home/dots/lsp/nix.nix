{ pkgs, ... }:{
  home.packages = with pkgs; [
    # nix
    nixd       # Highly recommended for NixOS
    nil        # Alternative language server
    nixpkgs-fmt # Optional: formatter
  ];
}