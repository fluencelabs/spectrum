{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.unstableNixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    {
      nixpkgs,
      unstableNixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          system = "${system}";
          config.allowUnfree = true;
        };
        unstablePkgs = import unstableNixpkgs {
          system = "${system}";
          config.allowUnfree = true;
        };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell {
          name = "spectrum";

          packages = [
            pkgs.bashInteractive
            pkgs.nixfmt-rfc-style
            pkgs.just
            pkgs.gh

            unstablePkgs.talosctl
            pkgs.kubectl
            pkgs.kubernetes-helm
            pkgs.kustomize
            pkgs.kubevirt
            pkgs.cilium-cli
            pkgs.fluxcd
            pkgs.terraform
          ];

          shellHook = ''
            [[ -f $FLUENCE_SECRETS ]] && source $FLUENCE_SECRETS
            [[ -f ./kubeconfig ]] && export KUBECONFIG=$(realpath ./kubeconfig)
            [[ -f ./talosconfig ]] && export TALOSCONFIG=$(realpath ./talosconfig)
          '';
        };
      }
    );
}
