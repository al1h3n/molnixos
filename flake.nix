# flake.nix
{
  description = "Local (user) configuration for MolniOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # NUR - Nix User Repository, for packages that aren't in nixpkgs. Similar to AUR.
    # Used for Firefox extensions.
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apple Fonts, SF Pro NUR package.
    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # yt-x to watch YouTube in shell.
    yt-x = {
      url = "github:Benexl/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-stable, nur, yt-x, ... }@inputs:
  let
    variables = import ./variables.nix;
    pkgsSource = if variables.channel == "stable" then nixpkgs-stable else nixpkgs;
    hmSource = if variables.channel == "stable" 
      then inputs.home-manager-stable 
      else inputs.home-manager;

    overlay-notion = final: prev: {
    notion-app-electron = final.stdenv.mkDerivation rec {
      pname = "notion-app-electron";
      version = "latest";

      src = final.fetchFromGitHub {
        owner = "notion-enhancer";
        repo = "notion-app-electron";
        rev = "main";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };

      nativeBuildInputs = with final; [ makeWrapper ];
      buildInputs = with final; [ electron ];

      installPhase = ''
        mkdir -p $out/bin $out/share/notion-app-electron

        cp -r * $out/share/notion-app-electron

        makeWrapper ${final.electron}/bin/electron $out/bin/notion-app-electron \
          --add-flags "$out/share/notion-app-electron"
      '';
      };
    };
  in {
    nixosConfigurations.main = pkgsSource.lib.nixosSystem {
      system = variables.system;
      modules = [
        { nixpkgs.overlays = [ nur.overlays.default overlay-notion ]; }
        hmSource.nixosModules.home-manager
        ./configuration.nix
        {
          home-manager = {
            extraSpecialArgs = {
              inherit variables inputs;
            }; # Add variable to Home Manager modules (user-defined).
          
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${variables.username} = import ./home/home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}