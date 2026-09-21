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
# After the rebuild: Ctrl+K Ctrl+T -> "Noctalia".
#
# Live theme changes
# ------------------
# VS Code reads a theme extension's JSON once, at load, so rewriting it while
# VSCodium is open changes nothing until the window reloads - and there is no
# CLI to reload a window. settings.json is different: it is watched, and edits
# apply immediately.
#
# When the selected workbench theme is Noctalia, colours are mirrored from the
# generated theme file into workbench.colorCustomizations. Selecting any other
# theme removes that generated override so its own palette can take effect.
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
    THEME_KEY = '"workbench.colorTheme"'
    NOCTALIA_THEME = "Noctalia"

    try:
        with open(SETTINGS) as fh:
            text = fh.read()
    except OSError:
        text = "{\n}\n"
    original = text


    def remove_customizations(text):
        start = text.find(KEY)
        if start == -1:
            return text

        value_start = text.index("{", start)
        depth = 0
        for end, ch in enumerate(text[value_start:], value_start):
            if ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0:
                    break

        line_start = text.rfind("\n", 0, start) + 1
        block_end = end + 1
        while block_end < len(text) and text[block_end] in " \t":
            block_end += 1
        if block_end < len(text) and text[block_end] == ",":
            block_end += 1
        else:
            before = text[:line_start].rstrip()
            if before.endswith(","):
                line_start = len(before) - 1
        if block_end < len(text) and text[block_end] == "\n":
            block_end += 1
        return text[:line_start] + text[block_end:]


    active = THEME_KEY + ': "' + NOCTALIA_THEME + '"' in text
    if not active:
        updated = remove_customizations(text)
        if updated != text:
            with open(SETTINGS, "w") as fh:
                fh.write(updated)
        raise SystemExit(0)

    try:
        with open(THEME) as fh:
            colors = json.load(fh)["colors"]
    except (OSError, ValueError, KeyError):
        raise SystemExit(0)  # half-written or missing theme: leave settings alone

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
    if text != original:
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
    Install.WantedBy = [ "default.target" ];
  };
  systemd.user.paths.vscodium-noctalia = {
    Unit.Description = "Watch the Noctalia VSCodium theme file";
    Path.PathChanged = [ themeFile settingsFile ];
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
        label = "Noctalia";
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
