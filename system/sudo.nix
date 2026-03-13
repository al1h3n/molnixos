{ pkgs, ... }: {
  security.sudo = {
      enable = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl suspend";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.neovim}/bin/nvim";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/systemctl";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/ln";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/nix-channel";
              options = ["NOPASSWD"];
            }
          ];
          groups = ["wheel"];
        }
      ];
  };
}