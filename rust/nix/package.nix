{ craneLib }:

craneLib.buildPackage {
  src = craneLib.cleanCargoSource (craneLib.path ../.);
  srictDeps = true;
}
