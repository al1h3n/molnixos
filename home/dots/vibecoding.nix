{ lib, pkgs, ... }:
let
  # Agents the skills are linked into. Both are required: the `skills` CLI
  # only picks symlink mode - and so only writes the canonical
  # ~/.agents/skills store - when the targets resolve to more than one skills
  # directory. With claude-code alone it switches to copy mode straight into
  # ~/.claude/skills and never populates the store, which is the only place
  # opencode reads from. Dropping "opencode" here hides every skill from it.
  agents = [ "claude-code" "opencode" ];

  # Pinned so `npx` never has to hit the npm registry to resolve a version
  # on every sync run. Bump deliberately.
  skillsCli = "skills@1.5.25"; # npm view skills version

  # Canonical on-disk store the `skills` CLI writes to. ~/.claude/skills is
  # symlinks into this, and opencode auto-loads it directly.
  # Kept unquoted here and quoted at each use site.
  skillsStore = ''$HOME/.agents/skills'';

  # Every entry names its skills explicitly, as `skill` or `skills`, either a
  # bare string or a list.
  skillNames = entry:
    let names = entry.skills or entry.skill; in
    if builtins.isList names then names else [ names ];

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
    { repo = "ayghri/i-have-adhd"; skill = "i-have-adhd"; }

    # Repos / Tools / MCP
    { repo = "https://uizze.com"; skills = [ "anti-ui-slop" "ui-design" "ui-radar" ]; }
    { repo = "rtk-ai/rtk"; skills = [ "code-simplifier" "issue-triage" "rtk-tdd" ]; }
    { repo = "github/awesome-copilot"; skill = "codebase-memory-mcp"; }
  ];

  allSkillNames = lib.concatMap skillNames skills;

  addCmd = repo: skillList:
    "npx --yes ${skillsCli} add ${lib.escapeShellArg repo}"
    + lib.concatMapStrings (s: " --skill ${lib.escapeShellArg s}") skillList
    + " --global"
    + lib.concatMapStrings (a: " --agent ${lib.escapeShellArg a}") agents
    + " --yes";

  # One shell block per manifest entry. Each block is a no-op once its
  # skills exist on disk, so a retry after a partial failure only touches
  # what is still missing and a steady-state run spawns no `npx` at all.
  # Any failure sets `failed=1`.
  installSkill = entry: ''
    if ! { ${lib.concatMapStringsSep " && " (s: ''test -d "${skillsStore}/${s}"'') (skillNames entry)}; }; then
      echo "agent-skills: installing ${entry.repo} (${lib.concatStringsSep ", " (skillNames entry)})"
      ${addCmd entry.repo (skillNames entry)} || { echo "agent-skills: FAILED ${entry.repo}" >&2; failed=1; }
    fi
  '';

  syncScript = pkgs.writeShellApplication {
    name = "agent-skills-sync";
    runtimeInputs = [ pkgs.nodejs pkgs.git pkgs.coreutils pkgs.findutils ];
    text = ''
      failed=0

      # Dropping an entry from the manifest has to actually uninstall it,
      # otherwise the manifest can only ever grow.
      keep=(${lib.concatStringsSep " " (map lib.escapeShellArg allSkillNames)})
      for dir in "${skillsStore}"/*/; do
        [ -d "$dir" ] || continue
        name=$(basename "$dir")
        if [[ " ''${keep[*]} " != *" $name "* ]]; then
          echo "agent-skills: removing $name (no longer in manifest)"
          rm -rf "$dir"
        fi
      done
      # Sweep the agent links the removals above left dangling.
      find "$HOME/.claude/skills" -maxdepth 1 -xtype l -delete 2>/dev/null || true

      ${lib.concatMapStringsSep "\n" installSkill skills}

      if [ "$failed" -eq 0 ]; then
        echo "agent-skills: sync complete"
      else
        echo "agent-skills: some installs failed, will retry" >&2
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
      # web.enable = true; # just use 'opencode web' instead.
      settings = {
        plugin = [ "@ex-machina/opencode-anthropic-auth" ];
        permission = {
          "*" = "allow";
        };
      };
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