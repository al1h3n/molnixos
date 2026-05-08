{ pkgs, ... }:
let
  # ── Switch themes here ───────────────────────────────────────────────────
  #   Options: "abstract_ring" | "green_blocks" | "dna"
  activeTheme = "abstract_ring";
  # ────────────────────────────────────────────────────────────────────────

  # Fetch the repo once — only the selected theme folder gets installed
  plymouthThemesSrc = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "5d8817458d764bff4ff9daae94cf1bbaabf16ede";
    hash = "sha256-e3lRgIBzDkKcWEp5yyRCzQJM6yyTjYC5XmNUZZroDuw=";
  };

  # Map each theme name to its pack folder in the repo
  themeIndex = {
    abstract_ring = "pack_1";
    green_blocks = "pack_2";
    dna = "pack_2";
  };

  # Build a minimal derivation that exposes only the chosen theme
  mkTheme = name: pkgs.stdenv.mkDerivation {
    pname   = "plymouth-theme-${name}";
    version = "unstable";
    src     = plymouthThemesSrc;

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/plymouth/themes
      cp -r ${themeIndex.${name}}/${name} $out/share/plymouth/themes/
      runHook postInstall
    '';
  };
in {
  boot = {
    plymouth = {
      enable = true;
      theme = activeTheme;
      themePackages = [ (mkTheme activeTheme) ];
    };
    initrd.systemd.enable = true;
  };
}