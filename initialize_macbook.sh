#!/usr/bin/env bash

function usage() {
    echo >&2
    echo "Download/Install necessary tools for my local macbook setup">&2
    echo >&2
    echo "  Usage:" >&2
    echo "    initialize_macbook.sh [OPTIONS] " >&2
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

function show_banner() {
    figlet -w 170 -f isometric1 -k Mackbook Setup
    printf "\n\n\n"
}


DEFAULT_FORMULAE=(
    "bat"
    "bat-extras"
    "bc"
    "colima"
    "fzf"
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

function install_brew_binary() {
    echo "Installing brew binary..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew instal -s figlet
}

function install_brew_packages() {
    BREW_CMD="brew"
    CASK_FLAG="--cask"
    SILENT_FLAG="-s"

    CMD_FOUND="$(which ${BREW_CMD})"
    if [ $? -ne 0 ]; then
        echo "brew command not found, downloading binary from brew site..."
        install_brew_binary
    fi

    for I in 1 2; do
        case $1 in
        -c | --isCask)
            shift
            BREW_CMD="${BREW_CMD} ${CASK_FLAG}"
            printf "\t* cask flag enabled\n"
            ;;
        -s | --silent)
            shift
            BREW_CMD="${BREW_CMD} ${SILENT_FLAG}"
            printf "\t* silent flag enabled\n"
            ;;
        esac
    done
    printf "\n"

    for PACKAGE in $@; do
        printf "\tInstalling %s\n" $PACKAGE
        # "${BREW_CMD} install ${PACKAGE}"
    done
}

function box_out() {
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w<${#l})) && { b="$l"; w="${#l}"; }
  done
  tput setaf 3
  echo " -${b//?/-}-
| ${b//?/ } |"
  for l in "${s[@]}"; do
    printf '| %s%*s%s |\n' "$(tput setaf 4)" "-$w" "$l" "$(tput setaf 3)"
  done
  echo "| ${b//?/ } |
 -${b//?/-}-"
  tput sgr 0
}

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

show_banner
box_out "STARTING INSTALL OF ${#BREW_PACKAGES[@]} BREW PACKAGES"
install_brew_packages --silent "${BREW_PACKAGES[@]}"
box_out "STARTING INSTALL OF ${#BREW_CASKS[@]} CASK PACKAGES"
install_brew_packages --silent --isCask "${BREW_CASKS[@]}"