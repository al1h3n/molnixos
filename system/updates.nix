# Updates, schedule, maintenance and performance.
{ pkgs, lib, ... }: {
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flags = [
      "--update-input" "hyprland"
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
        "https://hyprland.cachix.org?priority=25"
        "https://nix-community.cachix.org?priority=30"
        "https://attic.xuyh0120.win/lantian?priority=31"
        "https://cache.garnix.io?priority=32"
        "https://cache.nixos.org" # Priority = 40.
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}