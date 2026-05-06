{ pkgs, ... }: {
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa # Music player
    konversation # IRC client
    kpat # Solitaire
    kmahjongg
    ksudoku
    ktorrent
    # oxygen # Uncomment to remove oxygen style
  ];
}
