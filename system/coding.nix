{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnumake gcc
    python3
    (pipx.overridePythonAttrs (old: { doCheck = false; })) # Use to download packages not available in nixpkgs.
    # uv # Use instead of pip in projects where you have a lot of dependencies.
    temurin-bin-8 temurin-bin-21 temurin-bin-26
    cargo nodejs_24 # nodejs-slim_24.npm, npx skills require nodejs + npm.
  ];
}