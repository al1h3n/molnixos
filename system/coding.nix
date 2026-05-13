{ ... }: {
  environment.systemPackages = with pkgs; [
    gnumake gcc
    python3 pipx
    temurin-bin-8 temurin-bin-21 temurin-bin-25
  ];
}