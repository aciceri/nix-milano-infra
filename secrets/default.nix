{ inputs, ... }: {
  imports = [
    inputs.agenix-shell.flakeModules.default
  ];

  agenix-shell = {
    secrets = {
      TF_VAR_github_token.file = ./github_token.age;
    };
  };
}
