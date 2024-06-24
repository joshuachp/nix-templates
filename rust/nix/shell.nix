{
  mkShell,
  pre-commit,
  nixfmt,
  packages,
  toolchainDev,
}:

mkShell {
  inputsFrom = builtins.attrValues packages;
  packages = [
    pre-commit
    nixfmt
    toolchainDev
  ];
  RUST_SRC_PATH = "${toolchainDev}";
}
