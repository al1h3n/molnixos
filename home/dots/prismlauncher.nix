{ pkgs, variables, ... }: {
  home.packages = [ pkgs.libxkbcommon ]; # WaylandCraft mod reads the system keymap through it.
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

  # xdg.dataFile."PrismLauncher/prismlauncher.cfg"= {
  #   source = variables.prismlauncher;
  # };
}