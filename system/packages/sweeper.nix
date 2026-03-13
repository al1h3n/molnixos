# https://github.com/Alihan1ai9595/sweeper
{ pkgs, ... }:
let
  # Fetched at build time, cached in Nix store. 
  # Only re-downloads when you run nixos-rebuild, not on every reboot.
  sweeperScript = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/Alihan1ai9595/sweeper/unobfusticated/sweeper.sh";
  };
in {
  # Makes script available system-wide as a package. Saved in /nix/store/<hash>-sweeper.sh
  environment.systemPackages = [
    (pkgs.writeScriptBin "sweeper" (builtins.readFile sweeperScript))
  ];

  # Systemd user service — runs for every user that logs in.
  systemd.user.services.sweeper = {
    description = "Sweeper cleaner by al1h3n";
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${sweeperScript}";
      RemainAfterExit = true;
    };
  };
}