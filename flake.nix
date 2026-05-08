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

    # CachyOS repository.
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      # inputs.nixpkgs.follows = "nixpkgs";
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

    # Stylix - can change theme of various applications.
    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # yt-x to watch YouTube in shell. Do NOT accept updates.
    yt-x = {
      url = "github:Benexl/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify - adjust your Spotify with marketplace and plugins.
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	  # LazySpotify - Spotify in terminal.
    # lazyspotify = {
    #    url = "github:dubeyKartikay/lazyspotify";
    #    flake = false; # repo has no flake.nix
    #  };

    # lazyvim - custom configuration for nvim.
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Anifetch - animated logo in fastfetch.
    anifetch = {
      url = "github:Notenlish/anifetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Setrixtui - cool tetris.
    setrixtui = {
      url = "github:Mjoyufull/Setrixtui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Eyedropper to catch a color.
    ie-r = {
      url = "github:miaupaw/ie-r";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Alt + Tab.
    snappy-switcher = {
      url = "github:OpalAayan/snappy-switcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nur, nix-cachyos-kernel,
  yt-x, spicetify, anifetch, setrixtui, lazyvim, ie-r,
  snappy-switcher, hyprland, ... }@inputs:
  let
    variables = import ./variables.nix;
    pkgsSource = if variables.channel == "stable" then nixpkgs-stable else nixpkgs;
    hmSource = if variables.channel == "stable" 
      then inputs.home-manager-stable 
      else inputs.home-manager;
  in {
    nixosConfigurations.main = pkgsSource.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix  # nixOS system-wide configuration.
        hmSource.nixosModules.home-manager # Enables HM module.
        hyprland.nixosModules.default

        { nixpkgs.overlays = [ # Overlays.
          nur.overlays.default
          nix-cachyos-kernel.overlays.pinned
          # (final: prev: { lazyspotify = final.callPackage ./pkgs/lazyspotify.nix { src = inputs.lazyspotify; }; })
        ]; }
        # stylix.nixosModules.stylix
        { # Actual HM config.
          home-manager = {
            extraSpecialArgs = {
              inherit variables inputs;
            }; # Add variable to Home Manager modules (user-defined).
          
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${variables.username} = import ./home/home.nix;
            backupFileExtension = "backup";
            sharedModules = [
              spicetify.homeManagerModules.spicetify
              lazyvim.homeManagerModules.default
            ];
          };
        }
      ];
    };
  };
}
