{
  description = "My NixOS configurations for multiple platforms";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 1. Add the Antigravity repository input
    antigravity-nix.url = "github:jacopone/antigravity-nix";
  };

  outputs = { self, nixpkgs, home-manager, antigravity-nix }: {
    nixosConfigurations = {
      lenovo-x1-g11 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # 2. Pass the input into your modules using specialArgs
        specialArgs = { inherit antigravity-nix; };
        modules = [
          ./modules
          ./targets/lenovo-x1-g11
          home-manager.nixosModules.home-manager

          # 3. Add the unfree and package configuration inline (or move to ./modules)
          ({ pkgs, ... }: {
            nixpkgs.config.allowUnfree = true;
            environment.systemPackages = [
              antigravity-nix.packages.x86_64-linux.google-antigravity
              antigravity-nix.packages.x86_64-linux.google-antigravity-ide
              antigravity-nix.packages.x86_64-linux.google-antigravity-cli
            ];
          })
        ];
      };
      lenovo-x1-g13 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # 2. Pass the input into your modules using specialArgs
        specialArgs = { inherit antigravity-nix; };
        modules = [
          ./modules
          ./targets/lenovo-x1-g13
          home-manager.nixosModules.home-manager

          # 3. Add the unfree and package configuration inline (or move to ./modules)
          ({ pkgs, ... }: {
            nixpkgs.config.allowUnfree = true;
            environment.systemPackages = [
              antigravity-nix.packages.x86_64-linux.google-antigravity
              antigravity-nix.packages.x86_64-linux.google-antigravity-ide
              antigravity-nix.packages.x86_64-linux.google-antigravity-cli
            ];
          })
        ];
      };

      seclab-beast = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # 2. Pass the input into your modules using specialArgs
        specialArgs = { inherit antigravity-nix; };
        modules = [
          ./modules
          ./targets/seclab-beast
          home-manager.nixosModules.home-manager

          # 3. Add the unfree and package configuration inline (or move to ./modules)
          ({ pkgs, ... }: {
            nixpkgs.config.allowUnfree = true;
            environment.systemPackages = [
              antigravity-nix.packages.x86_64-linux.google-antigravity
              antigravity-nix.packages.x86_64-linux.google-antigravity-ide
              antigravity-nix.packages.x86_64-linux.google-antigravity-cli
            ];
          })
        ];
      };
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}
