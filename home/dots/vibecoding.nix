{ lib, pkgs, ... }:
let
  # Agents the skills are linked into.
  agents = [ "claude-code" "opencode" ];

  # Pinned so `npx` never has to hit the npm registry to resolve a version
  # on every sync run. Bump deliberately.
  skillsCli = "skills@1.5.24"; # npm view skills version

  # Canonical on-disk store the `skills` CLI writes to; agent dirs
  # (~/.claude/skills, ~/.config/opencode/...) are symlinks into this.
  # Kept unquoted here and quoted at each use site.
  skillsStore = ''$HOME/.agents/skills'';

  # Accepts either a bare "owner/repo" string (install every skill it
  # exposes) or { repo; skill | skills; }.
  normalizeSkillEntry = entry:
    if builtins.isString entry
    then { repo = entry; skills = [ ]; }
    else {
      repo = entry.repo;
      skills =
        if entry ? skills then (if builtins.isList entry.skills then entry.skills else [ entry.skills ])
        else if (entry.skill or null) != null then (if builtins.isList entry.skill then entry.skill else [ entry.skill ])
        else [ ];
    };

  skills = [
    # Discovery & Meta
    { repo = "vercel-labs/skills"; skill = "find-skills"; }

    # NixOS & Systems
    { repo = "lihaoze123/my-claude-code"; skill = "nixos-best-practices"; }
    { repo = "apollographql/skills"; skill = "rust-best-practices"; }

    # Web & Full-Stack Best Practices
    { repo = "vercel-labs/agent-skills"; skills = [ "vercel-react-best-practices" "frontend-design" ]; }
    { repo = "addyosmani/web-quality-skills"; skill = "best-practices"; }
    { repo = "addyosmani/agent-skills"; skill = "ci-cd-and-automation"; }
    # The CLI auto-discovers the skill's nested path inside the repo; no
    # tree-URL or full clone needed.
    { repo = "jwynia/agent-skills"; skill = "electron-best-practices"; }
    # `partme-ai/full-stack-skills` no longer ships a SKILL.md. The skills
    # moved to dedicated repos under the `full-stack-skills` org.
    { repo = "full-stack-skills/electron-skills"; skill = "electron"; }
    { repo = "full-stack-skills/tauri-skills"; skill = "tauri"; }

    # Matt Pocock Skills (multi-skill bundle)
    {
      repo = "mattpocock/skills";
      skills = [
        "ask-matt"
        "diagnosing-bugs"
        "grill-me"
        "grill-with-docs"
        "improve-codebase-architecture"
      ];
    }

    # Code Quality, Auditing & Review
    { repo = "cursor/plugins"; skill = "thermo-nuclear-code-quality-review"; }
    { repo = "shadcn/improve"; skill = "improve"; }

    # Roblox
    { repo = "sentinelcore/roblox-skills"; skill = "roblox-animations"; }
    { repo = "tabooharmony/roblox-brain"; skill = "roblox-npc-ai"; }

    # Personas & Agent Modes
    { repo = "juliusbrussee/caveman"; skill = "caveman"; }
    # `godmode` lives under `optional-skills/`, which the CLI does not
    # auto-scan, so it needs a tree URL pointing straight at the skill dir.
    { repo = "https://github.com/NousResearch/hermes-agent/tree/main/optional-skills/security/godmode"; skill = "godmode"; }
    { repo = "axelfreeman/marketing-mindset"; skill = "marketing-mindset"; }
    { repo = "dietrichgebert/ponytail"; skill = "ponytail"; }

    # Repos / Tools / MCP
    "https://uizze.com"
    "rtk-ai/rtk"
    { repo = "github/awesome-copilot"; skill = "codebase-memory-mcp"; }
  ];

  # Changing the manifest changes this hash, which is what triggers a
  # re-sync (see the systemd service below).
  skillsHash = builtins.hashString "sha256" (builtins.toJSON skills);

  addCmd = repo: skillList:
    "npx --yes ${skillsCli} add ${lib.escapeShellArg repo}"
    + lib.concatMapStrings (s: " --skill ${lib.escapeShellArg s}") skillList
    + " --global"
    + lib.concatMapStrings (a: " --agent ${lib.escapeShellArg a}") agents
    + " --yes";

  # One shell block per manifest entry. Each block is a no-op once its
  # skills exist on disk, so a retry after a partial failure only touches
  # what is still missing. Any failure sets `failed=1`.
  installSkill = rawEntry:
    let
      entry = normalizeSkillEntry rawEntry;
      slug = lib.replaceStrings [ "/" ":" ] [ "_" "_" ] entry.repo;
    in
      if entry.skills != [ ] then ''
        if ! { ${lib.concatMapStringsSep " && " (s: ''test -d "${skillsStore}/${s}"'') entry.skills}; }; then
          echo "agent-skills: installing ${entry.repo} (${lib.concatStringsSep ", " entry.skills})"
          ${addCmd entry.repo entry.skills} || { echo "agent-skills: FAILED ${entry.repo}" >&2; failed=1; }
        fi
      '' else ''
        if [ ! -e "$STATE_DIR/markers/${slug}" ]; then
          echo "agent-skills: installing ${entry.repo} (all skills)"
          if ${addCmd entry.repo [ ]}; then
            touch "$STATE_DIR/markers/${slug}"
          else
            echo "agent-skills: FAILED ${entry.repo}" >&2; failed=1
          fi
        fi
      '';

  syncScript = pkgs.writeShellApplication {
    name = "agent-skills-sync";
    runtimeInputs = [ pkgs.nodejs pkgs.git pkgs.coreutils ];
    text = ''
      STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/agent-skills"
      HASH_FILE="$STATE_DIR/installed-skills.sha256"
      CURRENT_HASH="${skillsHash}"
      mkdir -p "$STATE_DIR/markers"

      if [ -f "$HASH_FILE" ] && [ "$(cat "$HASH_FILE")" = "$CURRENT_HASH" ]; then
        echo "agent-skills: manifest unchanged, nothing to do"
        exit 0
      fi

      failed=0
      ${lib.concatMapStringsSep "\n" installSkill skills}

      if [ "$failed" -eq 0 ]; then
        printf '%s\n' "$CURRENT_HASH" > "$HASH_FILE"
        echo "agent-skills: sync complete, manifest hash recorded"
      else
        echo "agent-skills: some installs failed; hash not recorded, will retry" >&2
        exit 1
      fi
    '';
  };
in {
  # Off the activation / boot critical path: a oneshot fired 2 min after
  # login and retried hourly. Gated by the manifest hash, so steady-state
  # runs are an instant no-op with no network access. A failed run (no
  # network yet, transient clone error) leaves the hash unwritten and is
  # retried on the next hourly tick.
  systemd.user.services.agent-skills-sync = {
    Unit.Description = "Sync agent skills from the vibecoding manifest";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe syncScript;
    };
  };
  systemd.user.timers.agent-skills-sync = {
    Unit.Description = "Sync agent skills from the vibecoding manifest";
    Timer = {
      OnStartupSec = "2min";
      OnUnitInactiveSec = "1h";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  programs = {
    opencode = {
      enable = true;
      web.enable = true;
      settings.plugin = [ "@ex-machina/opencode-anthropic-auth" ];
    };
    claude-code = {
      enable = true;
      settings = {
        theme = "dark";
        permissions = {
          defaultMode = "acceptEdits";
          allow = [
            "Bash(git diff:*)"
            "Bash(git status:*)"
            "Edit"
          ];
        };
      };
    };
  };
}