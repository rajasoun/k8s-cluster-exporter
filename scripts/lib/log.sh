#!/usr/bin/env bash

# Function: log
# Description:
#   Logs a message to stdout with a specified color
# Parameters:
#   $1 -> message
#   $2 -> color code (e.g. \033[31m for red)
function log() {
    local message=$1
    local color=$2
    local NC='\033[0m'
    echo -e "${color}${message}${NC}"
}

# Function: info
# Description:
#   Logs an info message to stdout in blue
# Parameters:
#   $1 -> message
function info() {
    local BLUE="\033[34m"
    log "$1" "${BLUE}"
}

# Function: warn
# Description:
#   Logs a warning message to stdout in yellow
# Parameters:
#   $1 -> message
function warn() {
    local YELLOW="\033[33m"
    log "$1" "${YELLOW}"
}

# Function: error
# Description:
#   Logs an error message to stderr in red
# Parameters:
#   $1 -> message
function error() {
    local RED="\033[31m"
    log "$1" "${RED}" >&2
}

# Function: success
# Description:
#   Logs a success message to stdout in green
# Parameters:
#   $1 -> message
function success() {
    local GREEN="\033[32m"
    log "$1" "${GREEN}"
}