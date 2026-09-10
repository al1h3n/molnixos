# https://github.com/al1h3n/sweeper
# Update with `nix flake update sweeper`.
{ pkgs, inputs, ... }:
let
  sweeper = pkgs.writeShellApplication {
    name = "sweeper";
    text = builtins.readFile "${inputs.sweeper}/sweeper.sh";
    # The script is linted upstream; skip shellcheck to keep rebuilds cheap.
    checkPhase = "";
  };
in {
  environment.systemPackages = [ sweeper ];
  # Runs once per login session.
  systemd.user.services.sweeper = {
    description = "Sweeper cleaner by al1h3n";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${sweeper}/bin/sweeper";
      RemainAfterExit = true;
    };
  };
}