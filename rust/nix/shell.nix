{
  packages,
  mkShell,
  pre-commit,
  nixfmt-rfc-style,
  rustup,
}:
mkShell {
  inputsFrom = builtins.attrValues packages;
  packages = [
    pre-commit
    nixfmt-rfc-style
    rustup
  ];
}
