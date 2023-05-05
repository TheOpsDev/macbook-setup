#!/usr/bin/env bash

# Function definitions

function show_banner() {
    figlet -w 170 -f isometric1 -k Mackbook Setup
    printf "\n\n\n"
}

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
        ${BREW_CMD} install ${PACKAGE}
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
