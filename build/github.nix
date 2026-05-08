{ ... }: {
  nix.settings.extra-allowed-uris = [
    "https://objects.githubusercontent.com"
    "https://release-assets.githubusercontent.com"
  ];
}