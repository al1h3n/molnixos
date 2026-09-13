# Prunes the leftovers home-manager activation drops next to managed files.
#
# Two kinds:
#   <file>.tmp.XXXXXX   written by putter (home-manager's file linker) when it
#                       force-replaces an out-of-store symlink, and not cleaned
#                       up afterwards. Only the entries that are BOTH
#                       mkOutOfStoreSymlink and force = true produce them, which
#                       here is hypr/hyprland.lua and wezterm/wezterm.lua.
#   <file>.backup       from home-manager.backupFileExtension, one per collision
#                       per activation.
#
# Neither is large - 87 files came to 94 KB - but nothing ever removes them, so
# the count only grows and the directories become unreadable.
#
# Manual use:
#   config-cleanup            prune by the policy below
#   config-cleanup --all      remove every match regardless of age or count
#   config-cleanup --dry-run  list what would go
{ pkgs, lib, config, ... }:
let
  # Keep this many newest per base file, and drop anything older than this many
  # days even if it is inside that count.
  keep = 3;
  maxAgeDays = 7;

  roots = [
    config.xdg.configHome
    "${config.home.homeDirectory}/.librewolf"
    "${config.home.homeDirectory}/.local/share"
  ];

  cleanupScript = pkgs.writeShellApplication {
    name = "config-cleanup";
    runtimeInputs = [ pkgs.findutils pkgs.coreutils ];
    text = ''
      all=0
      dry=0
      for a in "$@";do
          case "$a" in
              --all)     all=1 ;;
              --dry-run) dry=1 ;;
              *) echo "usage: config-cleanup [--all] [--dry-run]" >&2; exit 2 ;;
          esac
      done

      roots=(${lib.escapeShellArgs roots})
      removed=0

      drop() {
          if [ "$dry" = 1 ];then
              echo "would remove: $1"
          else
              rm -f -- "$1" && removed=$((removed + 1))
          fi
      }

      # -print0 throughout: these live next to user config files, and a path with
      # a space would otherwise be split into two nonexistent paths.
      while IFS= read -r -d "" f;do
          drop "$f"
      done < <(
          if [ "$all" = 1 ];then
              find "''${roots[@]}" -type f \
                  \( -name "*.tmp.??????" -o -name "*.backup" \) -print0 2>/dev/null
          else
              find "''${roots[@]}" -type f \
                  \( -name "*.tmp.??????" -o -name "*.backup" \) \
                  -mtime +${toString maxAgeDays} -print0 2>/dev/null
          fi
      )

      # Age alone is not enough: a weekly rebuild cadence leaves a fresh pile
      # behind every time. Per base file, keep the ${toString keep} newest and
      # drop the rest. Skipped entirely for --all, which already took everything.
      if [ "$all" = 0 ];then
          list=$(mktemp)
          trap 'rm -f "$list"' EXIT
          while IFS= read -r base;do
              [ -n "$base" ] || continue
              # -printf '%T@ %p' sorts by mtime without parsing ls output.
              find "$(dirname "$base")" -maxdepth 1 -type f \
                  -name "$(basename "$base").tmp.??????" \
                  -printf '%T@ %p\n' 2>/dev/null \
                  | sort -rn | tail -n +$((${toString keep} + 1)) \
                  | cut -d" " -f2- > "$list"
              # Read from a file, not a pipe: `... | while` runs the loop in a
              # subshell, so every increment of $removed was thrown away and the
              # final tally under-reported by the whole second pass.
              while IFS= read -r old;do drop "$old"; done < "$list"
          done < <(
              find "''${roots[@]}" -type f -name "*.tmp.??????" 2>/dev/null \
                  | sed "s/\.tmp\.[^.]*$//" | sort -u
          )
      fi

      [ "$dry" = 1 ] || echo "config-cleanup: removed $removed file(s)"
    '';
  };
in {
  home.packages = [ cleanupScript ];

  # Runs after activation, which is exactly when the files appear. `|| true`
  # because a cleanup failure must never fail a rebuild.
  home.activation.configCleanup = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${lib.getExe cleanupScript} || true
  '';

  systemd.user.services.config-cleanup = {
    Unit.Description = "Prune home-manager .tmp/.backup leftovers";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe cleanupScript;
    };
  };
  systemd.user.timers.config-cleanup = {
    Unit.Description = "Prune home-manager .tmp/.backup leftovers";
    Timer = {
      OnStartupSec = "5min";
      OnUnitInactiveSec = "1d";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
