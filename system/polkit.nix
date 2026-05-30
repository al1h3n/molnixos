# polkit.nix - Polkit configuration.
# Switch between polkit-hypr.nix and polkit-gnome.nix by commenting/uncommenting.
{ pkgs, ... }: {
  imports = [
    ./packages/polkit-gnome.nix
  ];

  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("program") == "${pkgs.tlp}/bin/tlp" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}