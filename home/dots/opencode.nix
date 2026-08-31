{ ... }: {

  programs.opencode = {
    enable = true;
    web.enable = true;

    settings = {
      plugin = [
        "caveman-opencode-plugin"
      ];
    };
  };
}