#!/usr/bin/env bash


# Function: Get env variables from a deployment in a specific namespace
# Description:
#   Given a namespace and a deployment, this function retrieves the environment variables of the 
#   containers in that deployment. It uses the kubectl command to get the deployment in JSON format, 
#   then uses jsonpath to extract the environment variables. 
#   The jq command is used to format the output as name=value pairs, one per line.
# Parameters:
#   $1 -> namespace
#   $2 -> deployment
function get_env_vars() {
    local namespace=$1
    local deployment=$2
    kubectl get deploy ${deployment} -n ${namespace} -o jsonpath='{.spec.template.spec.containers[*].env}' | jq -r '.[] | "\(.name)=\(.value)"'
}

# Function : Get env variables from all deployments in a specific namespace
# Description:
#   Given a namespace, this function retrieves the environment variables for all deployments in that namespace. 
#   It first uses kubectl to get the names of all deployments in the namespace, then loops through them, calling get_env_vars for each deployment. 
#   For each environment variable, it uses cut command to extract the key and value and prints them as a comma separated string in the format 
#   "Namespace,Deployment,Key,Value".
# Parameters:
#   $1 -> namespace
function get_env_in_namespace() {
    local namespace=$1
    local deployments=$(kubectl get deploy -n ${namespace} -o jsonpath='{.items[*].metadata.name}')
    for deployment in ${deployments}; do
        env_vars=$(get_env_vars ${namespace} ${deployment})
        for env in ${env_vars}; do
            key=$(echo ${env} | cut -d'=' -f1)
            value=$(echo ${env} | cut -d'=' -f2)
            echo "${namespace},${deployment},${key},${value}"
        done
    done
}

# Function : Get env variables from all deployments in all namespaces
# Description:
#    Retrieves the environment variables for all deployments in all namespaces. 
#   It first uses kubectl to get the names of all namespaces, then loops through them, calling get_env_in_namespace for each namespace.
function get_env_in_all_namespaces() {
    echo "Namespace,Deployment,Key,Value"
    local namespaces=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}')
    for namespace in ${namespaces}; do
        get_env_in_namespace ${namespace}
    done
}

# Function : stdout option
# Description:
#   Invokes get_env_in_all_namespaces and formats the output as tabular format. 
#   It checks if the column command is available, if yes, it pipes the output to column command, otherwise, it uses sed command to replace commas with tabs.
function print_tabular_output() {
    local result=$(get_env_in_all_namespaces)
    # if column is available use it
    if command -v column &> /dev/null; then
        # echo "$result" | awk '{if (NR==1) {print "\033[32m" $0 "\033[39m"} else {print}}' | column -t -s ','
        echo "$result" | column -t -s ','
    else
        #get_env_in_all_namespaces | awk -F, '{printf "%-20s %-20s %-20s %-20s \n", $1, $2, $3, $4}'
        echo "$result" | sed 's/,/\t/g'
    fi
}

# Function : Write to file the output
# Description:
#   This function calls get_env_in_all_namespaces and writes the output to a file named env_vars.csv
function write_to_file() {
    local report_file=".report/env_vars.csv"
    # check if the .report directory exists, if not, create it
    if [ ! -d .report ]; then
        mkdir .report
    fi
    get_env_in_all_namespaces > $report_file
    info "Report Generation Done. Check .report directory for the report files"
    filter_amazon_endpoints
}
