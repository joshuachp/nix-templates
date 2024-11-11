{
  packages,
  mkShell,
  pre-commit,
  nixfmt,
  rustup,
}:

mkShell {
  inputsFrom = builtins.attrValues packages;
  packages = [
    pre-commit
    nixfmt
    rustup
  ];
}
