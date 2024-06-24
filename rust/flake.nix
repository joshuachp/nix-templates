{
  description = "A rust example flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      crane,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };
        toolchain = pkgs.rust-bin.stable.latest.default;
        craneLib = (crane.mkLib pkgs).overrideToolchain toolchain;
        packages = self.packages.${system};
        inherit (pkgs) callPackage;
      in
      {
        packages.default = craneLib.buildPackage {
          src = craneLib.cleanCargoSource (craneLib.path ./.);
          srictDeps = true;
        };

        apps.default = flake-utils.lib.mkApp { drv = packages.default; };

        devShells.default =
          let
            toolchainDev = (
              toolchain.override {
                extensions = [
                  "rust-analyzer"
                  "rust-src"
                ];
              }
            );
          in
          pkgs.mkShell {
            inputsFrom = [ packages.default ];
            packages =
              (with pkgs; [
                pre-commit
                nixpkgs-fmt
              ])
              ++ [ toolchainDev ];
            RUST_SRC_PATH = "${toolchainDev}";
          };
      }
    );
}
