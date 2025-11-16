{
    description = "ludihan nix config :^)";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        ...
        } @ inputs: let
            arch = "x86_64-linux";
        in {
            nixosConfigurations = {
                nixos = nixpkgs.lib.nixosSystem {
                    specialArgs = {inherit inputs;};

                    modules = [./nixos/configuration.nix];

                };
            };

            homeConfigurations = {
                "ludihan@nixos" = home-manager.lib.homeManagerConfiguration {
                    pkgs = nixpkgs.legacyPackages.${arch};
                    extraSpecialArgs = {inherit inputs;};

                    modules = [./home-manager/home.nix];

                };
            };
        };
}
