{ pkgs, ... }:{
  home.packages = with pkgs; [
    clang-tools        # Provides clangd (LSP), used by the VSCodium clangd extension.
    # cmake            # Build tool, moved to shells/cpp.nix - no CMakeLists.txt on this machine.
  ];
}