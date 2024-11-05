# spectrum

## How to create a cluster from PR

### Prerequisites

#### Minimal

- [github cli](https://cli.github.com/) - to download kubeconfig from PR workflow run
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - to access the cluster
- [just](https://github.com/casey/just?tab=readme-ov-file#packages) - simple make alternative

#### Create a cluster

Create a PR with changes and add a comment to PR:

```
/create
```

This will trigger the workflow that will setup talos cluster from you PR.
Comment

```
/help
```

to see all available commands.

#### Download and export kubeconfig

```
just download
export KUBECONFIG=./kubeconfig
```

#### Start using the cluster

https://kubernetes.io/docs/reference/kubectl/quick-reference/
