# Noctalia layers its own writable ~/.local/state/noctalia/settings.toml on top
# of this read-only config.toml, so a store symlink here is fine: GUI changes
# still persist, they just land in the state file.
{ pkgs, variables, config, ... }: {
  home.packages = with pkgs; [
    noctalia # noctalia-shell
  ];
  xdg.configFile."noctalia/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink variables.noctalia5;
    force = true;
  };
}
