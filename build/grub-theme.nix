# Graphite GRUB2 theme. Not imported by configuration.nix - add it there to use.
{ pkgs, ... }:
let
  graphiteGrubTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "graphite-grub2-theme";
    version = "unstable";

    # Only other/grub2 is needed; Graphite-gtk-theme is a full GTK theme repo,
    # so a sparse checkout avoids fetching the GTK assets we never look at.
    #
    # `shallow = true` was removed: current nixpkgs fetchgit rejects it with
    # `unexpected argument 'shallow'`, so this file did not evaluate at all.
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Graphite-gtk-theme";
      rev = "364173f47407164948788e4abb5e2eb46600f71a";
      hash = "sha256-RN+Tvcm7ku44Cz5nadN2lt9+JABxZjluxoALTaoEl7Q=";
      forceFetchGit = true;
      sparseCheckout = [ "other/grub2" ];
    };

    dontBuild = true;
    dontConfigure = true;

    # $out does not exist yet at this point, so the old `cp -r other/grub2/. $out`
    # failed with "cannot create directory". mkdir first.
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r other/grub2/. $out
      cp $out/config/theme-2k.txt $out/theme.txt
      runHook postInstall
    '';
  };
in {
  boot.loader.grub = {
    theme = graphiteGrubTheme;

    # theme-2k.txt is drawn for 2560x1440. GRUB_GFXMODE= is /etc/default/grub
    # syntax from Debian-style setups; boot.loader.grub.extraConfig is appended
    # to grub.cfg, which is GRUB script, so that line was simply ignored. These
    # are the options NixOS actually reads.
    gfxmodeEfi = "2560x1440";
    gfxmodeBios = "2560x1440";
  };
}

# nix-shell -p git nix-prefetch-git jq --run '
# REV=$(git ls-remote https://github.com/vinceliuice/Graphite-gtk-theme.git HEAD | cut -f1)
# RESULT=$(nix-prefetch-git \
#   --url https://github.com/vinceliuice/Graphite-gtk-theme.git \
#   --rev "$REV" \
#   --sparse-checkout other/grub2)

# HASH=$(echo "$RESULT" | jq -r .sha256)
# SRI=$(nix hash convert --hash-algo sha256 --to sri "$HASH")

# echo "rev = \"$REV\";"
# echo "hash = \"$SRI\";"
# '