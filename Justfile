download:
  rm -f kubeconfig talosconfig
  gh run download -n configs
  nix-direnv-reload
