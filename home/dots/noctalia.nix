{ pkgs, inputs, variables, config, ... }: {
  home.packages = with pkgs; [
    noctalia # noctalia-shell
  ];
  xdg.configFile."noctalia/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink variables.noctalia5;
    force = true;
  };
}
