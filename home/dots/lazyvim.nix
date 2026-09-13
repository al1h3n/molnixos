# lazyvim - nvim configuration.
# You can't join xdg.configFile."nvim" = {}; in user modules.
{ lib, config, variables, ... }:
let
  sym = rel: lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${variables.shared}/lazyvim/${rel}");
  mkLangSet = lang: lib.setAttrByPath [ "lang" lang ] {
    enable = true;
    installDependencies = true;
    installRuntimeDependencies = true;
  };

  # Supports everything in LazyExtras.
  #
  # VSCodium is the IDE here, nvim edits configs - so only the extras that are
  # actually worth a closure stay on. Each entry pulls its whole toolchain into
  # the nvim wrapper's PATH (lang.go alone adds go + delve + golangci-lint +
  # gomodifytags + impl), and with no Go/Rust/C++/Python project anywhere in
  # $HOME that is pure weight. Uncomment one to get its LSP back in nvim.
  #
  # lang.nix is free: lazyvim-nix has no entry for it, so it installs nothing
  # and relies on nixd/nixpkgs-fmt from the user profile (home/dots/lsp/nix.nix).
  #
  # Note: lang.cmake is what put python3 on the nvim wrapper's PATH, not
  # lang.python. Harmless to drop, python3 stays in environment.systemPackages.
  langList = [
    "nix"
    "json"
    # "python"
    # "rust"
    # "go"
    # "clangd"
    # "cmake"
  ];
  allLangs = lib.foldl' lib.recursiveUpdate {} (map mkLangSet langList);
in {
  programs.lazyvim = {
    # Available options "github.com/pfassina/lazyvim-nix/blob/main/nix/options.nix"
    enable = true;
    extras = allLangs;
  };
  xdg.configFile."nvim/lua/plugins/theme.lua".source = sym "theme.lua";
  xdg.configFile."nvim/lua/plugins/dashboard.lua".source = sym "dashboard.lua";
  xdg.configFile."nvim/lua/config/autocmds.lua".source = sym "autocmds.lua";
}