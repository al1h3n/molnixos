{ ... }: {
  xfconf.settings = {
    thunar = {
      "last-show-hidden" = true;  # Thunar file manager window
    };
  };
  dconf.settings = {
    "org/gtk/settings/file-chooser" = {
      show-hidden = true;  # GTK open/save dialogs in all apps
    };
  };
}