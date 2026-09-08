{ pkgs, variables, ... }: {
  # xdg.dataFile."PrismLauncher/prismlauncher.cfg"= {
  #   source = variables.prismlauncher;
  # };
  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override {
      jdks = with pkgs; [
        temurin-bin-8
        temurin-bin-21
        temurin-bin-26
      ];
    };
  };
}