#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

spinner_pid=""
spinner_chars=('|' '/' '-' '\\')

USE_SUDO=true  # padrão usa sudo

start_spinner() {
  local text="$1"
  local i=0
  (
    while :; do
      printf "\r${CYAN}${spinner_chars[i]} %s${RESET}" "$text"
      sleep 0.1
      ((i=(i+1)%4))
    done
  ) &
  spinner_pid=$!
  # disown
}

stop_spinner() {
  if [[ -n "$spinner_pid" ]]; then
    kill "$spinner_pid" 2>/dev/null || true
    wait "$spinner_pid" 2>/dev/null || true
    spinner_pid=""
    printf "\r\033[K"
  fi
}

print_usage() {
  cat <<EOF
Uso: $0 [opções]

Opções:
  --with-sudo, -sudo    Usar sudo para instalar pacotes (padrão)
  --without-sudo, -no-sudo  Não usar sudo (tenta instalar como usuário atual)
  -h, --help            Mostrar esta ajuda
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --with-sudo|-sudo)
        USE_SUDO=true
        shift
        ;;
      --without-sudo|-no-sudo)
        USE_SUDO=false
        shift
        ;;
      -h|--help)
        print_usage
        exit 0
        ;;
      *)
        echo -e "${RED}Opção desconhecida: $1${RESET}"
        print_usage
        exit 1
        ;;
    esac
  done
}

detect_package_manager() {
  if command -v brew &>/dev/null; then
    echo "brew install"
    return 0
  fi

  if command -v apt-get &>/dev/null; then
    if $USE_SUDO; then
      echo "sudo apt-get install -y"
    else
      echo "apt-get install -y"
    fi
    return 0
  fi

  if command -v pacman &>/dev/null; then
    if $USE_SUDO; then
      echo "sudo pacman -Sy --noconfirm"
    else
      echo "pacman -Sy --noconfirm"
    fi
    return 0
  fi

  if command -v dnf &>/dev/null; then
    if $USE_SUDO; then
      echo "sudo dnf install -y"
    else
      echo "dnf install -y"
    fi
    return 0
  fi

  if command -v apk &>/dev/null; then
    if $USE_SUDO; then
      echo "sudo apk add"
    else
      echo "apk add"
    fi
    return 0
  fi

  if command -v zypper &>/dev/null; then
    if $USE_SUDO; then
      echo "sudo zypper install -y"
    else
      echo "zypper install -y"
    fi
    return 0
  fi

  if command -v pkg &>/dev/null; then
    if $USE_SUDO; then
      echo "sudo pkg install -y"
    else
      echo "pkg install -y"
    fi
    return 0
  fi

  return 1
}

update_package_manager() {
  if command -v apt-get &>/dev/null; then
    if $USE_SUDO; then
      start_spinner "Updating package lists..."
      sudo apt-get update -y &>/dev/null
      stop_spinner
    else
      start_spinner "Updating package lists..."
      apt-get update -y &>/dev/null
      stop_spinner
    fi
  fi
}

check_packages() {
  local packages=(
    ripgrep
    jq
    chafa
    curl
    wget
    nodejs
    clang
    ncurses-utils
    git
    zsh
    neovim
    eza
    bc
  )

  start_spinner "Detecting package manager..."
  local install_cmd
  install_cmd=$(detect_package_manager || true)
  stop_spinner

  if [[ -z "$install_cmd" ]]; then
    echo -e "${RED}No supported package manager found. Please install packages manually.${RESET}"
    exit 1
  else
    echo -e "${GREEN}Using package manager command: $install_cmd${RESET}"
  fi

  update_package_manager

  IFS=' ' read -r -a install_cmd_arr <<< "$install_cmd"

  for pkg in "${packages[@]}"; do
    if command -v "$pkg" &>/dev/null; then
      echo -e "${GREEN}$pkg is already installed.${RESET}"
    else
      start_spinner "Installing $pkg..."
      if "${install_cmd_arr[@]}" "$pkg" &>/dev/null; then
        stop_spinner
        echo -e "${GREEN}$pkg installed successfully.${RESET}"
      else
        stop_spinner
        echo -e "${RED}Failed to install $pkg. Please install it manually.${RESET}"
        exit 1
      fi
    fi
  done
}

main() {
  parse_args "$@"
  check_packages
  echo -e "${GREEN}Setup completed successfully!${RESET}"
}

main "$@"

