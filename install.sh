#!/usr/bin/env bash

function usage() {
    echo >&2
    echo "Download/Install necessary tools for my local macbook setup">&2
    echo >&2
    echo "  Usage:" >&2
    echo "    install.sh [OPTIONS] " >&2
    echo >&2
    echo "  Options:" >&2  
    echo "      -h|--help                     Display help.">&2 
    echo >&2
}

while [ "$1" != "" ];do
    case $1 in
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

show_banner
./scripts/brew_setup.sh -d
./scripts/git_repo_setup.sh