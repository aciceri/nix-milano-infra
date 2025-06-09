{ ... }: {
  perSystem =
    { pkgs
    , lib
    , config
    , ...
    }: {
      packages = {
        tofu-validate = pkgs.writeShellApplication {
          name = "tofu-validate";
          runtimeInputs = [ pkgs.opentofu ];
          text = ''
            set -e
            echo "Running tofu validate..."
            tofu validate
          '';
        };

        tofu-plan = pkgs.writeShellApplication {
          name = "tofu-plan";
          runtimeInputs = [ pkgs.opentofu ];
          text = ''
            set -e
            echo "Running tofu plan..."
            tofu plan
          '';
        };

        tofu-apply = pkgs.writeShellApplication {
          name = "tofu-apply";
          runtimeInputs = [ pkgs.opentofu ];
          text = ''
            set -e
            echo "Running tofu apply..."
            tofu apply -auto-approve
          '';
        };

        tofu-apply-in-workflow = pkgs.writeShellApplication {
          name = "tofu-apply-in-workflow";
          runtimeInputs = with pkgs; [ opentofu git ];
          text = ''
            set -e
            # shellcheck disable=SC1091
            source "${lib.getExe config.agenix-shell.installationScript}"
            tofu init
            tofu apply --auto-approve
            ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub
            ssh-keyscan github.com >> ~/.ssh/known_hosts
            git add terraform.tfstate
            git config --global user.email "milan@nix.pizza"
            git config --global user.name "Ambrogio"
            git config --global github.user "ambrogio-bot"
            git config --global gpg.format ssh
            git config --global user.signingkey ~/.ssh/id_ed25519.pub
            git config --global commit.gpgsign true
            git commit -m "Automatic terraform state update"
            git remote set-url origin git@github.com:nix-milano/infra.git
            git push origin master
          '';
        };
      };
    };
}
