#/usr/bin/env bash

# Function : Fileter report file by amazon endpoints
# Description:
#   This function filters the report file by amazon endpoints
function filter_amazon_endpoints() {
    local report_file=".report/env_vars.csv"
    local aws_endpoints_report_file=".report/amazon_endpoints.csv"
    local aws_endpoints_count=$(cat $report_file | grep -i amazon | grep ".com" | wc -l)
    if [ $aws_endpoints_count -gt 0 ]; then
        echo "Namespace,Deployment,Key,Value" > $aws_endpoints_report_file
        cat $report_file | grep -i amazon | grep ".com" >> $aws_endpoints_report_file
    else 
        warn "AWS Endpoints : $aws_endpoints_count Found."
        error "Check kubetx if multiple clusters are configured and the current context is set to the correct cluster."
    fi
}