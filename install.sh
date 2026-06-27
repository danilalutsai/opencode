#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.opencode-setup-backup/$(date +%Y%m%d-%H%M%S)"

log() {
  printf '\n==> %s\n' "$1"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_or_update_dependencies() {
  log "Installing or updating system dependencies"

  if [[ "$OSTYPE" == darwin* ]]; then
    if ! need_cmd brew; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    fi

    brew update
    brew upgrade || true
    brew install git curl node python || brew upgrade git curl node python || true
    return
  fi

  if need_cmd apt-get; then
    sudo apt-get update
    sudo apt-get upgrade -y ca-certificates curl git python3 || true
    sudo apt-get install -y ca-certificates curl git python3 build-essential
    if ! need_cmd node || ! need_cmd npm; then
      curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
      sudo apt-get install -y nodejs
    fi
  elif need_cmd dnf; then
    sudo dnf upgrade -y
    sudo dnf install -y ca-certificates curl git python3 gcc-c++ make nodejs npm
  elif need_cmd pacman; then
    sudo pacman -Syu --needed --noconfirm ca-certificates curl git python base-devel nodejs npm
  else
    printf 'Unsupported package manager. Install curl, git, python3, node, and npm, then rerun.\n' >&2
    exit 1
  fi
}

install_or_update_tools() {
  log "Installing or updating OpenCode"
  curl -fsSL https://opencode.ai/install | bash

  log "Installing or updating Plannotator"
  curl -fsSL https://plannotator.ai/install.sh | bash

  log "Installing or updating Skills CLI and agent skills"
  npm install -g skills@latest
  npx -y skills add vercel-labs/skills@find-skills -g -y || true
  npx -y skills add backnotprop/plannotator@plannotator-compound -g -y || true
  npx -y skills add backnotprop/plannotator@plannotator-setup-goal -g -y || true
  npx -y skills add backnotprop/plannotator@plannotator-visual-explainer -g -y || true
  npx -y skills update -g || true

  log "Installing OpenCode plugin dependencies"
  if [[ -f "$REPO_DIR/config/opencode/package.json" ]]; then
    npm install --prefix "$REPO_DIR/config/opencode" @opencode-ai/plugin@latest
  fi
}

backup_path() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    mkdir -p "$BACKUP_DIR$(dirname "$path")"
    mv "$path" "$BACKUP_DIR$path"
  fi
}

link_path() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return
  fi
  backup_path "$target"
  ln -s "$source" "$target"
}

link_config() {
  log "Linking configuration from repository"
  link_path "$REPO_DIR/config/opencode" "$HOME/.config/opencode"
  link_path "$REPO_DIR/config/agents" "$HOME/.agents"

  mkdir -p "$HOME/.plannotator"
  link_path "$REPO_DIR/config/plannotator/install-prefs" "$HOME/.plannotator/install-prefs"
}

print_versions() {
  log "Installed versions"
  command -v opencode >/dev/null 2>&1 && opencode --version || true
  command -v plannotator >/dev/null 2>&1 && plannotator --version || true
  node --version
  npm --version
}

install_or_update_dependencies
link_config
install_or_update_tools
print_versions

cat <<'DONE'

Setup complete. Restart OpenCode so it loads the linked config and Plannotator plugin.
DONE
