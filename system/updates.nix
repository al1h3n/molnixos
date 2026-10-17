# Updates, schedule, maintenance and performance.
{ config, ... }:
let
  flakePath = "/etc/nixos/molnixos";
in {
  system.autoUpgrade = {
    enable = true;
    # Use the writable installed checkout, not a source path in /nix/store.
    flake = "${flakePath}#main";
    upgrade = false; # --upgrade only updates channels, not flake inputs.
    dates = "daily";
  };

  # Refresh every input before building; keep flake.lock tracked in Git.
  systemd.services.nixos-upgrade.preStart = ''
    ${config.nix.package}/bin/nix flake update --flake ${flakePath}
  '';

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

      # NixOS supplies cache.nixos.org and its signing key by default.
      # Its priority (40) is ahead of these Cachix caches (41).
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://noctalia.cachix.org"
        # "https://attic.xuyh0120.win/lantian"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
      trusted-users = [ "root" "@wheel" ];
    };
  };
}
