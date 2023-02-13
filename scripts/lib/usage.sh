#!/usr/bin/env bash

# Function : usage
# Description:
#   Prints usage instructions and a list of valid options to the terminal.
function usage() {
    error "Usage: $0 < configure | precheck | env | helm  >"
    warn "\tAvailable options"
    info "\tconfigure:   Configures the Kubeconfig for the cluster"
    info "\t precheck:   Runs Pre Checks"
    info "\t      env:   Exports the cluster environment variables to a file named \"env_vars.csv\" in the current directory"
    info "\t     helm:   Exports the Helm charts to a directory named \".resources/helm\" in the current directory"
}
