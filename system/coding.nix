# Only toolchains that something on the running system actually calls.
# Compilers and build tools live in ~/.config/shells/*.nix instead - see
# home/dots/shells.nix.
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Hard dependency of the shared scripts: shazam.sh, brightness.sh and
    # menu/custom/modules/niri.sh all pipe JSON through `python3 -c`. They run
    # from compositor keybinds, so a dev shell cannot cover them.
    python3

    # opencode shells out to npm to install its plugins
    # (@ex-machina/opencode-anthropic-auth), and the fish `ag` function runs
    # `npx --yes skills`. agent-skills-sync does NOT need this - it carries its
    # own nodejs in runtimeInputs.
    nodejs_24

    # Removed, no caller on this machine (no ~/.cargo, ~/go, ~/.local/share/pipx,
    # and no Cargo.toml/go.mod/CMakeLists.txt/Makefile anywhere in $HOME):
    #   gnumake gcc -> shells/cpp.nix (stdenv provides both)
    #   cargo       -> shells/rust.nix (it also dragged in a rustc it never exposed)
    #   pipx        -> shells/python.nix (uv, with real per-project venvs)
  ];
}
