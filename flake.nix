{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    perSystem = { config, pkgs, ... }: {
      packages = {
        default = config.packages.nixery;

        nixery = pkgs.callPackage ./package.nix {
          inherit (config.packages) nixery-prepare-image;
        };
        nixery-prepare-image = pkgs.callPackage ./prepare-image { };
        nixery-popcount = pkgs.callPackage ./popcount { };
      };

      apps.default = {
        type = "app";
        program =
          let
            env = { nativeBuildInputs = [ pkgs.makeWrapper ]; };
            app = pkgs.runCommand "nixery-server" env ''
              makeWrapper ${config.packages.nixery}/bin/server $out/bin/nixery-server \
                --set-default PORT 8000 \
                --set-default NIXERY_PKGS_PATH "${pkgs.path}" \
                --set-default NIXERY_STORAGE_BACKEND "filesystem" \
                --set-default STORAGE_PATH "./." \
            '';
          in
            "${app}/bin/nixery-server";
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
