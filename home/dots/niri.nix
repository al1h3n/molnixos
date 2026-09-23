{ variables, pkgs, config, lib, ... }:
let
  niriConfigDir = "${config.xdg.configHome}/niri";
in {
  home.packages = [ pkgs.nirimod ];

  # Niri and nirimod edit config modules at runtime, so they cannot live in a
  # Home Manager-managed symlink. Seed a user-owned copy only when needed.
  home.activation.niriConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    target=${lib.escapeShellArg niriConfigDir}
    source=${lib.escapeShellArg variables.niri}

    if [ -L "$target" ]; then
      case "$(readlink -f "$target")" in
        /nix/store/*|/etc/nixos/shared/*) rm "$target" ;;
      esac
    fi

    if [ ! -e "$target" ]; then
      mkdir -p "$target"
      cp -R "$source"/. "$target"/
    fi
  '';
}
