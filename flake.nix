{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
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

            pkgs.talosctl
            pkgs.kubectl
            pkgs.kubernetes-helm
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
