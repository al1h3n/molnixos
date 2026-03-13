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
    profiles = {
      personal = {
        id = 0;
        name = "Personal";
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
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin canvasblocker privacy-badger skip-redirect smart-referer
        ];
      };
    };
  };
}