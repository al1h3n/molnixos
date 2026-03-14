# Symlinks
{ config, variables, ... }: {
  home.activation.molniosLinks = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.local/share/molnios
    ln -sfn ${toString variables.shared} $HOME/.local/share/molnios/config
    ln -sfn ${toString variables.shared_root}/scripts $HOME/.local/share/molnios/scripts
    ln -sfn ${toString variables.shared_root}/images $HOME/.local/share/molnios/images
    ln -sfn ${toString variables.shared_root}/sfx $HOME/.local/share/molnios/sfx
    ln -sfn ${toString variables.media} $HOME/.local/share/molnios/molnios-media/wallpapers
  '';
}