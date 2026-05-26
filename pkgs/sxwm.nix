{ pkgs, lib, ... }:
let
  sxwm = pkgs.callPackage ./sxwm.nix {
    src = pkgs.fetchFromGitHub {
      owner = "uint23";
      repo  = "sxwm";
      rev   = "master";
      hash  = "sha256-jeOwahG5oNtAKAZTNlddCwzE3ZY9+apU8Lw2JQErB7k=";
    };
  };
in { environment.systemPackages = [ sxwm ]; }