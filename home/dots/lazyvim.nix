# lazyvim - nvim configuration.
# You can't join xdg.configFile."nvim" = {}; in user modules.
{ lib, config, variables, ... }:
let
  sym = rel: lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${variables.shared}/lazyvim/${rel}");
in {
  programs.lazyvim = {
    enable = true;
    generateHelptags = false;
    extras = {
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true; # installs ruff
        installRuntimeDependencies = true; # installs python3
      };
    };
  };
  xdg.configFile."nvim/lua/plugins/colorscheme.lua".source = sym "theme.lua";
  xdg.configFile."nvim/lua/plugins/dashboard.lua".source = sym "dashboard.lua";
  xdg.configFile."nvim/lua/config/autocmds.lua".source = sym "autocmds.lua";
}