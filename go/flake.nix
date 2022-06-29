{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
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
    , ...
    }:
    let
      eachDefaultSystemMap = flake-utils.lib.eachDefaultSystemMap;
    in
    rec {
      packages = eachDefaultSystemMap (system: {
        default = buildGoModule {
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
