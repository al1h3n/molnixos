{ pkgs, inputs, variables, config, ... }: {
  home.packages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default # noctalia-shell
  ];
  xdg.configFile."noctalia/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink variables.noctalia5;
    force = true;
  };
}
