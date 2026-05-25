# Firefox
{ pkgs, ... }:
let
  commonSettings = {
    # Extensions.
    "extensions.allowPrivateBrowsingByDefault" = true;
    "extensions.autoDisableScopes" = 0; # Automatically enable extensions.

    # UI.
    "browser.uidensity" = 1;

    # Pocket.
    "extensions.pocket.api" = "";
    "extensions.pocket.enabled" = false;
    "extensions.pocket.site" = "";
    "extensions.pocket.oAuthConsumerKey" = "";

    # Fullscreen.
    "full-screen-api.transition-duration.enter" = "0";
    "full-screen-api.transition-duration.leave" = "0";
    "full-screen-api.warning.timeout" = 0;

    # Privacy.
    "privacy.trackingprotection.enabled" = true;
    "privacy.donottrackheader.enabled" = true;

    # Fission (site isolation).
    "fission.autostart" = true;

    # HTTP pipelining (legacy networking tweaks).
    "network.http.pipelining" = true;
    "network.http.proxy.pipelining" = true;
    "network.http.pipelining.maxrequests" = 30;

    # Rendering.
    "nglayout.initialpaint.delay" = 0;

    # DNS.
    "network.dns.ecg" = true;

    # Telemetry.
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.cachedClientID" = "";
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.hybridContent.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.previousBuildID" = "";
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.server" = "";
    "toolkit.telemetry.server_owner" = "";
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.updatePing.enabled" = false;

    "datareporting.healthreport.infoURL" = "";
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.policy.firstRunURL" = "";

    "browser.tabs.crashReporting.sendReport" = false;
    "browser.tabs.crashReporting.email" = false;
    "browser.tabs.crashReporting.emailMe" = false;

    "breakpad.reportURL" = "";
    "security.ssl.errorReporting.automatic" = false;
    "toolkit.crashreporter.infoURL" = "";

    "network.allow-experiments" = false;
    "dom.ipc.plugins.reportCrashURL" = false;
    "dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = false;
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

  home.packages = [
    pkgs.pywalfox-native
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.pywalfox-native ]; # pywal in firefox.
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
          nighttab darkreader
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
          ublock-origin canvasblocker privacy-badger smart-referer darkreader
        ];
      };
    };
  };
}