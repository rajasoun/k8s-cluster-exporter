#!/usr/bin/env bash

# Function : check_cluster_reachable
function check_cluster_reachable() {
    local result=0
    info "Checking if the cluster is reachable"
    # check cluster is reable using kubectl get pods
    if ! kubectl get pods > /dev/null 2>&1; then
        error "The cluster is not reachable"
        result=1
    fi
    return $result
}

# Function : check_helm_releases
function check_helm_releases() {
    local result=0
    info "Checking if the cluster has any Helm releases"
    if [ -z "$(get_helm_releases)" ]; then
        error "The cluster has no Helm releases"
        result=1
    fi
    return $result
}

# Function : check_cluster_health
function check_cluster_health() {
    local result=0
    info "Checking if the cluster is healthy"
    # use /healthz endpoint to check if the cluster is healthy
    if ! kubectl get --raw /healthz > /dev/null 2>&1; then
        error "The cluster is not healthy"
        result=1
    fi
    return $result
}

# Function : check_kubectl
function check_required_tools_available() {
    local result=0
    required_tools=("kubectl" "helm" "jq" "kubectx" "kubens")
    info "Checking $required_tools are installed"
    for tool in "${required_tools[@]}"
    do
        if ! command -v $tool > /dev/null 2>&1; then
            error "$tool is not installed"
            result=1
        fi
    done
    return $result
}

# Function : Run Pre Checks
# Description:
#   Runs pre checks.
#   - checks if the cluster is reachable and if the user has access to the cluster.
#   - checks if the cluster has any Helm releases.
#   - checks if cluster is healthy.
#   - checks if kubectl, helm, jq are installed.
function run_pre_checks() {
    check_cluster_reachable && success "\tReachable"
    check_cluster_health && success "\tHealthy"
    check_helm_releases && success "\tExists"
    check_required_tools_available && success "\tInstalled"
}
