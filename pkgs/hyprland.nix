{ ... }: {
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };
  xdg.portal.config.hyprland = {
    default = [ "hyprland" "gtk" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
  };
}