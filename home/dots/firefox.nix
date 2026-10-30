{ pkgs, ... }:

let
  # SHARED SETTINGS
  commonSettings = {
    # Extensions
    "extensions.allowPrivateBrowsingByDefault" = true;
    "extensions.autoDisableScopes" = 0;

    # UI
    "browser.uidensity" = 1;

    # Pocket
    "extensions.pocket.api" = "";
    "extensions.pocket.enabled" = false;
    "extensions.pocket.site" = "";
    "extensions.pocket.oAuthConsumerKey" = "";

    # Fullscreen
    "full-screen-api.transition-duration.enter" = "0";
    "full-screen-api.transition-duration.leave" = "0";
    "full-screen-api.warning.timeout" = 0;

    # Tracking protection
    "privacy.trackingprotection.enabled" = true;
    "privacy.donottrackheader.enabled" = true;

    # Site isolation
    "fission.autostart" = true;

    # Telemetry
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

    # Data reporting
    "datareporting.healthreport.infoURL" = "";
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.policy.firstRunURL" = "";

    # Crash reporting
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.tabs.crashReporting.email" = false;
    "browser.tabs.crashReporting.emailMe" = false;
    "breakpad.reportURL" = "";
    "security.ssl.errorReporting.automatic" = false;
    "toolkit.crashreporter.infoURL" = "";

    # Experiments
    "network.allow-experiments" = false;
    "dom.ipc.plugins.reportCrashURL" = false;
    "dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = false;
  };

  # PROFILE 1: PRIVACY
  privacySettings = {
    # Firefox Account & Sync
    "identity.fxaccounts.enabled" = false;
    "services.sync.enabled" = false;

    # Fingerprinting protection
    "privacy.resistFingerprinting" = true;

    # WebGL
    "webgl.disabled" = true;

    # JavaScript JIT
    "javascript.options.baselinejit" = false;
    "javascript.options.ion" = false;
    "javascript.options.jit_trustedprincipals" = false;

    # WebAssembly
    "javascript.options.wasm" = false;
    "javascript.options.wasm_trustedprincipals" = false;
    "javascript.options.wasm_baselinejit" = false;
    "javascript.options.wasm_optimizingjit" = false;

    # asm.js
    "javascript.options.asmjs" = false;
    "javascript.options.blinterp" = false;
  };

  # PROFILE 2: PROJECTS
  projectsSettings = {
    # Firefox Account & Sync
    "identity.fxaccounts.enabled" = true;
    "services.sync.enabled" = true;

    # Fingerprinting protection
    "privacy.resistFingerprinting" = false;

    # WebGL
    "webgl.disabled" = false;

    # WebGPU
    "dom.webgpu.enabled" = true;

    # JavaScript JIT
    "javascript.options.baselinejit" = true;
    "javascript.options.ion" = true;
    "javascript.options.jit_trustedprincipals" = false;

    # WebAssembly
    "javascript.options.wasm" = true;
    "javascript.options.wasm_trustedprincipals" = false;
    "javascript.options.wasm_baselinejit" = true;
    "javascript.options.wasm_optimizingjit" = true;

    # asm.js
    "javascript.options.asmjs" = true;
    "javascript.options.blinterp" = true;
  };

in {
  # MIME associations
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

  # Pywalfox
  home.packages = [
    pkgs.pywalfox-native
  ];

  programs.firefox = {
    enable = true;

    nativeMessagingHosts = [
      pkgs.pywalfox-native
    ];

    policies = {
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        WhatsNew = false;
      };
    };

    profiles = {
      # PROFILE 1: PRIVACY
      privacy = {
        id = 0;
        name = "Privacy";

        settings = commonSettings // privacySettings;

        extensions.packages =
          with pkgs.nur.repos.rycee.firefox-addons; [
            # Privacy
            ublock-origin
            canvasblocker
            privacy-badger
            smart-referer

            # Performance
            onetab

            # Style
            nighttab
            darkreader
          ];
      };

      # PROFILE 2: PROJECTS
      projects = {
        id = 1;
        name = "Projects";

        settings = commonSettings // projectsSettings;

        extensions.packages =
          with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            canvasblocker
            privacy-badger
            smart-referer
            darkreader
          ];
      };
    };
  };
}
