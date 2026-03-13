# Symlinks
{ config, variables, ... }: {
  home.activation.molniosLinks = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.local/share/molnios

    ln -sfn ${toString variables.shared} $HOME/.local/share/molnios/config
    ln -sfn ${toString variables.shared_root}/scripts $HOME/.local/share/molnios/scripts
    ln -sfn ${toString variables.shared_root}/sfx $HOME/.local/share/molnios/sfx
    ln -sfn ${toString variables.media} $HOME/.local/share/molnios/wallpapers
    ln -sfn ${toString variables.shared_root}/molnix-media $HOME/.local/share/molnios/media

    mkdir -p $HOME/.config/waypaper
    if [ ! -f $HOME/.config/waypaper/config.ini ];then
      cp ${toString variables.waypaper} $HOME/.config/waypaper/config.ini
      chmod 644 $HOME/.config/waypaper/config.ini
    fi 
  '';
}