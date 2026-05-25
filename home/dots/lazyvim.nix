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

  langList = [ "python" "rust" "nix" "go" "json" "clangd" ];
  # Available options are in "github.com/pfassina/lazyvim-nix/blob/main/nix/options.nix" - find lang.x
  # "lua" "clangd" "cmake"

  allLangs = lib.foldl' lib.recursiveUpdate {} (map mkLangSet langList);
in {
  programs.lazyvim = {
    enable = true;
    extras = allLangs;
  };
  xdg.configFile."nvim/lua/plugins/colorscheme.lua".source = sym "theme.lua";
  xdg.configFile."nvim/lua/plugins/dashboard.lua".source = sym "dashboard.lua";
  xdg.configFile."nvim/lua/config/autocmds.lua".source = sym "autocmds.lua";
}