{ ... }: {
  home.packages = with pkgs[
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default # noctalia-shell
  ];
  xdg.dataFile."noctalia/settings.toml" = {
    source = variables.noctalia5;
  };
}
