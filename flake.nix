{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix-shell.url = "github:aciceri/agenix-shell";
    terranix.url = "github:terranix/terranix";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ lib, ... }: {
      systems = lib.systems.flakeExposed;
      imports = [
        ./shell
      ];
    });
}
