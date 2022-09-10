{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , lib
    , ...
    }:
    let
      eachDefaultSystemMap = flake-utils.lib.eachDefaultSystemMap;
    in
    rec {
      packages = eachDefaultSystemMap (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.buildGoModule {
            src = "./";
          };
        });
      apps = eachDefaultSystemMap (system: {
        default = flake-utils.lib.mkApp {
          drv = packages.${system}.default;
        };
      });
      devShells = eachDefaultSystemMap (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              pre-commit
            ];
          };
        });
    };
}