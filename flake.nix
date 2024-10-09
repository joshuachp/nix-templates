{
  description = "A collection of flake templates";
  outputs =
    { self }:
    {
      templates = {
        rust = {
          path = ./rust;
          description = "Rust template with fenix and naersk";
        };
        rust-shell = {
          path = ./rust-shell;
          description = "Rust template for a nightly shell";
        };
        go = {
          path = ./go;
          description = "Go template to build go module";
        };
        web = {
          path = ./web;
          description = "Web template with node and yarn";
        };
        haskell = {
          path = ./haskell;
          description = "Hakell template using haskell.nix";
        };
        python = {
          path = ./python;
          description = "Python dev shell template";
        };
        defaultTemplate = self.templates.rust;
      };
    };
}
