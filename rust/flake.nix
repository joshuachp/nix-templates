{
  description = "A rust example flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    crane.url = "github:ipetkov/crane";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
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
        inherit (pkgs) lib callPackage;
      in
      {
        packages.default = callPackage ./nix/package.nix { inherit craneLib; };
        apps.default = {
          type = "app";
          program = lib.getExe packages.default;
        };
        devShells.default = callPackage ./nix/shell.nix { inherit packages; };
      }
    );
}
