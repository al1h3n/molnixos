# polkit.nix - Polkit configuration.
# Switch between polkit-hypr.nix and polkit-gnome.nix by commenting/uncommenting.
{ ... }: {
  imports = [
    ./packages/polkit-gnome.nix
  ];

  security.polkit = {
    enable = true;
    # extraConfig = ''
    #   // Allow wheel group to run TLP without authentication
    #   polkit.addRule(function(action, subject) {
    #     if (
    #       (action.id === "org.freedesktop.policykit.exec") &&
    #       subject.isInGroup("wheel")
    #     ) {
    #       var cmd = action.lookup("command");
    #       var tlpBin = "${pkgs.tlp}/bin/tlp";

    #       if (cmd && (
    #         cmd.indexOf(tlpBin) === 0 ||
    #         cmd.indexOf("/run/current-system/sw/bin/tlp") === 0
    #       )) {
    #         return polkit.Result.YES;
    #       }
    #     }
    #   });
    # '';
  };
}