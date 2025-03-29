{ inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem =
    { config
    , pkgs
    , ...
    }: {
      treefmt.config = {
        flakeFormatter = true;
        flakeCheck = true;
        programs = {
          nixpkgs-fmt.enable = true;
          typos.enable = true;
        };
      };

      pre-commit = {
        check.enable = false; # treefmt already provices checks
        settings.hooks = {
          treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };
        };
      };

      devShells.default = pkgs.mkShell {
        packages = [ ];
        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
}
