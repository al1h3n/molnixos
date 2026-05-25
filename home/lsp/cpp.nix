{ pkgs, ... }:{
  home.packages = with pkgs; [
    # C/C++
    clang-tools        # Provides clangd (LSP)
    cmake              # Build tool
  ];
}