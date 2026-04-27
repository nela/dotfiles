#!/usr/bin/env bash
set -o errexit

# --- Configuration -----------------------------------------------------------
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

BREW_PACKAGES=(
    alacritty
    asdf
    bash-language-server
    bat
    bitwarden
    btop
    fd
    firefox
    font-meslo-for-powerlevel10k
    forgit
    fzf
    ghostty
    git-delta
    go
    gopls
    jq
    llvm
    lua-language-server
    neovim
    ripgrep
    shellcheck
    shfmt
    spotify
    stylua
    taplo
    tmux
    tpm
    zsh-fast-syntax-highlighting
)

PACMAN_PACKAGES=(
    awesome-terminal-fonts
    base
    base-devel
    bash-language-server
    bat
    bitwarden
    bluetui
    bluez
    bluez-utils
    brightnessctl
    btop
    fd
    ffmpeg
    ffmpegthumbnailer
    firefox
    fontconfig
    fzf
    ghostty
    go
    gopls
    impala
    iwd
    jq
    lact
    llvm
    lua-language-server
    luarocks
    mako
    man-db
    man-pages
    mpd
    mpd-mpris
    neovim
    nodejs
    pacman-contrib
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    pnpm
    powerline-fonts
    qt5-base
    qt5-declarative
    qt5-wayland
    qt6-base
    qt6-declarative
    qt6-wayland
    ripgrep
    shellcheck
    shfmt
    strace
    stylua
    taplo
    terminus-font
    thunar
    thunar-archive-plugin
    tmux
    waybar
    wayland
    wget
    wireplumber
    wl-clipboard
    xdg-desktop-portal
    xorg-xwayland
    zip
    zoxide
)

AUR_PACKAGES=(
    asdf-vm
    forgit
    glsl-language-server
    glslviewer
    quickshell-git
    tmux-plugin-manager
    ttf-meslo-nerd-font-powerlevel10k
    zlaunch-bin
    zsh-fast-syntax-highlighting
    zsh-theme-powerlevel10k-git
)

NIRI_PACKAGES=(
    niri
    xdg-desktop-portal-gnome
)

HYPRLAND_PACKAGES=(
    hyprland
    hypridle
    hyprpaper
    hyprpicker
    uwsm
    xdg-desktop-portal-gtk
)

HYPRLAND_AUR_PACKAGES=(
    hyprpolkitagent
    wlogout
)

SYMLINKS=(
    "$DOTFILES/alacritty/.config/alacritty  $XDG_CONFIG_HOME/alacritty"
    "$DOTFILES/bat/.config/bat              $XDG_CONFIG_HOME/bat"
    "$DOTFILES/fd/.config/fd                $XDG_CONFIG_HOME/fd"
    "$DOTFILES/ghostty                      $XDG_CONFIG_HOME/ghostty"
    "$DOTFILES/nvim/.config/nvim            $XDG_CONFIG_HOME/nvim"
    "$DOTFILES/pnpm/.config/pnpm            $XDG_CONFIG_HOME/pnpm"
    "$DOTFILES/tmux/tmux.conf               $HOME/.tmux.conf"
    "$DOTFILES/zsh/.zshenv                  $HOME/.zshenv"
)

# --- Helpers -----------------------------------------------------------------
C_RED="\033[1;31m"
C_GREEN="\033[1;32m"
C_BLUE="\033[1;34m"
C_YELLOW="\033[1;33m"
C_CYAN="\033[1;36m"
C_RESET="\033[0m"

info()  { printf "${C_BLUE}[info]${C_RESET}  %s\n" "$*"; }
warn()  { printf "${C_YELLOW}[warn]${C_RESET}  %s\n" "$*"; }
error() { printf "${C_RED}[error]${C_RESET} %s\n" "$*" >&2; exit 1; }
command_exists() { command -v "$1" 1>/dev/null; }

_package_install() {
    local manager="${1}"
    shift
    local packages=("${@}")

    ((${#packages[@]} == 0)) && return

    case "${manager}" in
        pacman)
            sudo pacman -S --needed --noconfirm "${packages[@]}"
            ;;
        yay)
            yay -S --needed --noconfirm "${packages[@]}"
            ;;
        brew)
            brew install "${packages[@]}"
            ;;
    esac
}

