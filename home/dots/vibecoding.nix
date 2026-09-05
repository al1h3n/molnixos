{ lib, pkgs, ... }:
let
  agents = [ "claude-code" "opencode" ];
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
    {
      repo = "vercel-labs/agent-skills";
      skills = [
        "frontend-design"
        "vercel-react-best-practices"
      ];
    }
    { repo = "addyosmani/web-quality-skills"; skill = "best-practices"; }
    { repo = "addyosmani/agent-skills"; skill = "ci-cd-and-automation"; }
    { repo = "jwynia/agent-skills"; skill = "electron-best-practices"; }
    { repo = "partme-ai/full-stack-skills"; skill = "electron"; }

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
    { repo = "nousresearch/hermes-agent"; skill = "godmode"; }
    { repo = "axelfreeman/marketing-mindset"; skill = "marketing-mindset"; }
    { repo = "dietrichgebert/ponytail"; skill = "ponytail"; }

    # Repos / Tools / MCP
    "https://uizze.com"
    "rtk-ai/rtk"
    { repo = "github/awesome-copilot"; skill = "codebase-memory-mcp"; }
  ];

  installSkill = rawEntry:
    let
      entry = normalizeSkillEntry rawEntry;
    in
      "${pkgs.nodejs-slim.npm}/bin/npx --yes skills add ${lib.escapeShellArg entry.repo}"
      + lib.concatMapStrings (s: " --skill ${lib.escapeShellArg s}") entry.skills
      + " --global"
      + lib.concatMapStrings (agent: " --agent ${lib.escapeShellArg agent}") agents
      + " --yes";
in {
  home.activation.installSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.concatMapStringsSep "\n" (skill: ''
      run ${installSkill skill}
    '') skills}
  '';

  programs = {
    opencode = {
      enable = true;
      web.enable = true;
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