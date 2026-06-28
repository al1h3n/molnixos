{ pkgs, ... }: {
  services.desktopManager.gnome.enable = true;
  services.gnome = {
    core-apps.enable = false;
    core-developer-tools.enable = false;
    games.enable = false;
  };
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-weather gnome-maps gnome-contacts gnome-calendar
      gnome-text-editor gnome-font-viewer gnome-characters
      gnome-user-docs gnome-logs gnome-tour yelp
      cheese snapshot # webcam tool
      gedit     # text editor
      epiphany  # web browser
      geary     # email reader
      rhythmbox # music player
      totem     # video player
      tali iagno hitori atomix # games
      # gnome-connections # remote desktop
      gnome-boxes # VM manager
      malcontent # parental controls

    ];
    systemPackages = [ pkgs.gnome-menus ];
    variables = {
      GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
    };
  };
}
