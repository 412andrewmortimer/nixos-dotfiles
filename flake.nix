{

  description = "My NixOS-WSL flake with Home Manager";

  inputs = {
    nixpkgs.url       = "nixpkgs/nixos-24.11";
    wsl.url           = "github:nix-community/NixOS-WSL";
    home-manager.url  = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs,home-manager, wsl, ... }:
    let
      lib    = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos   = lib.nixosSystem {
          inherit system;
          modules = [
              wsl.nixosModules.default
              ./configuration.nix
              {
                environment.systemPackages = with pkgs; [
                  neovim
		  git
                ];
               }
          ];
        };
       };
       homeConfigurations = {
         nixos= home-manager.lib.homeManagerConfiguration {
	   inherit pkgs;
	   modules = [ ./home.nix ];
	 };
       }; 
    };
}
