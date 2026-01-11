#!/bin/bash
set -euo pipefail

SERVICE_NAME="git-autopush.service"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"
SCRIPT_FILE="/usr/local/sbin/git-autopush.sh"
LOG_FILE="/var/log/git-autopush.log"

GIT_USER="gintarich"
WORKDIR="/home/${GIT_USER}"
REPO_PATH="/home/${GIT_USER}/Personal/Notes/Notes"

install_script() {
    echo "[*] Writing $SCRIPT_FILE"
    cat > "$SCRIPT_FILE" <<'EOF'
#!/bin/bash
set -euo pipefail

logfile="/var/log/git-autopush.log"
timestamp="$(date '+%Y-%m-%d %H:%M:%S %z')"

echo "[$timestamp] --- git-autopush START ---" >> "$logfile"

# Repos to auto-commit/push
repos=(
    /home/gintarich/Personal/Notes/Notes
)

for repo in "${repos[@]}"; do
    echo "[$timestamp] Processing $repo" >> "$logfile"

    if [ ! -d "$repo/.git" ]; then
        echo "[$timestamp] SKIP: not a git repo" >> "$logfile"
        continue
    fi

    cd "$repo"

    git add -A

    if ! git diff --cached --quiet; then
        msg="autosave before shutdown: $timestamp"
        echo "[$timestamp] Commit: $msg" >> "$logfile"
        git commit -m "$msg" || true

        if git push >> "$logfile" 2>&1; then
            echo "[$timestamp] PUSH OK" >> "$logfile"
        else
            echo "[$timestamp] PUSH FAILED" >> "$logfile"
        fi
    else
        echo "[$timestamp] No changes to commit" >> "$logfile"
    fi
done

echo "[$timestamp] --- git-autopush END ---" >> "$logfile"
EOF

    chmod +x "$SCRIPT_FILE"
}

install_logfile() {
    if [ ! -f "$LOG_FILE" ]; then
        echo "[*] Creating $LOG_FILE"
        touch "$LOG_FILE"
    fi
    chmod 666 "$LOG_FILE"
}

install_service() {
    echo "[*] Writing $SERVICE_FILE"
    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Auto-commit and push Git repos when shutting down
After=network-online.target
Requires=network-online.target

[Service]
Type=simple
User=${GIT_USER}
WorkingDirectory=${WORKDIR}
ExecStart=/bin/sleep infinity
ExecStop=${SCRIPT_FILE}
TimeoutStopSec=30
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOF
}

enable_service_if_needed() {
    # is-enabled returns "enabled" / "disabled" / "static" / "indirect" / "generated" / "masked"
    local enabled_state
    enabled_state="$(systemctl is-enabled "$SERVICE_NAME" 2>/dev/null || echo "disabled")"

    if [ "$enabled_state" != "enabled" ]; then
        echo "[*] Enabling $SERVICE_NAME"
        systemctl enable "$SERVICE_NAME"
    else
        echo "[*] $SERVICE_NAME already enabled"
    fi
}

start_service_if_needed() {
    # is-active returns "active" / "inactive" / "failed" / etc.
    local active_state
    active_state="$(systemctl is-active "$SERVICE_NAME" 2>/dev/null || echo "inactive")"

    if [ "$active_state" != "active" ]; then
        echo "[*] Starting $SERVICE_NAME"
        systemctl start "$SERVICE_NAME"
    else
        echo "[*] $SERVICE_NAME already running"
    fi
}

main() {
    # Basic sanity checks first
    if [ ! -d "$REPO_PATH/.git" ]; then
        echo "[WARN] Repo $REPO_PATH does not look like a git repo. Continuing anyway."
    fi

    if ! id "$GIT_USER" >/dev/null 2>&1; then
        echo "[ERROR] User $GIT_USER does not exist on this system."
        exit 1
    fi

    echo "[*] Installing/updating git-autopush script..."
    install_script

    echo "[*] Ensuring log file exists and is writable..."
    install_logfile

    if [ -f "$SERVICE_FILE" ]; then
        echo "[*] Service file already exists: $SERVICE_FILE"
        # We still rewrite it to ensure it's up to date with latest definition.
        install_service
    else
        echo "[*] Creating new service file: $SERVICE_FILE"
        install_service
    fi

    echo "[*] Reloading systemd daemon..."
    systemctl daemon-reload

    echo "[*] Making sure service is enabled on boot..."
    enable_service_if_needed

    echo "[*] Making sure service is running now..."
    start_service_if_needed

    echo "[*] Done."
    echo
    echo "Status:"
    systemctl status "$SERVICE_NAME" --no-pager || true
}

main "$@"
