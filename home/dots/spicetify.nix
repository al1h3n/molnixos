{
  inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  outputs = { self, nixpkgs, spicetify-nix, ... }: {
    homeConfigurations.yourUser = nixpkgs.lib.homeManagerConfiguration {
      modules = [
        spicetify-nix.homeManagerModules.spicetify
        {
          programs.spicetify.enable = true;
        }
      ];
    };
  };
}