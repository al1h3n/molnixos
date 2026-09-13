# VSCodium + the Noctalia "vscode" community template.
#
# The template only writes the colour file:
#   ~/.vscode-oss/extensions/noctalia.noctaliatheme-0.0.5-universal/themes/NoctaliaTheme-color-theme.json
# A theme needs a package.json manifest next to it, which the template does not
# write - that is the manifest below.
#
# The manifest alone is still not enough. Since VS Code 1.74 the extensions
# directory is no longer scanned: extensions.json in that directory is the
# authoritative list, and a hand-placed folder that is not listed there is
# invisible. That is why searching "noctalia" in the theme picker found nothing
# even with a valid manifest present.
#
# Deleting extensions.json and running `codium --list-extensions` makes VSCodium
# rebuild it by scanning the directory, picking up both this theme and anything
# installed through the marketplace UI. onChange runs that whenever the manifest
# changes, which is the same trick home-manager's own programs.vscode module
# uses for mutableExtensionsDir.
#
# After the rebuild: Ctrl+K Ctrl+T -> "NoctaliaTheme".
{ pkgs, ... }:
let
  extRoot = ".vscode-oss/extensions";
  extDir = "${extRoot}/noctalia.noctaliatheme-0.0.5-universal";
in {
  home.packages = [ pkgs.vscodium ];

  home.file."${extDir}/package.json" = {
    text = builtins.toJSON {
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

    onChange = ''
      run rm -f $VERBOSE_ARG "$HOME/${extRoot}"/{extensions.json,.init-default-profile-extensions}
      verboseEcho "Regenerating VSCodium extensions.json"
      run ${pkgs.vscodium}/bin/codium --list-extensions > /dev/null
    '';
  };
}
