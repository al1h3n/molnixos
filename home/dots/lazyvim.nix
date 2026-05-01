# lazyvim - nvim configuration.
{ ... }: {
  programs.lazyvim = {
    enable = true;
    extras = {
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true; # installs ruff
        installRuntimeDependencies = true; # installs python3
      };
    };
  };
}