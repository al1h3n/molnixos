{ config, variables, ... }: {
  gtk.cursorTheme = {
    name = variables.cursor_name;
    size = 29;
  };

  # Sets cursor for Hyprland + all Wayland/X11 apps.
  home.sessionVariables = {
    XCURSOR_THEME = variables.cursor_name;
    XCURSOR_SIZE = "29";
  };

  home.activation.linkCursor = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.local/share/icons
    if [ -d "${variables.cursor}" ]; then
      ln -sfn "${variables.cursor}" $HOME/.local/share/icons/${variables.cursor_name}
    else
      echo "Warning: cursor not found at ${variables.cursor}, skipping."
    fi
  '';
}