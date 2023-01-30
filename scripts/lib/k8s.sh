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
    EKS_CONFIG_FILE="$GIT_BASE_PATH/.config/eks.env"
    AWS_PROFILE=${1:-"lcce-development"}
    AWS_REGION=${2:-"us-east-1"}
    CLUSTER=${3:-"Development"}

    echo -e "export AWS_PROFILE=$AWS_PROFILE" >  $EKS_CONFIG_FILE
    echo -e "export AWS_REGION=$AWS_REGION"   >> $EKS_CONFIG_FILE
    echo -e "export CLUSTER=$CLUSTER"          >> $EKS_CONFIG_FILE
    echo -e "export KUBECONFIG=$KUBECONFIG:~/.kube/config" >> $EKS_CONFIG_FILE

    export $(grep -v '^#' $EKS_CONFIG_FILE | xargs)
    aws eks update-kubeconfig --region $AWS_REGION  --name $CLUSTER

}
