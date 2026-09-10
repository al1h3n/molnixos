# VSCodium + the Noctalia "vscode" community template.
#
# The template only writes the colour file:
#   ~/.vscode-oss/extensions/noctalia.noctaliatheme-0.0.5-universal/themes/NoctaliaTheme-color-theme.json
# VS Code / VSCodium never looks at a theme file on its own, it scans the
# extensions directory for folders that carry a package.json manifest. Without
# one the folder is skipped and "NoctaliaTheme" never shows up in the theme
# picker - which is exactly why nothing happened. The manifest below is the
# missing half; the template keeps rewriting the colours next to it on every
# wallpaper change, and VSCodium re-reads them live.
#
# After the first rebuild: Ctrl+K Ctrl+T -> "NoctaliaTheme".
{ pkgs, ... }:
let
  extDir = ".vscode-oss/extensions/noctalia.noctaliatheme-0.0.5-universal";
in {
  home.packages = [ pkgs.vscodium ];

  home.file."${extDir}/package.json".text = builtins.toJSON {
    name = "noctaliatheme";
    displayName = "Noctalia";
    publisher = "noctalia";
    version = "0.0.5";
    engines.vscode = "^1.70.0";
    categories = [ "Themes" ];
    contributes.themes = [{
      label = "NoctaliaTheme";
      uiTheme = "vs-dark";
      path = "./themes/NoctaliaTheme-color-theme.json";
    }];
  };
}
