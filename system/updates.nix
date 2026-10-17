# Updates, schedule, maintenance and performance.
{ pkgs, lib, nur, ... }: {
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flags = [
      "--update-input" "nix-cachyos-kernel"
      "--update-input" "nixpkgs"
      "--commit-lock-file"
    ];
  };
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0; # All cores

      # Binary caches.
      substituters = [
        "https://nixos.org"
        "https://cachix.org"
        "https://cachix.org"
        "https://cachix.org"
        "https://xuyh0120.win"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
      trusted-users = [ "root" "@wheel" ];
    };
  };
}