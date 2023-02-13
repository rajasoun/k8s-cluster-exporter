# Kubernestes Cluster Exporter 

Kubernetes Cluster Exporter environment variables, helm manifests & values.

## Pre-requisites

-   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
-   [kubectx](https://github.com/ahmetb/kubectx)
-   [helm](https://helm.sh/docs/intro/install/)
-   [jq](https://stedolan.github.io/jq/download/)

## Getting Started 

1. Create workspace directory and clone git repo

    ```sh
    WORKPSACE_PATH="$HOME/workspace/gitops"
    GIT_REPO_PATH="$HOME/workspace/gitops/k8s-cluster-exporter"
    [ ! -d  $WORKPSACE_PATH ] && mkdir -p $WORKPSACE_PATH
    [ ! -d  $GIT_REPO_PATH ] && git clone https://github.com/rajasoun/k8s-cluster-exporter $WORKPSACE_PATH 
    ```

1. Create `dev.yaml` file and update it with AWS_PROFILE, AWS_REGION and CLUSTER details


    ```sh
    cp .config/environments/env_template.yaml dev.yaml        
    ```

1. Configure kubectl to use the cluster

    ```sh
    ./assist.sh configure dev
    ```

