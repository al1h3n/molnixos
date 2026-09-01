{ config, pkgs, ... }: {
  programs.claude-code = {
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

    skills = {
      # Local skill
      # my-skill = ./skills/my-skill;

      # Or a single SKILL.md
      # my-other-skill = ./skills/my-other-skill/SKILL.md;
    };
  };
}