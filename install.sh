#!/bin/bash

##  _          _ _
## | |__   ___| | | ___
## | '_ \ / _ \ | |/ _ \
## | | | |  __/ | | (_) |
## |_| |_|\___|_|_|\___/
##
## NairoVIM Installation Script - Optimized Version
## Enhanced with better error handling, progress indicators, and colorful output

set -euo pipefail  # Exit on any error, undefined variable, or pipe failure

# ======================================================================
# COLOR DEFINITIONS & STYLING
# ======================================================================
readonly textreset=$(tput sgr0)
readonly red=$(tput setaf 1)
readonly yellow=$(tput setaf 3)
readonly green=$(tput setaf 2)
readonly cyan=$(tput setaf 6)
readonly blue=$(tput setaf 4)
readonly magenta=$(tput setaf 5)
readonly orange=$(tput setaf 3)  # Use yellow/brown for orange
readonly purple=$(tput setaf 5)  # Use magenta for purple
readonly bold=$(tput bold)
readonly dim=$(tput dim)

# Enhanced symbols with better Unicode support
readonly CHECK_MARK="✓"
readonly CROSS_MARK="✗"
readonly ARROW_RIGHT="→"
readonly STAR="★"
readonly GEAR="⚙"
readonly ROCKET="🚀"
readonly PACKAGE="📦"
readonly LINK="🔗"
readonly SPARKLES="✨"
readonly HOURGLASS="⏳"

# ======================================================================
# UTILITY FUNCTIONS
# ======================================================================

# Print header with enhanced styling
print_header() {
    echo ""
    echo "${bold}${cyan}╔══════════════════════════════════════════════════════════════════════════════════════╗${textreset}"
    echo "${bold}${cyan}║${textreset}  ${bold}${magenta}$1${textreset}${cyan}${bold}                                                                                   ║${textreset}"
    echo "${bold}${cyan}╚══════════════════════════════════════════════════════════════════════════════════════╝${textreset}"
    echo ""
}

# Print section header
print_section() {
    echo ""
    echo "${bold}${blue}▓▓▓ $1 ▓▓▓${textreset}"
    echo ""
}

# Print step with icon
print_step() {
    echo "${cyan}${HOURGLASS} ${bold}$1${textreset} ${dim}$2${textreset}"
}

# Print success message
print_success() {
    echo "${green}${CHECK_MARK} ${bold}Done${textreset} - $1"
}

# Print error message
print_error() {
    echo "${red}${CROSS_MARK} ${bold}Error${textreset} - $1" >&2
}

# Print warning message
print_warning() {
    echo "${yellow}⚠ ${bold}Warning${textreset} - $1"
}

# Print info message
print_info() {
    echo "${blue}ℹ ${bold}Info${textreset} - $1"
}

# Enhanced progress spinner
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if brew is installed
check_brew() {
    if ! command_exists brew; then
        print_error "Homebrew is not installed. Please install Homebrew first:"
        echo "  ${cyan}/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${textreset}"
        exit 1
    fi
}

