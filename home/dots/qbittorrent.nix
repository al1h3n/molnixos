# Force a re-check:  rm -rf ~/.local/state/qbittorrent-themes
# Run it now:        systemctl --user start qbittorrent-themes
{ pkgs, lib, config, variables, ... }:
let
  themesDir = "${config.xdg.configHome}/qBittorrent/themes";
  stateDir = "${config.xdg.stateHome}/qbittorrent-themes";

  # repo -> asset file names to pull from its latest release.
  sources = {
    "catppuccin/qbittorrent" = [
      "catppuccin-frappe.qbtheme"
      "catppuccin-macchiato.qbtheme"
      "catppuccin-mocha.qbtheme"
    ];
    "witalihirsch/qBitTorrent-fluent-theme" = [
      "defaulticons-fluent-light-no-mica.qbtheme"
      "defaulticons-fluent-dark-no-mica.qbtheme"
    ];
  };

  syncRepo = repo: assets: ''
    stamp="${stateDir}/${builtins.replaceStrings [ "/" ] [ "_" ] repo}.tag"

    # -I -L follows the redirect with HEAD requests only (no release-page HTML
    # is downloaded) and -w %{url_effective} prints the final
    # .../releases/tag/<tag> URL.
    #
    # The `!= latest` guard is not paranoia: on a failed request curl still
    # prints the URL it was *asked* for, so without it an offline run would
    # parse the tag as the literal string "latest" and then try to download
    # five assets from a tag that does not exist.
    if latest=$(curl -fsSIL --max-time 20 -o /dev/null -w '%{url_effective}' \
                  "https://github.com/${repo}/releases/latest"); then
      latest=''${latest##*/}
      [ "$latest" = latest ] && latest=""
    else
      latest=""
    fi

    if [ -z "$latest" ]; then
      echo "qbittorrent-themes: ${repo} unreachable, keeping current themes" >&2
    elif [ "$latest" = "$(cat "$stamp" 2>/dev/null || true)" ]; then
      : # already on the newest release
    else
      echo "qbittorrent-themes: ${repo} -> $latest"
      ok=1
      ${lib.concatMapStringsSep "\n      " (a: ''
        if curl -fsSL --retry 2 -o "${themesDir}/${a}.new" \
             "https://github.com/${repo}/releases/download/$latest/${a}"; then
          mv -f "${themesDir}/${a}.new" "${themesDir}/${a}"
        else
          rm -f "${themesDir}/${a}.new"
          ok=0
        fi
      '') assets}
      # Only record the tag once every asset landed, so a partial failure is
      # retried on the next tick instead of being remembered as done.
      [ "$ok" = 1 ] && printf '%s' "$latest" > "$stamp"
    fi
  '';

  syncScript = pkgs.writeShellApplication {
    name = "qbittorrent-themes-sync";
    runtimeInputs = [ pkgs.curl pkgs.coreutils ];
    text = ''
      mkdir -p "${themesDir}" "${stateDir}"
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList syncRepo sources)}
    '';
  };
in {
  home.packages = [ pkgs.qbittorrent-enhanced ];

  xdg.configFile."qBittorrent/qBittorrent.conf" = {
    source = variables.qbittorrent;
    force = true;
  };

  systemd.user.services.qbittorrent-themes = {
    Unit.Description = "Fetch newest qBittorrent themes";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe syncScript;
    };
  };
  systemd.user.timers.qbittorrent-themes = {
    Unit.Description = "Fetch newest qBittorrent themes";
    Timer = {
      OnStartupSec = "3min"; # off the login critical path
      OnUnitInactiveSec = "1d";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
