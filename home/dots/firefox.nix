# Firefox
{ pkgs, ... }: {
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

    preferences = {
      "extensions.allowPrivateBrowsingByDefault" = true;

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

    profiles = {
      personal = {
        id = 0;
        name = "Personal";
        settings = {
          "extensions.autoDisableScopes" = 0; # Automatically enable extensions.
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          # Privacy and slop
          ublock-origin canvasblocker privacy-badger skip-redirect smart-referer

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
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin canvasblocker privacy-badger skip-redirect smart-referer
        ];
      };
    };
  };
}