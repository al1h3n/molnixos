# Plymouth boot splash.
{ pkgs, ... }:
let
  # ── Switch themes here ───────────────────────────────────────────────────
  #   Options: "abstract_ring" | "green_blocks" | "dna"
  activeTheme = "abstract_ring";
  # ────────────────────────────────────────────────────────────────────────

  # Each theme carries its own pack folder and its own source hash, because the
  # checkout is sparse: adi1090x/plymouth-themes is 287 MB and a single theme is
  # 0.6-3.7 MB, so pulling the whole repo to copy one directory wasted ~280 MB
  # of download and store on every fresh build.
  #
  # `shallow = true` was removed: current nixpkgs fetchgit no longer accepts it
  # (`error: function 'anonymous lambda' called with unexpected argument
  # 'shallow'`), so this file did not even evaluate.
  #
  # After changing rev or path, rebuild with lib.fakeHash to get the new hash.
  themes = {
    abstract_ring = {
      path = "pack_1/abstract_ring";
      hash = "sha256-L1HFag2uAK/GPMYj4ztI9CGVe+R9Z0LecMbhkjRSw98=";
    };
    green_blocks = {
      path = "pack_2/green_blocks";
      hash = "sha256-NIHbdEOAdx27gZiGC+QKK7hNPL2KACJz75PpilejoB0=";
    };
    dna = {
      path = "pack_2/dna";
      hash = "sha256-JMppXgLmgNgYdYfSx6c+ahTw5d2wmASsry6XwMXCzZI=";
    };
  };

  theme = themes.${activeTheme};

  themePackage = pkgs.stdenvNoCC.mkDerivation {
    pname = "plymouth-theme-${activeTheme}";
    version = "unstable-2023-05-22";

    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "plymouth-themes";
      rev = "master";
      inherit (theme) hash;
      forceFetchGit = true;
      sparseCheckout = [ theme.path ];
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/plymouth/themes
      cp -r ${theme.path} $out/share/plymouth/themes/
      runHook postInstall
    '';
  };
in {
  boot = {
    plymouth = {
      enable = true;
      theme = activeTheme;
      themePackages = [ themePackage ];
    };
    initrd.systemd.enable = true; # note: global change, not just cosmetic.
  };
}

# Script to fetch latest hash
# nix shell nixpkgs#nix-prefetch-git nixpkgs#git nixpkgs#jq -c bash -c '
# REPO="https://github.com/adi1090x/plymouth-themes.git"
# REV=$(git ls-remote "$REPO" HEAD | cut -f1)

# echo "Latest revision: $REV"
# echo

# for theme in \
#   pack_1/abstract_ring \
#   pack_2/green_blocks \
#   pack_2/dna
# do
#   name="${theme##*/}"
#   echo "Fetching $name..."

#   hash=$(nix-prefetch-git \
#     --url "$REPO" \
#     --rev "$REV" \
#     --sparse-checkout "$theme" \
#     --quiet | jq -r ".sha256")

#   sri=$(nix hash convert --hash-algo sha256 --to sri "$hash")

#   echo "$name = {"
#   echo "  path = \"$theme\";"
#   echo "  hash = \"$sri\";"
#   echo "};"
#   echo
# done
# '