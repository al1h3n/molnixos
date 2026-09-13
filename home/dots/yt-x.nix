# yt-x - YouTube in the terminal. Package comes from home/user.nix.
#
# The reason personalised data (subscriptions, liked, history, watch later) came
# back empty: yt-x passes CONFIG_BROWSER straight to yt-dlp's
# --cookies-from-browser, its config shipped it empty, and librewolf is not one
# of the browsers yt-dlp knows (brave, chrome, chromium, edge, firefox, opera,
# safari, vivaldi, whale).
#
# yt-dlp does accept browser:PROFILE_PATH though, and librewolf's profile is
# Firefox's format, so pointing the firefox backend at the librewolf profile
# works. Verified against the real account:
#   yt-dlp --cookies-from-browser firefox:~/.librewolf/personal \
#          --flat-playlist --playlist-items 1 --print '%(title)s' \
#          https://www.youtube.com/feed/subscriptions
#
# YT_X_BROWSER overrides the config file (yt-x reads
# CONFIG_BROWSER="${YT_X_BROWSER:-$CONFIG_BROWSER}"), so this needs no config
# file management and survives yt-x rewriting its own config.
{ config, pkgs, inputs, ... }:
let
  # The profile logged into YouTube. profiles.ini calls it "Personal"
  # (Default=1); "work" has no cookies.sqlite at all.
  librewolfProfile = "${config.home.homeDirectory}/.librewolf/personal";
in {
  home = {
    sessionVariables.YT_X_BROWSER = "firefox:${librewolfProfile}";
    packages = with pkgs; [ inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
