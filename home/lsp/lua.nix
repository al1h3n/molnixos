{ pkgs, ... }:{
  home.packages = with pkgs; [
    # Lua
    lua-language-server # Lua LSP
    stylua              # Formatter
  ];
}