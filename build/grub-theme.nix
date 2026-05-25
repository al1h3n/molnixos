{ pkgs, ... }:

let
  graphiteGrubTheme = pkgs.stdenv.mkDerivation {
    name = "graphite-grub2-theme";

    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Graphite-gtk-theme";
      rev = "57028b0bfcc0cfee1ba42273c545e4e269973433";
      hash = "sha256-62SOQb3sQCYN1XU6a48RM18EcTUBEh2x0u+S6z8xEfo=";
      forceFetchGit = true;
      shallow = true;
    };

    installPhase = ''
      cp -r other/grub2/. $out
      cp $out/config/theme-2k.txt $out/theme.txt
    '';
  };
in
{
  boot.loader.grub = {
    theme = graphiteGrubTheme;        # <-- this is the key addition
    extraConfig = ''
      GRUB_GFXMODE=auto
    '';
  };
}