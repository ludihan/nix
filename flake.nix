{
  description = "ludihan nix config :^)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    templates.url = "github:nixos/templates";
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        #nixos = nixpkgs.lib.nixosSystem {
        #    specialArgs = {inherit inputs;};

        #    modules = [./nixos/configuration.nix];

        #};
        nixos-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/desktop
          ];

        };
        nixos-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/laptop
          ];

        };
      };

      homeConfigurations = {
        "ludihan@nixos-desktop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./hosts/desktop/home.nix
          ];
        };
        "ludihan@nixos-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./hosts/laptop/home.nix
          ];
        };
      };
      inherit (inputs) templates;
    };
}
