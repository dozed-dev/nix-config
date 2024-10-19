{
  description = "Your new nix config. Taken from https://github.com/Misterio77/nix-starter-configs";

  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable-old.url = "nixpkgs/ad416d066ca1222956472ab7d0555a6946746a80";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Minecraft server
    qiwi-minecraft-modpack.url = "github:dozed-dev/qiwi-modpack";

    # Fjord launcher
    fjordlauncher.url = "github:unmojang/FjordLauncher";

    # bol-van/zapret (DPI bypass)
    zapret = {
      url = "github:aca/zapret-flake.nix";
      inputs.zapret-src = {
        url = "github:bol-van/zapret";
        flake = false;
      };
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    syberant-nur = {
      url = "github:syberant/nur-packages";
      flake = false;
    };
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    chaotic,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      home-desktop = let
        nixpkgs = inputs.nixpkgs-stable;
      in nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [./nixos/home-desktop/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "quitzka@home-desktop" = let
        nixpkgs = inputs.nixpkgs-stable;
        home-manager = inputs.home-manager-stable;
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home-desktop/home.nix];
      };
    };
  };
}
