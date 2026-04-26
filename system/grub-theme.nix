{ pkgs, ... }:

let
  graphiteGrubTheme = pkgs.stdenv.mkDerivation {
    name = "graphite-grub2-theme";

    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Graphite-gtk-theme";
      rev = "57028b0bfcc0cfee1ba42273c545e4e269973433";
      hash = "sha256-62SOQb3sQCYN1XU6a48RM18EcTUBEh2x0u+S6z8xEfo=";
    };

    installPhase = ''
      # The theme files live under other/grub2/src/<resolution>/
      # Pick the folder matching your display: 1080p, 2k, or 4k
      cp -r other/grub2/src/2k $out
    '';
  };
in
{
  boot.loader.grub = {
    theme = graphiteGrubTheme;        # <-- this is the key addition
    extraConfig = ''
      GRUB_GFXMODE=2560x1440x32      # match your screen resolution
    '';
  };
}