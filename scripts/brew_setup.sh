#!/usr/bin/env bash

source scripts/_setup_tooling.sh

function usage() {
    echo >&2
    echo "Download/Install brew packages">&2
    echo >&2
    echo "  Usage:" >&2
    echo "    brew_setup.sh [OPTIONS] <ARGUMENTS>" >&2
    echo >&2
    echo "  Arguments:" >&2  
    echo "      -d|--default                  Install default packages.">&2 
    echo "      -i|--install                  Additional brew packages to install.">&2 
    echo "      -c|--casks                    Additional cask packages to install.">&2 
    echo >&2
    echo "  Options:" >&2  
    echo "      -h|--help                     Display help.">&2 
    echo >&2
}

DEFAULT_FORMULAE=(
    "bat"
    "bat-extras"
    "bc"
    "colima"
    "fzf"
    "git"
    "go"
    "helm"
    "k9s"
    "jq"
    "kind"
    "kube-ps1"
    "kubectx"
    "kubernetes-cli"
    "minikube"
    "neovim"
    "opa"
    "protobuf"
    "python@3.10"
    "ripgrep"
    "tfenv"
    "tmux"
    "tree"
    "tree-sitter"
    "vault"
    "yq"
)
DEFAULT_CASKS=(
    "google-cloud-sdk"
    "powershell"
    "vlc"
    "rectangle"
)
INSTALL_DEFAULTS=false

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while [ "$1" != "" ];do
    case $1 in
    -c | --casks)
        shift
        ADDITIONAL_CASK_PACKAGES=$1
        ;;
    -d | --default)
        shift
        INSTALL_DEFAULTS=true
        ;;
    -i | --install)
        shift
        ADDITIONAL_PACKAGES=$1
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

if [ $INSTALL_DEFAULTS == true ]; then
    BREW_PACKAGES=("${DEFAULT_FORMULAE[@]}" "${ADDITIONAL_PACKAGES[@]}")
    BREW_CASKS=("${DEFAULT_CASKS[@]}" "${ADDITIONAL_CASK_PACKAGES[@]}")
else
    BREW_PACKAGES=("${ADDITIONAL_PACKAGES[@]}")
    BREW_CASKS=("${ADDITIONAL_CASK_PACKAGES[@]}")
fi

box_out "STARTING INSTALL OF ${#BREW_PACKAGES[@]} BREW PACKAGES"
install_brew_packages --silent "${BREW_PACKAGES[@]}"
box_out "STARTING INSTALL OF ${#BREW_CASKS[@]} CASK PACKAGES"
install_brew_packages --silent --isCask "${BREW_CASKS[@]}"

printf "\n"