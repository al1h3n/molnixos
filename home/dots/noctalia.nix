{ pkgs, inputs, variables, ... }: {
  home.packages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default # noctalia-shell
  ];
  xdg.configFile."noctalia/config.toml" = {
    source = variables.noctalia5;
  };
}