# Install package with brew if not already installed
install_with_brew() {
    local package=$1
    local display_name=${2:-$package}

    if command_exists "$package"; then
        print_info "$display_name is already installed, skipping..."
        return 0
    fi

    print_step "Installing $display_name" "via Homebrew"

    if brew install --quiet "$package" 2>/dev/null; then
        print_success "Installed $display_name"
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

# Create symlink with backup
create_symlink() {
    local source=$1
    local target=$2
    local name=$3

    if [[ -L "$target" ]]; then
        print_info "$name symlink already exists, updating..."
        rm "$target"
    elif [[ -e "$target" ]]; then
        print_warning "$name file exists, backing up to ${target}.backup"
        mv "$target" "${target}.backup"
    fi

    ln -sf "$source" "$target"
    echo "    ${green}${LINK} $name${textreset} → ${dim}$target${textreset}"
}

# Setup directory with proper handling
setup_directory() {
    local target_dir=$1
    local source_dir=$2
    local name=$3

    if [[ -d "$target_dir" ]]; then
        print_warning "$name directory already exists, backing up..."
        mv "$target_dir" "${target_dir}.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    mkdir -p "$(dirname "$target_dir")"
    ln -sf "$source_dir" "$target_dir"
    print_success "Linked $name configuration"
}

# Clone repository with proper error handling
clone_repository() {
    local repo_url=$1
    local target_dir=$2
    local name=$3

    if [[ -d "$target_dir" ]]; then
        print_info "$name already exists, skipping clone..."
        return 0
    fi

    print_step "Cloning $name" "from $repo_url"

    if git clone --quiet "$repo_url" "$target_dir" 2>/dev/null; then
        print_success "Cloned $name"
    else
        print_error "Failed to clone $name"
        return 1
    fi
}

# ======================================================================
# MAIN INSTALLATION FUNCTIONS
# ======================================================================

install_dotfiles() {
    print_section "${LINK} Linking Dotfiles"

    local dotfiles=(".zshrc" ".tmux.conf" ".ripgreprc")

    for dotfile in "${dotfiles[@]}"; do
        if [[ -f "$(pwd)/$dotfile" ]]; then
            create_symlink "$(pwd)/$dotfile" "$HOME/$dotfile" "$dotfile"
        else
            print_warning "Dotfile $dotfile not found in $(pwd)"
        fi
    done

    # Export RIPGREP_CONFIG_PATH
    export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
    print_info "RIPGREP_CONFIG_PATH exported"

    local scooter_config_target="$HOME/.config/scooter/config.toml"
    mkdir -p "$(dirname "$scooter_config_target")"
    create_symlink "$(pwd)/scooter.config.toml" "$HOME/.config/scooter/config.toml" "Scooter config"

    local ghostty_config_target="$HOME/.config/ghostty/config"
    mkdir -p "$(dirname "$ghostty_config_target")"
    create_symlink "$(pwd)/ghostty_config" "$HOME/.config/ghostty/config" "Ghostty config"


    echo ""
    print_success "All dotfiles linked successfully!"
}

install_neovim() {
    print_section "${ROCKET} Installing Neovim"

    install_with_brew "neovim" "Neovim"

    print_step "Setting up Neovim configuration" "~/.config/nvim"

    local nvim_config_source="$(pwd)/nvim"
    local nvim_config_target="$HOME/.config/nvim"

    if [[ ! -d "$nvim_config_source" ]]; then
        print_error "Neovim configuration source not found at $nvim_config_source"
        return 1
    fi

    setup_directory "$nvim_config_target" "$nvim_config_source" "Neovim"

    echo ""
    print_success "Neovim installation and configuration complete!"
}

install_tmux() {
    print_section "${GEAR} Installing Tmux & Plugin Manager"

    install_with_brew "tmux" "Tmux"

    print_step "Setting up Tmux Plugin Manager (TPM)" "~/.tmux/plugins/tpm"

    local tpm_dir="$HOME/.tmux/plugins/tpm"
    clone_repository "https://github.com/tmux-plugins/tpm" "$tpm_dir" "TPM"

    echo ""
    print_success "Tmux and TPM setup complete!"
}

install_oh_my_zsh() {
    print_section "${SPARKLES} Installing Oh My Zsh"

    local oh_my_zsh_dir="$HOME/.oh-my-zsh"

    if [[ -d "$oh_my_zsh_dir" ]]; then
        print_info "Oh My Zsh already exists, skipping installation..."
        return 0
    fi

    print_step "Installing Oh My Zsh" "interactive installation"
    print_warning "This will open an interactive installation. Please follow the prompts."

    # Download and run the installation script
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
        print_success "Oh My Zsh installed successfully!"
        print_info "Consider installing a theme like powerlevel10k for enhanced experience"
    else
        print_error "Failed to install Oh My Zsh"
        return 1
    fi
}

install_cli_tools() {
    print_section "${PACKAGE} Installing CLI Tools"
    local tools=(
        "fzf:FZF (Terminal fuzzy finder)"
        "ripgrep:ripgrep (Fast search tool)"
        "bat:bat (Enhanced cat with syntax highlighting)"
        "scooter:scooter (Interactive search and replace in the terminal)"
    )
    for tool_info in "${tools[@]}"; do
        IFS=':' read -r tool_name tool_desc <<< "$tool_info"
        install_with_brew "$tool_name" "$tool_desc"
    done

    echo ""
    print_success "All CLI tools installed successfully!"
}

install_uv() {
    print_section "${STAR} Installing UV/UVX"

    if command_exists uv; then
        print_info "UV is already installed, skipping..."
        return 0
    fi

    print_step "Installing UV/UVX" "for MCP plugins installation"

    if curl -LsSf https://astral.sh/uv/install.sh | sh; then
        print_success "UV/UVX installed successfully!"
        print_info "UV/UVX is now available for MCP plugin management"
    else
        print_error "Failed to install UV/UVX"
        return 1
    fi
}

install_lazygit() {
    print_section "${GEAR} Installing Lazygit"

    # Install lazygit
    if ! command_exists lazygit; then
        print_step "Installing Lazygit" "via Homebrew"
        if brew install --quiet jesseduffield/lazygit/lazygit && brew link --overwrite lazygit; then
            print_success "Lazygit installed successfully!"
        else
            print_error "Failed to install Lazygit"
            return 1
        fi
    else
        print_info "Lazygit is already installed, skipping..."
    fi

    # Setup lazygit configuration
    print_step "Setting up Lazygit configuration" "~/.config/lazygit/config.yml"

    local lazygit_config_source="$(pwd)/lazygit_config.yml"
    local lazygit_config_target="$HOME/.config/lazygit/config.yml"

    if [[ -f "$lazygit_config_source" ]]; then
        mkdir -p "$(dirname "$lazygit_config_target")"
        create_symlink "$lazygit_config_source" "$lazygit_config_target" "Lazygit config"
        export CONFIG_DIR="$HOME/.config/lazygit"
        print_success "Lazygit configuration linked successfully!"
    else
        print_warning "Lazygit configuration file not found at $lazygit_config_source"
    fi
}

print_installation_summary() {
    echo ""
    echo "${bold}${magenta}╔══════════════════════════════════════════════════════════════════════════════════════╗${textreset}"
    echo "${bold}${magenta}║${textreset}  ${bold}${green}🎉 INSTALLATION COMPLETE! 🎉${textreset}${magenta}${bold}                                                       ║${textreset}"
    echo "${bold}${magenta}╚══════════════════════════════════════════════════════════════════════════════════════╝${textreset}"
    echo ""
    echo "${bold}${cyan}📋 Installation Summary:${textreset}"
    echo "${green}${CHECK_MARK}${textreset} Dotfiles linked (.zshrc, .vimrc, .tmux.conf, .ripgreprc)"
    echo "${green}${CHECK_MARK}${textreset} Neovim installed and configured"
    echo "${green}${CHECK_MARK}${textreset} Tmux installed with Plugin Manager (TPM)"
    echo "${green}${CHECK_MARK}${textreset} Oh My Zsh installed"
    echo "${green}${CHECK_MARK}${textreset} CLI tools installed (fzf, ripgrep, bat)"
    echo "${green}${CHECK_MARK}${textreset} UV/UVX installed for MCP plugins"
    echo "${green}${CHECK_MARK}${textreset} Lazygit installed and configured"
    echo ""
    echo "${bold}${yellow}🚀 Next Steps:${textreset}"
    echo "${cyan}1.${textreset} Run ${bold}${cyan}tmux${textreset} to start your enhanced terminal session"
    echo "${cyan}2.${textreset} Run ${bold}${cyan}nvim${textreset} to start Neovim and let plugins install"
    echo "${cyan}3.${textreset} In tmux, press ${bold}${cyan}prefix + I${textreset} to install tmux plugins"
    echo "${cyan}4.${textreset} Consider installing ${bold}${cyan}powerlevel10k${textreset} theme for enhanced zsh experience"
    echo ""
    echo "${bold}${green}🎊 Happy coding with NairoVIM! 🎊${textreset}"
    echo ""
}

# ======================================================================
# ERROR HANDLING
# ======================================================================

cleanup() {
    echo ""
    print_error "Installation interrupted or failed"
    echo "${yellow}Please check the error messages above and try again.${textreset}"
    exit 1
}

# Trap errors and interrupts
trap cleanup ERR INT TERM

# ======================================================================
# MAIN EXECUTION
# ======================================================================

main() {
    # Print welcome header
    print_header "🚀 NairoVIM Installation Script - Enhanced Edition 🚀"

    echo "${bold}${cyan}Welcome to the enhanced NairoVIM installation script!${textreset}"
    echo "${dim}This script will install and configure your complete development environment.${textreset}"
    echo ""

    # Check prerequisites
    print_step "Checking prerequisites" "Homebrew availability"
    check_brew
    print_success "Prerequisites check passed"

    # Start installation process
    echo ""
    echo "${bold}${cyan}🔧 Starting installation process...${textreset}"

    # Execute installation steps
    install_dotfiles
    install_neovim
    install_tmux
    install_oh_my_zsh
    install_cli_tools
    install_uv
    install_lazygit

    # Print final summary
    print_installation_summary
}

# ======================================================================
# SCRIPT EXECUTION
# ======================================================================

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

