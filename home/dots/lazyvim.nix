# lazyvim - nvim configuration.
# You can't join xdg.configFile."nvim" = {}; in user modules.
{ lib, config, variables, ... }:
let
  sym = rel: lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${variables.shared}/lazyvim/${rel}");
  mkLang = lang: {
    name = "lang/${lang}";
    value = {
      enable = true;
      installDependencies = true;
      installRuntimeDependencies = true;
    };
  };
in {
  programs.lazyvim = {
    enable = true;
    extras = { "lang/nix".enable = true; } // (builtins.listToAttrs (map mkLang [
      "json" "nix" "python" "rust" "go" "lua" "clang"
    ]));
  };
  xdg.configFile."nvim/lua/plugins/colorscheme.lua".source = sym "theme.lua";
  xdg.configFile."nvim/lua/plugins/dashboard.lua".source = sym "dashboard.lua";
  xdg.configFile."nvim/lua/config/autocmds.lua".source = sym "autocmds.lua";
}