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
#
# Live theme changes
# ------------------
# VS Code reads a theme extension's JSON once, at load, so rewriting it while
# VSCodium is open changes nothing until the window reloads - and there is no
# CLI to reload a window. settings.json is different: it is watched, and edits
# apply immediately.
#
# So the colours are mirrored from the theme file into
# workbench.colorCustomizations in settings.json. A systemd path unit does the
# mirroring whenever noctalia rewrites the theme, which beats polling and does
# not depend on noctalia's hook config.
{ pkgs, lib, config, ... }:
let
  extRoot = ".vscode-oss/extensions";
  extDir = "${extRoot}/noctalia.noctaliatheme-0.0.5-universal";

  themeFile = "${config.home.homeDirectory}/${extDir}/themes/NoctaliaTheme-color-theme.json";
  settingsFile = "${config.xdg.configHome}/VSCodium/User/settings.json";

  # settings.json is JSONC - VS Code allows comments, and this one starts with
  # two. jq refuses to parse it, so the colours are spliced in textually and
  # every comment survives byte for byte.
  syncScript = pkgs.writers.writePython3Bin "vscodium-noctalia-sync" {
    # Interpolated store/home paths blow past 79 chars on their own.
    flakeIgnore = [ "E501" ];
  } ''
    import json

    THEME = "${themeFile}"
    SETTINGS = "${settingsFile}"
    KEY = '"workbench.colorCustomizations"'

    try:
        with open(THEME) as fh:
            colors = json.load(fh)["colors"]
    except (OSError, ValueError, KeyError):
        raise SystemExit(0)  # half-written or missing theme: leave settings alone

    try:
        with open(SETTINGS) as fh:
            text = fh.read()
    except OSError:
        text = "{\n}\n"

    block = KEY + ": " + json.dumps(colors, indent=4, sort_keys=True)

    start = text.find(KEY)
    if start == -1:
        # No such key yet: insert before the final closing brace.
        close = text.rfind("}")
        head = text[:close].rstrip()
        sep = "" if head.endswith(("{", ",")) else ","
        text = head + sep + "\n    " + block + "\n}\n"
    else:
        # Walk the existing value's braces so nested objects do not end it early.
        i = text.index("{", start)
        depth = 0
        for end, ch in enumerate(text[i:], i):
            if ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0:
                    break
        text = text[:start] + block + text[end + 1:]

    # Truncate in place rather than renaming: VSCodium watches the inode.
    with open(SETTINGS, "w") as fh:
        fh.write(text)
  '';

in {
  home.packages = [ pkgs.vscodium ];

  systemd.user.services.vscodium-noctalia = {
    Unit.Description = "Mirror the Noctalia theme into VSCodium settings.json";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe syncScript;
    };
  };
  systemd.user.paths.vscodium-noctalia = {
    Unit.Description = "Watch the Noctalia VSCodium theme file";
    Path.PathChanged = themeFile;
    Install.WantedBy = [ "paths.target" ];
  };

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
