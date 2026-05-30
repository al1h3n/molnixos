{ pkgs, ... }: {
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    ark # File archiver
    elisa # Music player
    dolphin # File manager
    konversation # IRC client
    kpat # Solitaire
    kmahjongg
    kwalletmanager
    kate # Editor
    konsole
    qrca # Code scanner
    gwenview # Image viewer
    khelpcenter
    ksudoku
    ktorrent
    oxygen # Uncomment to remove oxygen style
    okular
  ];
}