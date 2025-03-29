{ inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem =
    { config
    , pkgs
    , lib
    , ...
    }: {
      treefmt.config = {
        flakeFormatter = true;
        flakeCheck = true;
        programs = {
          nixpkgs-fmt.enable = true;
          typos =
            {
              excludes = [
                ".*\.jpg"
              ];
              enable = true;
            };
          terraform.enable = true;
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
        packages = with pkgs; [ opentofu ragenix ];
        shellHook = ''
          	  ${config.pre-commit.installationScript}
          	  source ${lib.getExe config.agenix-shell.installationScript}
        '';
      };
    };
}
