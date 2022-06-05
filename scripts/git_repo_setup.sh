#!/usr/bin/env bash

source scripts/_setup_tooling.sh

function usage() {
    echo >&2
    echo "Setup git workspaces for local development. Default location is under ~/Documents/">&2
    echo >&2
    echo "  Usage:" >&2
    echo "    git_repo_setup.sh [OPTIONS] <ARGUMENTS>" >&2
    echo >&2
    echo "  Arguments:" >&2  
    echo "      -f|--folder                  Override default location.">&2  
    echo >&2
    echo "  Options:" >&2  
    echo "      -h|--help                     Display help.">&2 
    echo >&2
}

GIT_FOLDER_LOCATION="~/Documents"
GIT_REPOS=(
    "https://github.com/TheOpsDev/nvim_config.git"
    "https://github.com/TheOpsDev/TheOpsDev.git"
    "https://github.com/TheOpsDev/lausd-daily-pass.git"
)

while [ "$1" != "" ];do
    case $1 in
    -f | --folder)
        shift
        GIT_FOLDER_LOCATION=$1
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        echo "INVALID FLAG"
        usage
        exit 1
        ;;
    esac
    shift
done

GIT_FOLDER_LOCATION="${GIT_FOLDER_LOCATION}/git"
box_out "SETTING UP GIT WORKSPACES" "PATH: ${GIT_FOLDER_LOCATION}"

mkdir -p "${GIT_FOLDER_LOCATION}"

CWD=$(pwd)
cd "${GIT_FOLDER_LOCATION}"
for REPO in "${GIT_REPOS[@]}"; do
    printf "\tCloning ${REPO}\n"
    git clone -q $REPO
done
cd "${CWD}"

printf "\n"