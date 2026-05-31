# lazyvim - nvim configuration.
# You can't join xdg.configFile."nvim" = {}; in user modules.
{ lib, config, variables, ... }:
let
  sym = rel: lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${variables.shared}/lazyvim/${rel}");
  mkLangSet = lang: lib.setAttrByPath [ "lang" lang ] {
    enable = true;
    installDependencies = true;
    installRuntimeDependencies = true;
  };

  # Supports everything in LazyExtras.
  langList = [ "python" "rust" "nix" "go" "json" "clangd" "cmake" ];
  allLangs = lib.foldl' lib.recursiveUpdate {} (map mkLangSet langList);
in {
  programs.lazyvim = {
    # Available options "github.com/pfassina/lazyvim-nix/blob/main/nix/options.nix"
    enable = true;
    extras = allLangs;
  };
  xdg.configFile."nvim/lua/plugins/theme.lua".source = sym "theme.lua";
  xdg.configFile."nvim/lua/plugins/dashboard.lua".source = sym "dashboard.lua";
  xdg.configFile."nvim/lua/config/autocmds.lua".source = sym "autocmds.lua";
}