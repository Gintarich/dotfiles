#!/usr/bin/env bash
set -euo pipefail

VENV_DIR="${HOME}/.venvs/quarto"
KERNEL_NAME="quarto"
KERNEL_DISPLAY="Python (Quarto)"

log() { printf "\n==> %s\n" "$*"; }
warn() { printf "\nWARN: %s\n" "$*" >&2; }
die() { printf "\nERROR: %s\n" "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

install_uv() {
  log "uv not found — installing uv..."

  # Prefer Arch package manager if present
  if have pacman; then
    if ! have sudo; then
      die "pacman is present but sudo is not. Install uv manually or run as root."
    fi

    # Ensure curl exists for fallback installer
    if ! have curl; then
      log "Installing curl (needed for fallback installer)..."
      sudo pacman -S --needed --noconfirm curl
    fi

    # Try pacman first
    if sudo pacman -S --needed --noconfirm uv; then
      log "Installed uv via pacman."
      return 0
    else
      warn "pacman could not install 'uv' (package may not exist in your repos). Falling back to official installer..."
    fi
  else
    # No pacman, rely on official installer
    if ! have curl; then
      die "'curl' is required to install uv (and no pacman found to install it)."
    fi
  fi

  # Official installer (Astral)
  curl -LsSf https://astral.sh/uv/install.sh | sh

  # uv is typically installed to ~/.local/bin
  export PATH="${HOME}/.local/bin:${PATH}"

  have uv || die "uv installation finished, but 'uv' still not in PATH. Add ~/.local/bin to PATH and re-run."
  log "Installed uv via official installer."
}

ensure_quarto(){
    if have quarto; then 
        echo "QUARTO INSTALLED"
        return 0; 
    else
        yay -S --needed --noconfirm quarto-cli-bin
    fi
}

ensure_python() {
  if have python; then return 0; fi

  log "Python not found — installing python..."
  if have pacman; then
    have sudo || die "Need sudo to install python via pacman."
    sudo pacman -S --needed --noconfirm python
  else
    die "Python not found and pacman is not available. Install Python manually, then re-run."
  fi
}

ensure_venv() {
  # If it looks like a venv already exists, do nothing
  if [[ -x "${VENV_DIR}/bin/python" && -f "${VENV_DIR}/pyvenv.cfg" ]]; then
    log "Venv already exists at: ${VENV_DIR} (skipping creation)"
    return 0
  fi

  log "Creating venv at: ${VENV_DIR}"
  mkdir -p "$(dirname "$VENV_DIR")"
  uv venv "$VENV_DIR"
}

main() {
  log "Checking dependencies..."
  have uv || install_uv
  ensure_python

  log "Creating venv at: ${VENV_DIR}"
  ensure_venv 

  # Activate venv
  # shellcheck disable=SC1090
  source "${VENV_DIR}/bin/activate"

  log "Installing Python packages into venv..."
  uv pip install --upgrade pip
  uv pip install jupyter ipykernel pandas numpy matplotlib

  log "Registering Jupyter kernel: ${KERNEL_NAME} (${KERNEL_DISPLAY})"
  python -m ipykernel install --user --name "$KERNEL_NAME" --display-name "$KERNEL_DISPLAY"

  log "Done."
  echo "Venv:   $VENV_DIR"
  echo "Kernel: $KERNEL_NAME"
  echo
  echo "Next:"
  echo "  source \"$VENV_DIR/bin/activate\""
  echo "  jupyter kernelspec list | grep -i \"$KERNEL_NAME\" || true"
}

main "$@"

