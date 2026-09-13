# Per-language nix-shell templates.
#
#   nix-shell ~/.config/shells/rust.nix     # one-off
#   cp ~/.config/shells/rust.nix shell.nix  # per-project
#
# The whole directory is one out-of-store symlink rather than a file-per-entry,
# so adding a language is just dropping a .nix into the shared repo - no rebuild.
{ config, variables, ... }: {
  xdg.configFile."shells" = {
    source = config.lib.file.mkOutOfStoreSymlink variables.shells;
    force = true;
  };
}
