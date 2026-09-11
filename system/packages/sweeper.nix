# https://github.com/al1h3n/sweeper
# Update with `nix flake update sweeper`.
{ pkgs, inputs, ... }:
let
  sweeper = pkgs.writeShellApplication {
    name = "sweeper";
    # systemd units get a minimal PATH. The script skips tools it cannot find,
    # so anything left out here is silently not cleaned.
    runtimeInputs = with pkgs; [
      coreutils # du, cut, rm, sync, truncate, basename
      findutils # find
      fontconfig # fc-cache
      systemd # journalctl
      util-linux # swapoff, swapon
    ];
    text = builtins.readFile "${inputs.sweeper}/sweeper.sh";
  };
in {
  environment.systemPackages = [ sweeper ];
  # Runs as root, so the script never needs to re-exec via sudo (a user unit has
  # no TTY and would stall on the password prompt).
  #
  # Deliberately not wantedBy any target: only the timer starts it. Otherwise
  # `nixos-rebuild switch` would start it too, and a failed sweep would fail the
  # whole switch.
  systemd.services.sweeper = {
    description = "Sweeper cleaner by al1h3n";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${sweeper}/bin/sweeper";
    };
  };

  systemd.timers.sweeper = {
    description = "Run sweeper shortly after boot";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "10min";
      Unit = "sweeper.service";
    };
  };
}