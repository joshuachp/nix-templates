{
  description = "A rust example flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nmattia/naersk/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { self
    , nixpkgs
    , fenix
    , naersk
    , flake-utils
    }:
    let
      supportedSystems = with flake-utils.lib.system; [
        x86_64-linux
        x86_64-darwin
        aarch64-linux
        aarch64-darwin
      ];
      eachSystem = flake-utils.lib.eachSystem supportedSystems;
    in
    eachSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      toolchain = fenix.packages.${system}.stable;
      naersk' = pkgs.callPackage naersk {
        rustc = toolchain;
        cargo = toolchain;
      };
    in
    {
      packages.default = naersk'.buildPackage {
        src = ./.;
      };

      apps.default = flake-utils.lib.mkApp {
        drv = self.packages.${system}.default;
      };

      devShells.default = pkgs.mkShell {
        inputsFrom = with self.packages.${system}; [
          default
        ];
        packages = with pkgs; [
          pre-commit
          nixpkgs-fmt
          rust-analyzer
        ];
      };
    });
}
