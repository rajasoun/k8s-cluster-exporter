#!/usr/bin/env bash

# Function: Check if the kubeconfig file is created
function check_if_kubeconfig_exists(){
    if [ ! -f ~/.kube/config ]; then
        error "Kubeconfig file not found."
        warn "Please run 'aws eks update-kubeconfig --region $AWS_REGION  --name $CLUSTER' to create the kubeconfig file"
        exit 1
    fi
}


# Function: Post Checks 
function post_checks(){
    check_if_kubeconfig_exists
}   

# Function: kubeconfig for a cluster in a aws region
function kube_config(){
    shift
    local environment="$1"
    # Check if the environment is provided - if not, exit
    if [ -z "$environment" ]; then
        error "Please provide the environment name"
        exit 1
    fi
    info "Configuring Kubeconfig for $environment using .config/environments/$environment.yaml"
    local CONFIG_FILE="$GIT_BASE_PATH/.config/environments/$environment.yaml"
    local AWS_PROFILE=$(yq '.environment.AWS_PROFILE' $CONFIG_FILE )
    local AWS_REGION=$(yq '.environment.AWS_REGION'  $CONFIG_FILE )
    local CLUSTER=$(yq '.environment.CLUSTER'  $CONFIG_FILE )
    local EKS_CONFIG_FILE="$GIT_BASE_PATH/.config/eks.env"

    echo -e "export AWS_PROFILE=$AWS_PROFILE" >  $EKS_CONFIG_FILE
    echo -e "export AWS_REGION=$AWS_REGION"   >> $EKS_CONFIG_FILE
    echo -e "export CLUSTER=$CLUSTER"          >> $EKS_CONFIG_FILE
    echo -e "export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config" >> $EKS_CONFIG_FILE

    export $(grep -v '^#' $EKS_CONFIG_FILE | xargs)
    aws eks update-kubeconfig --region $AWS_REGION  --name $CLUSTER || error "Failed to update kubeconfig" && exit 1
    success "\tKubeconfig Done !!!"
    kube_ctx=$(kubectl config current-context)
    info "\tContext: $kube_ctx"
}


