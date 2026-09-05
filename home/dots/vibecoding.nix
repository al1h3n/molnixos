{ lib, pkgs, ... }:
let
  agents = [ "claude-code" "opencode" ];

  normalizeSkillEntry = entry:
    if builtins.isString entry
    then { repo = entry; skill = null; }
    else entry;
  skills = [
    "vercel-labs/skills"
    { repo = "vercel-labs/agent-skills"; skill = "frontend-design"; }
  ];
  installSkill = { repo, skill }:
  "${pkgs.nodejs-slim.npm}/bin/npx skills add ${lib.escapeShellArg repo}"
  + lib.optionalString (skill != null) " --skill ${lib.escapeShellArg skill}"
  + " --global"
  + lib.concatMapStringsSep " " (agent: "--agent ${lib.escapeShellArg agent}") agents
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