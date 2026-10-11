# TODO:
# - bw-cli (auth?)
# - doesn't work without pre-configuring git SSH keys, which is quite silly to me
# - include ghostty + tailscale?
#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
DOTFILES_REPO_HTTPS="https://github.com/connor15mcc/dotfiles.git"
DOTFILES_REPO_SSH="git@github.com:connor15mcc/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Parse arguments
dry_run=false
help=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run|-n)
            dry_run=true
            shift
            ;;
        --help|-h)
            help=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Help text
if [ "$help" = true ]; then
    echo "Bootstrap script for Connor's dotfiles with mise"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dry-run, -n    Show what would be done without executing"
    echo "  --help, -h       Show this help message"
    echo ""
    echo "This script will:"
    echo "  1. Install mise if not present"
    echo "  2. Setup git config and alias"
    echo "  3. Install tools via mise"
    echo "  4. Initialize all tools (zellij, atuin, neovim, etc.)"
    echo "  5. Source shell configuration"
    echo ""
    exit 0
fi

# Utility functions
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Main bootstrap logic
main() {
    info "🚀 Starting dotfiles bootstrap with mise..."

    # 1. Install mise if not present
    if ! command -v mise &> /dev/null; then
        info "📦 Installing mise..."
        curl https://mise.run | MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh
    else
        info "✅ mise already installed: $(mise --version)"
    fi

    # 2. Setup dotfiles repository (if not already set up)
    if [ ! -d "$DOTFILES_DIR" ]; then
        info "📁 Cloning dotfiles repository..."
        git clone --bare "$DOTFILES_REPO_HTTPS" "$DOTFILES_DIR"

        git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME config --local status.showUntrackedFiles no
        git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME remote set-url --push origin "$DOTFILES_REPO_SSH"
        git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME checkout

        # Setup git alias and config
        alias config='git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME'

        info "✅ Dotfiles cloned and configured"
        mv "$HOME/.zshrc-edits" "$HOME/.zshrc" # very temporary and hacky to iterate on zshrc
        export PATH=$HOME/.local/bin:$PATH
    else
        info "📁 Dotfiles already exists"
        # Set up the config alias if it doesn't exist
        if ! alias config >/dev/null 2>&1; then
            alias config='git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME'
        fi
    fi

    # 3. Install tools with mise
    info "🔧 Installing tools via mise..."
    if [ "$dry_run" = true ]; then
        mise install --dry-run
        mise run init-tools --dry-run
    else
        mise install
        info "🔧 Running mise initialization tasks..."
        mise run init-tools
    fi

    info ""
    info "To update shell to fish, run:             \`chsh -s \$(which fish)\`"
    info "Add it to the list of allowed shells via: \`echo \$(which fish) | sudo tee -a /etc/shells >/dev/null\`"
}

# Run main function
main "$@"
