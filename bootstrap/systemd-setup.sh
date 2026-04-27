#!/usr/bin/env bash
set -o errexit

# --- Configuration -----------------------------------------------------------
SYSTEM_SERVICES=(
    "bluetooth.service"
)

SESSION_SERVICES=(
    "mako.service"
    "pipewire.service"
    "pipewire-pulse.service"
    "waybar.service"
    "wireplumber.service"
)

# --- Helpers -----------------------------------------------------------------
C_BLUE="\033[1;34m"
C_YELLOW="\033[1;33m"
C_RED="\033[1;31m"
C_RESET="\033[0m"

info()  { printf "${C_BLUE}[info]${C_RESET}  %s\n" "$*"; }
warn()  { printf "${C_YELLOW}[warn]${C_RESET}  %s\n" "$*"; }
error() { printf "${C_RED}[error]${C_RESET} %s\n" "$*" >&2; exit 1; }

# --- Functions ---------------------------------------------------------------
configure_vconsole() {
    local vconsole="/etc/vconsole.conf"

    if grep -q "FONT=ter-132n" "$vconsole" 2>/dev/null; then
        info "vconsole.conf already configured"
        return
    fi

    info "Setting console font to ter-132n"
    sudo sed -i 's/^FONT=.*/FONT=ter-132n/' "$vconsole"
}

configure_system_services() {
    ((${#SYSTEM_SERVICES[@]} == 0)) && return

    printf "\n:: System services to enable:\n"
    for svc in "${SYSTEM_SERVICES[@]}"; do
        echo "   - ${svc}"
    done

    printf "\n"
    while true; do
        printf "Enable the above system services? (y/n) "
        read -r yn
        case "${yn}" in
            [Yy]*)
                for svc in "${SYSTEM_SERVICES[@]}"; do
                    sudo systemctl enable "${svc}"
                    info "Enabled ${svc}"
                done
                break
                ;;
            [Nn]*) info "Skipped system services"; break ;;
            *) printf "Please answer y or n\n\n" ;;
        esac
    done
}

configure_session_services() {
    local session_target="${1}"

    ((${#SESSION_SERVICES[@]} == 0)) && return

    printf "\n:: User services to bind to %s:\n" "${session_target}"
    for svc in "${SESSION_SERVICES[@]}"; do
        echo "   - ${svc}"
    done

    printf "\n"
    while true; do
        printf "Add the above services to %s? (y/n) " "${session_target}"
        read -r yn
        case "${yn}" in
            [Yy]*)
                for svc in "${SESSION_SERVICES[@]}"; do
                    systemctl --user add-wants "${session_target}" "${svc}"
                    info "Added ${svc} to ${session_target}"
                done
                break
                ;;
            [Nn]*) info "Skipped session services"; break ;;
            *) printf "Please answer y or n\n\n" ;;
        esac
    done
}

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    --niri        Configure session services for Niri
    -h, --help    Show this help
EOF
}

# --- Main --------------------------------------------------------------------
main() {
    local niri=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --niri)    niri=true; shift ;;
            -h|--help) usage; exit 0 ;;
            *)         error "Unknown option: $1" ;;
        esac
    done

    if [ ! -f /etc/arch-release ]; then
        error "This script is only for Arch Linux"
    fi

    configure_vconsole
    configure_system_services

    if [ "$niri" = true ]; then
        configure_session_services "niri-session.target"
    fi

    info "Systemd setup complete!"
}

main "$@"
