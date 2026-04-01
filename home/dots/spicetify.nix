{ pkgs, lib, config, inputs, variables, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.system};
  marketplaceData = builtins.fromJSON (builtins.readFile variables.spicetify);
  snippetCSS = lib.concatMapStrings
    (key:
      let entry = builtins.fromJSON marketplaceData.${key};
      in entry.code or ""
    )
    (builtins.fromJSON marketplaceData."marketplace:installed-snippets");
in {
  imports = [ inputs.spicetify.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    extensions = with spicePkgs.extensions; [
      shufflePlus
      autoSkipVideo
      keyboardShortcut
    ];
    customCss = snippetCSS; # Snippets CSS injected directly from your backup JSON at eval time
  };

  # Real symlink → editing the JSON doesn't require nixos-rebuild
  xdg.configFile."spicetify/marketplace-backup.json".source =
    config.lib.file.mkOutOfStoreSymlink variables.spicetify;

  home.activation.spicetifyMarketplaceRestore =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      BACKUP="$HOME/.config/spicetify/marketplace-backup.json"
      PREFS="$HOME/.config/spotify/prefs"

      if [ -f "$BACKUP" ] && [ -f "$PREFS" ]; then
        echo "Spicetify: syncing marketplace backup → Spotify prefs..."
        MERGED=$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$PREFS" "$BACKUP" 2>/dev/null)
        if [ -n "$MERGED" ]; then
          echo "$MERGED" > "$PREFS"
          echo "Spicetify: marketplace state restored."
        fi
      else
        echo "Spicetify: prefs or backup not found, skipping marketplace restore."
      fi
    '';
}