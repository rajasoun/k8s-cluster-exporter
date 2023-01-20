#!/usr/bin/env bash

# Function: Prints Error Message to stderr
# Description:
#   Given a message, this function prints it to stderr.
# Parameters:
#   $1 -> message
function print_error() {
    echo "$0: $*" >&2
}

# Function: Returns 1 with an error message
# Description:
#   Given a command, this function returns 1 with an error message.
# Parameters:
#   $1 -> command
function return_on_error() {
    error "Command: [$1] Failed."
    return 1
}

# Function: Execute command and return 1 with an error message if it fails
# Description:
#   Given a command, this function executes it and return 1 with an error message if it fails.
# Parameters:
#   $@ -> command
function try() {
    "$@" || return_on_error "$*" 
}
