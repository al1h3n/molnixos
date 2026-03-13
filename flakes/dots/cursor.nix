{ pkgs, config, variables, ... }:
let
  cursorTheme = pkgs.runCommand "clay-white-cursor" {} ''
    mkdir -p $out/share/icons/${variables.cursor_name}
    cp -r ${variables.cursor}/. $out/share/icons/${variables.cursor_name}/
  '';
in {
  home = {
    pointerCursor = {
      name = variables.cursor_name; # Must match folder name inside the archive
      package = cursorTheme;
      size = 29;
      gtk.enable = true;
      x11.enable = true;
    };
    activation.linkCursor = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.local/share/icons/molniux
    ln -sfn ${cursorTheme}/share/icons/${variables.cursor_name} $HOME/.local/share/icons/molniux/${variables.cursor_name}
    '';
  };
  # environment.etc = {
  #   "icons/molniux/${variables.cursor_name}".source = "${cursorTheme}/share/icons/${variables.cursor_name}";
  # };
}