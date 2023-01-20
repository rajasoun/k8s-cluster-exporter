#!/usr/bin/env bash

GIT_BASE_PATH=$(git rev-parse --show-toplevel)
source "$GIT_BASE_PATH/scripts/lib/loader.sh"

# Function : Main function
# Description : 
#   Accepts an option as a command-line argument. 
#   The option is passed to the script when it is executed, and it is stored in the opt variable and 
#   converts the option to lowercase using the tr command and stores the result in the choice variable.
#   Uses a case statement to handle the different options:
#   1. If the option is "stdout", the script will call the print_tabular function, this function will take the output of get_env_in_all_namespaces and format it in tabular format using one of the alternatives you want (awk, cut, sed.. etc)
#   2. If the option is "file", the script will call the get_env_in_all_namespaces function and redirect its output to a file named "env_vars.csv"
#   3. If no option is provided, or an invalid option is provided, the script will print usage instructions and a list of valid options to the terminal.
# Parameters:
#   $1 -> option
function main(){
    opt="$1"
    choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
    case $choice in
        precheck)run_pre_checks;;
        env-list)print_tabular_output;;
        env)write_to_file;;
        helm)export_helm_charts_from_cluster;;
        yaml)export_yaml_from_cluster;;
        *) usage;;
    esac
}
