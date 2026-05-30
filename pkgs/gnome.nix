{ pkgs, ... }: {
  services.desktopManager.gnome.enable = true;
  services.gnome = {
    core-apps.enable = false;
    core-developer-tools.enable = false;
    games.enable = false;
  };
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    cheese        # webcam tool
    gedit         # text editor
    epiphany      # web browser
    geary         # email reader
    totem         # video player
    tali          # poker game
    iagno         # go game
    hitori        # sudoku game
    atomix        # puzzle game
  ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions
  ];
}
