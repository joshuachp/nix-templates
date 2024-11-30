{
  lib,
  stdenv,
  makeRustPlatform,

  buildPackages,
}:
let
  inherit (stdenv.hostPlatform) rust;
  toolchain = buildPackages.rust-bin.stable.latest.default.override {
    targets = [ rust.rustcTarget ];
  };
  rustPlatform = makeRustPlatform {
    inherit stdenv;
    cargo = toolchain;
    rustc = toolchain;
  };
in
rustPlatform.buildRustPackage {
  # pname = "example";
  # version = "0.1.0";

  src = lib.sourceFilesBySuffices ../. [
    "toml"
    "lock"
    "rs"
  ];

  cargoLock = {
    lockFile = ../Cargo.lock;
  };
}
