{ inputs, pkgs, ... }: {
  programs = {
    steam.enable = true;
    gamemode.enable = true; # Needs to be manually run with gamemoderun
  };
}
