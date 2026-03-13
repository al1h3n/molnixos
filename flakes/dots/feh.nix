{ config, pkgs, ... }: {
  programs.feh = {
    enable = true;
    buttons = {
      prev_img = null;
      next_img = null;
      zoom_in = 4;  # Scroll Up
      zoom_out = 5; # Scroll Down
    };
  };
}