{ inputs, pkgs, ... }: {
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ inputs.nix-proton-cachyos.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos ];
# Steam → Settings → Compatibility → Enable Steam Play for all other titles → select Proton-CachyOS from the dropdown.
    };
    gamemode.enable = true; # Needs to be manually run with gamemoderun
  };
}