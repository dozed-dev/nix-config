{
  description = "Your new nix config. Taken from https://github.com/Misterio77/nix-starter-configs";

  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Disko
    
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    t480-fp-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.darwin.follows = ""; # disable macos for faster download
    };

    # microvm
    microvm.url = "github:astro/microvm.nix";

    # Minecraft server
    #qiwi-minecraft-modpack.url = "github:dozed-dev/qiwi-modpack";

    # Fjord launcher
    fjordlauncher.url = "github:unmojang/FjordLauncher";
    drasl.url = "github:unmojang/drasl";

    syberant-nur = {
      url = "github:syberant/nur-packages";
      flake = false;
    };
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self, ...
  } @ inputs: let
    inherit (self) outputs;
  in {

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      home-desktop = let
        nixpkgs = inputs.nixpkgs-unstable;
      in nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [./nixos/home-desktop/configuration.nix];
      };
      lappy = let
        nixpkgs = inputs.nixpkgs-unstable;
      in nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [./nixos/lappy/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "quitzka@home-desktop" = let
        home-manager = inputs.home-manager-unstable;
        nixpkgs = home-manager.inputs.nixpkgs;
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home-desktop/home.nix];
      };
      "quitzka@lappy" = let
        home-manager = inputs.home-manager-unstable;
        nixpkgs = home-manager.inputs.nixpkgs;
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/lappy/home.nix];
      };
    };
  };
}
