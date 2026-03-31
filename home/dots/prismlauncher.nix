{ pkgs, config, variables, ... }: {
  xdg.dataFile."PrismLauncher/prismlauncher.cfg"= {
    source = variables.prismlauncher;
    force = true;
  };
}