_display_packages() {
    local heading="${1}"
    shift
    local packages=("${@}")

    printf "\n:: %s\n" "${heading}"

    if ((${#packages[@]} == 0)); then
        echo "   (none)"
        return
    fi

    for item in "${packages[@]}"; do
        echo "   - ${item}"
    done
}

# --- Functions ---------------------------------------------------------------
warn_root() {
    [[ "${EUID}" != 0 ]] && return 0

    while true; do
        printf "This script is meant to run as a non-root user. Are you sure? (y/n) "
        read -r yn
        case "${yn}" in
            [Yy]*) break ;;
            [Nn]*) exit ;;
            *) printf "Please answer y or n\n\n" ;;
        esac
    done
}

check_prereqs() {
    info "Checking prerequisites"

    local missing=()

    command_exists git  || missing+=("git")
    command_exists curl || missing+=("curl")

    if ((${#missing[@]} > 0)); then
        error "Missing required commands: ${missing[*]}"
    fi

    if command_exists sudo; then
        sudo -v
    fi

    info "Prerequisites satisfied"
}

detect_os() {
    case "$(uname -s)" in
        Darwin) OS="macos" ;;
        Linux)
            if [ -f /etc/arch-release ]; then
                OS="arch"
            else
                error "Unsupported Linux distribution"
            fi
            ;;
        *)
            error "Unsupported OS: $(uname -s)"
            ;;
    esac
    info "Detected OS: $OS"
}

create_dirs() {
    info "Creating directories"
    mkdir -p \
        "$HOME/.cache" \
        "$HOME/.cache/less" \
        "$HOME/.cache/zoxide" \
        "$XDG_CONFIG_HOME" \
        "$HOME/.local/bin" \
        "$HOME/.local/etc" \
        "$HOME/.local/lib" \
        "$XDG_DATA_HOME" \
        "$XDG_DATA_HOME/pnpm" \
        "$XDG_DATA_HOME/pnpm/global" \
        "$XDG_DATA_HOME/tmux" \
        "$HOME/.cache/pnpm" \
        "$HOME/.local/state" \
        "$HOME/.local/state/pnpm"
}

confirm_packages() {
    local niri="${1}"
    local hyprland="${2}"
    local skip_aur="${3}"

    case "$OS" in
        macos)
            _display_packages "Brew" "${BREW_PACKAGES[@]}"
            ;;
        arch)
            _display_packages "Pacman" "${PACMAN_PACKAGES[@]}"
            if [ "$skip_aur" = false ]; then
                _display_packages "AUR" "${AUR_PACKAGES[@]}"
            fi
            if [ "$niri" = true ]; then
                _display_packages "Niri" "${NIRI_PACKAGES[@]}"
            fi
            if [ "$hyprland" = true ]; then
                _display_packages "Hyprland (pacman)" "${HYPRLAND_PACKAGES[@]}"
                _display_packages "Hyprland (AUR)" "${HYPRLAND_AUR_PACKAGES[@]}"
            fi
            ;;
    esac

    printf "\n"
    while true; do
        printf "Do you want to install the above packages? (y/n) "
        read -r yn
        case "${yn}" in
            [Yy]*) break ;;
            [Nn]*) exit ;;
            *) printf "Please answer y or n\n\n" ;;
        esac
    done
}

install_macos() {
    info "Setting up macOS packages"

    if ! command_exists brew; then
        info "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    _package_install brew "${BREW_PACKAGES[@]}"
}

install_arch() {
    _package_install pacman "${PACMAN_PACKAGES[@]}"
}

install_yay() {
    if command_exists yay; then
        info "yay already installed"
        return
    fi

    info "Installing yay"
    mkdir --parents "$HOME/pkgs"
    if [ -d "$HOME/pkgs/yay-bin" ]; then
        git -C "$HOME/pkgs/yay-bin" pull
    else
        git clone https://aur.archlinux.org/yay-bin.git "$HOME/pkgs/yay-bin"
    fi
    (cd "$HOME/pkgs/yay-bin" && makepkg --syncdeps --install --noconfirm)
}

install_aur() {
    if ! command_exists yay; then
        warn "yay not found — skipping AUR packages"
        return
    fi

    _package_install yay "${AUR_PACKAGES[@]}"
}

install_niri() {
    _package_install pacman "${NIRI_PACKAGES[@]}"
}

