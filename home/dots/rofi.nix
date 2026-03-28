{ variables, ... }: {
  xdg.configFile."rofi/config.rasi".text = builtins.replaceStrings
    [ "~/.local/share/molnios" ][ variables.lshared ]
    (builtins.readFile variables.rofi);
}