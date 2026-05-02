# Firefox
{ config, pkgs, ... }:
let
  commonSettings = {
    "extensions.allowPrivateBrowsingByDefault" = true;
    "extensions.autoDisableScopes" = 0; # Automatically enable extensions.

      # Fission (site isolation)
      "fission.autostart" = true;

      # HTTP pipelining (legacy networking tweaks)
      "network.http.pipelining" = true;
      "network.http.proxy.pipelining" = true;
      "network.http.pipelining.maxrequests" = 30;

      # Rendering / paint behavior
      "nglayout.initialpaint.delay" = 0;

      # DNS
      "network.dns.ecg" = true;
  };
in {
  xdg.mimeApps = {
  enable = true;
  defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  programs.firefox = {
    enable = true;
    profiles = {
      personal = {
        id = 0;
        name = "Personal";
        settings = commonSettings;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          # Privacy and slop
          ublock-origin canvasblocker privacy-badger smart-referer
          # skip-redirect # Irritating sometimes.

          # Perfomance
          onetab

          # YouTube
          enhancer-for-youtube return-youtube-dislikes sponsorblock videospeed

          # Style
          nighttab
        ];
      };

      # PROFILE 2: WORK
      work = {
        id = 1;
        name = "Education";
        settings = commonSettings;
        # settings = commonSettings // {
        #   "browser.startup.homepage" = "https://google.com";
        # };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin canvasblocker privacy-badger smart-referer
        ];
      };
    };
  };
}