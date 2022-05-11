{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nmattia/naersk/master";
      inputs.nixpkgs.follows = "nixpkgs";
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
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    naersk,
    fenix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      naersk-lib = pkgs.callPackage naersk {};
    in {
      packages.default =
        (naersk-lib.override {
          inherit (fenix.packages.${system}.stable) cargo rustc;
        })
        .buildPackage {
          root = ./.;
        };

      defaultApp = flake-utils.lib.mkApp {drv = self.defaultPackage."${system}";};

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (fenix.packages.${system}.stable.withComponents [
            "cargo"
            "clippy"
            "rust-src"
            "rustc"
            "rustfmt"
          ])
          pre-commit
        ];
      };
    });
}
