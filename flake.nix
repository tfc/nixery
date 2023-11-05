{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    perSystem = { config, self', inputs', pkgs, system, ... }: {
      packages = {
        nixery = pkgs.callPackage ./package.nix {
          inherit (config.packages) nixery-prepare-image;
        };
        nixery-prepare-image = pkgs.callPackage ./prepare-image { };
        nixery-popcount = pkgs.callPackage ./popcount { };
      };

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.jq
          config.packages.nixery-prepare-image
        ];
        inputsFrom = [ config.packages.nixery ];
      };
    };
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
  };
}
