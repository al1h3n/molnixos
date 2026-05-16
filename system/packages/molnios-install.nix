# https://gitlab.com/al1h3n/molnios-install
{ pkgs, ... }:
let
  # Fetched at build time, cached in Nix store.
  # Only re-downloads when you run nixos-rebuild, not on every reboot.
  script = builtins.fetchurl {
    url = "https://gitlab.com/al1h3n/molnios-install/-/raw/main/molnios-v2.sh";
  };
in {
  # Makes script available system-wide as a package. Saved in /nix/store/<hash>-sweeper.sh
  environment.systemPackages = [
    (pkgs.writeScriptBin "molnios" (builtins.readFile script))
  ];
}