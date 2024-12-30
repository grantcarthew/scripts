{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = {
    nixpkgs,
    ghostty,
    ...
  }: {
    nixosConfigurations.mysystem = nixpkgs.lib.nixosSystem {
      modules = [
        {
          environment.systemPackages = [
            ghostty.packages.x86_64-linux.default
          ];
        }
      ];
    };
  };
}

