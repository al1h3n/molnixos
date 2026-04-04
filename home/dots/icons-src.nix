{ pkgs, ... }:
{
  we10x = pkgs.stdenv.mkDerivation {
    name = "we10x-black-dark-icons";
    src = builtins.fetchTarball {
      url = "https://github.com/yeyushengfan258/We10X-icon-theme/archive/master.tar.gz";
    };
    nativeBuildInputs = [ pkgs.gtk3 pkgs.gtk4 ];
    dontCheckForBrokenSymlinks = true;
    installPhase = ''
      mkdir -p $out/share/icons
      # Patch the script so it can find bash in the Nix sandbox
      patchShebangs install.sh
      ./install.sh -d $out/share/icons -t black
      for theme in $out/share/icons/*; do
        gtk-update-icon-cache -q "$theme" || true
      done
    '';
  };

  mactahoe = pkgs.stdenv.mkDerivation {
    name = "mactahoe-icons";
    src = builtins.fetchTarball {
      url = "https://github.com/vinceliuice/MacTahoe-icon-theme/archive/main.tar.gz";
    };
    nativeBuildInputs = [ pkgs.gtk3 pkgs.gtk4 ];
    dontCheckForBrokenSymlinks = true;
    installPhase = ''
      mkdir -p $out/share/icons
      patchShebangs install.sh
      ./install.sh -d $out/share/icons -t default    
      for theme in $out/share/icons/*; do
        gtk-update-icon-cache -q "$theme" || true
      done
    '';
  };
}