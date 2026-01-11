#!/usr/bin/env bash
set -euo pipefail

### --- Config (you can tweak) ---
REPO_ROOT="${HOME}/Personal/Repos"
FORK_URL="https://github.com/Gintarich/FreeCAD.git"
REPO_NAME="FreeCAD"
LAUNCHER="${HOME}/.local/bin/freecad-dev"
DEFAULT_BUILD_TYPE="RelWithDebInfo"   # or Debug
### -------------------------------

# Parse args
BUILD_TYPE="$DEFAULT_BUILD_TYPE"
JOBS=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --build-type=*)
      BUILD_TYPE="${1#*=}"
      shift
      ;;
    --jobs=*)
      JOBS="${1#*=}"
      shift
      ;;
    -j|--jobs)
      shift
      JOBS="${1:-}"
      [[ -z "$JOBS" ]] && { echo "Missing value for --jobs"; exit 2; }
      shift || true
      ;;
    *)
      echo "Unknown argument: $1"
      echo "Usage: $0 [--build-type=RelWithDebInfo|Debug] [--jobs=N]"
      exit 2
      ;;
  esac
done

# Arch basics (git/curl; optional: base-devel for make/gdb, nice to have)
if command -v pacman >/dev/null 2>&1; then
  sudo pacman -Sy --needed --noconfirm git curl
fi

# Ensure ~/.local/bin exists and is on PATH for this session
mkdir -p "${HOME}/.local/bin"
case ":${PATH}:" in
  *":${HOME}/.local/bin:"*) ;;
  *) export PATH="${HOME}/.local/bin:${PATH}";;
esac

# Install pixi if missing
if ! command -v pixi >/dev/null 2>&1; then
  echo "Installing pixi..."
  # Official installer (Linux/macOS)
  curl -fsSL https://pixi.sh/install.sh | bash
  export PATH="${HOME}/.pixi/bin:${PATH}"
fi

# Confirm pixi available
if ! command -v pixi >/dev/null 2>&1; then
  echo "pixi not found on PATH after install. Ensure ~/.pixi/bin is exported and retry."
  exit 1
fi

# Clone or update your fork
mkdir -p "${REPO_ROOT}"
cd "${REPO_ROOT}"

if [[ -d "${REPO_NAME}/.git" ]]; then
  echo "Repo exists. Updating..."
  cd "${REPO_NAME}"
  # Make sure it's your fork as origin; if not, leave it alone.
  CURRENT_URL="$(git remote get-url origin || true)"
  if [[ "${CURRENT_URL}" != "${FORK_URL}" ]]; then
    echo "Warning: origin is ${CURRENT_URL}, expected ${FORK_URL}. Skipping remote change."
  fi
  git fetch --all --tags
  git pull --rebase --autostash || true
  git submodule update --init --recursive
else
  echo "Cloning your FreeCAD fork..."
  git clone --recurse-submodules "${FORK_URL}" "${REPO_NAME}"
  cd "${REPO_NAME}"
fi

# Determine parallel jobs if not provided
if [[ -z "${JOBS}" ]]; then
  if command -v nproc >/dev/null 2>&1; then
    CORES="$(nproc)"
  else
    CORES=4
  fi
  # Keep one core free for responsiveness
  JOBS="$(( CORES > 1 ? CORES - 1 : 1 ))"
fi

echo "Configuring with CMAKE_BUILD_TYPE=${BUILD_TYPE}"
# Some FreeCAD pixi setups expose tasks like: initialize, configure, build, freecad
# We pass extra cmake flags after '--'
# initialize (if present) is idempotent, so we try it but don't fail if absent.
if pixi task list 2>/dev/null | grep -q -E '(^| )initialize( |$)'; then
  pixi run initialize || true
fi

pixi run configure -- -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"

echo "Building (jobs: ${JOBS})..."
# Many setups accept -j N after the task; if not, CMake/Ninja still picks up -j via envs.
pixi run build -- -j "${JOBS}"

# Create a simple launcher
mkdir -p "$(dirname "${LAUNCHER}")"
cat > "${LAUNCHER}" <<EOF
#!/usr/bin/env bash
set -euo pipefail
cd "${REPO_ROOT}/${REPO_NAME}"
# Launch FreeCAD from the pixi environment
exec pixi run freecad "\$@"
EOF
chmod +x "${LAUNCHER}"

echo
echo "✅ FreeCAD dev environment ready."
echo "Repo: ${REPO_ROOT}/${REPO_NAME}"
echo "Build type: ${BUILD_TYPE}"
echo "Run it with: ${LAUNCHER}"
echo "Or manually: cd ${REPO_ROOT}/${REPO_NAME} && pixi run freecad"
echo
echo "Tips:"
echo " - Reconfigure with a different type: pixi run configure -- -DCMAKE_BUILD_TYPE=Debug"
echo " - Rebuild quickly: pixi run build -- -j ${JOBS}"
echo " - Debug (GDB):    pixi shell && gdb --args ./build/bin/FreeCAD"

