{
  description = "A collection of flake templates";
  outputs = {self}: {
    templates = {
      rust = {
        path = ./rust;
        description = "Rust template with fenix and naersk";
      };
      rust = {
        path = ./web;
        description = "Web template with node and yarn";
      };
      defaultTemplate = self.templates.trivial;
    };
  };
}
