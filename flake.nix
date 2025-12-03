{
  description = "My NixOS configurations for multiple platforms";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      # Configuration for the first platform
      lenovo-x1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; 
        modules = [
          ./modules
          ./targets/lenovo-x1 
        ];
      };

      # Configuration for the second platform
      ryzen-threadripper = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; 
        modules = [
          ./modules
          ./targets/ryzen-threadripper 
        ];
      };
    };
  };
}

