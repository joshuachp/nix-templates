{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
    in
    {
      packages.default = pkgs.buildGoModule {
        pname = "hello";
        version = "0.0.0";
        src = "./";
        vendorSha256 = lib.fakeSha256;
      };
      apps. default = flake-utils.lib.mkApp {
        drv = self.packages.${system}.default;
      };
      devShells.default = pkgs.mkShell {
        inputsFrom = [
          self.packages.${system}.default
        ];
      };
    });
}
