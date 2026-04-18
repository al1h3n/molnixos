# Spicetify manages Spotify automatically - gerg-l.github.io/spicetify-nix
{ inputs, pkgs, ... }: {
  programs.spicetify = {
    enable = true;
    # Marketplace.
    # enabledCustomApps = with spicePkgs.apps; [ marketplace ];
  };
}