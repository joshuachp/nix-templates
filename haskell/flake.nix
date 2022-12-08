{
  description = "Haskell flake template";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    haskellNix = {
      url = "github:input-output-hk/haskell.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , haskellNix
    , ...
    }:
    let
      supportedSystems = with flake-utils.lib.system; [
        x86_64-linux
        x86_64-darwin
        aarch64-linux
        aarch64-darwin
      ];
      eachSystemMap = flake-utils.lib.eachSystemMap supportedSystems;
    in
    rec{
      packages = eachSystemMap
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          rec {
            helloHaskell = pkgs.haskell-nix.cabalProject {
              pname = "helloHaskell";
              src = ./.;
            };
            default = helloHaskell;
          });

      apps = eachSystemMap (system: {
        default = flake-utils.lib.mkApp {
          drv = packages.${system}.default;
        };
      });

    };
}