install_hyprland() {
    _package_install pacman "${HYPRLAND_PACKAGES[@]}"

    if command_exists yay; then
        _package_install yay "${HYPRLAND_AUR_PACKAGES[@]}"
    else
        warn "yay not found — skipping Hyprland AUR packages"
    fi
}

setup_zsh() {
    if [ "$(basename "$SHELL")" = "zsh" ]; then
        info "Already using zsh"
        return
    fi

    if ! command_exists zsh; then
        info "Installing zsh"
        sudo pacman -S --noconfirm zsh
    fi

    local shell_path
    shell_path="$(command -v zsh)"

    if ! grep -q "${shell_path}" /etc/shells 2>/dev/null; then
        echo "${shell_path}" | sudo tee -a /etc/shells 1>/dev/null
    fi

    info "Changing shell to zsh for $USER"
    chsh --shell "${shell_path}"
}

setup_gitconfig() {
    local gitconfig="$HOME/.gitconfig"

    # Skip if git user is already configured
    local existing_name
    set +o errexit
    existing_name="$(git config user.name)"
    set -o errexit

    if [ -n "${existing_name}" ]; then
        info "Git already configured for '${existing_name}', skipping"
        return
    fi

    info "Setting up git configuration"

    local git_name=""
    while true; do
        printf "Name: "
        read -r git_name
        if [[ ${git_name} =~ [^[:space:]]+ ]]; then
            break
        else
            printf "Please enter at least your first name\n\n"
        fi
    done

    local git_email=""
    while true; do
        printf "Email: "
        read -r git_email
        if [[ ${git_email} =~ .+@.+ ]]; then
            break
        else
            printf "Please enter a valid email address\n\n"
        fi
    done

    cat > "$gitconfig" <<EOF
[user]
    name = ${git_name}
    email = ${git_email}

[include]
    path = ${DOTFILES}/git/gitconfig
EOF
    info "Created ~/.gitconfig"
}

clone_zsh_defer() {
    local dest="$XDG_DATA_HOME/zsh/zsh-defer"
    if [ -d "$dest" ]; then
        info "zsh-defer already cloned"
    else
        info "Cloning zsh-defer"
        mkdir -p "$XDG_DATA_HOME/zsh"
        git clone --depth 1 https://github.com/romkatv/zsh-defer.git "$dest"
    fi
}

create_symlinks() {
    info "Creating symlinks"
    for entry in "${SYMLINKS[@]}"; do
        read -r src dest <<< "$entry"
        if [ -e "$src" ]; then
            # Clean up existing symlinks to avoid nesting issues
            [ -L "$dest" ] && rm "$dest"
            ln -sfn "$src" "$dest"
            info "  $dest -> $src"
        else
            warn "  Source missing, skipped: $src"
        fi
    done
}

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    --niri        Install Niri compositor packages (Arch only)
    --hyprland    Install Hyprland desktop packages (Arch only)
    --skip-aur    Skip AUR packages (Arch only)
    -h, --help    Show this help
EOF
}

# --- Main --------------------------------------------------------------------
main() {
    local niri=false
    local hyprland=false
    local skip_aur=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --niri)     niri=true; shift ;;
            --hyprland) hyprland=true; shift ;;
            --skip-aur) skip_aur=true; shift ;;
            -h|--help)  usage; exit 0 ;;
            *)          error "Unknown option: $1" ;;
        esac
    done

    warn_root
    check_prereqs
    detect_os
    create_dirs

    confirm_packages "$niri" "$hyprland" "$skip_aur"

    case "$OS" in
        macos)
            install_macos
            ;;
        arch)
            install_arch
            if [ "$skip_aur" = false ]; then
                install_yay
                install_aur
            fi
            if [ "$niri" = true ]; then
                install_niri
            fi
            if [ "$hyprland" = true ]; then
                install_hyprland
            fi
            ;;
    esac

    clone_zsh_defer
    create_symlinks
    setup_zsh
    setup_gitconfig

    if [ "$OS" = "arch" ]; then
        local systemd_args=()
        [ "$niri" = true ] && systemd_args+=("--niri")
        "${DOTFILES}/systemd-setup.sh" "${systemd_args[@]}"
    fi

    info "Bootstrap complete!"
}

main "$@"
