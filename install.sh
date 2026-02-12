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
    local description="${2:-}"  # Make second parameter optional
    if [[ -n "$description" ]]; then
        echo "${cyan}${HOURGLASS} ${bold}$1${textreset} ${dim}$description${textreset}"
    else
        echo "${cyan}${HOURGLASS} ${bold}$1${textreset}"
    fi
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
    local timestamp=$(date +%Y%m%d_%H%M%S)

    if [[ -L "$target" ]]; then
        # Check if it's a dangling symlink
        if [[ ! -e "$target" ]]; then
            print_warning "$name is a dangling symlink (target missing), removing..."
        else
            print_info "$name symlink already exists, updating..."
        fi
        rm "$target"
    elif [[ -e "$target" ]]; then
        # Add timestamp to prevent backup collision
        local backup_path="${target}.backup.${timestamp}"
        print_warning "$name file exists, backing up to ${backup_path}"
        mv "$target" "$backup_path"
        
        # Verify backup succeeded
        if [[ ! -e "$backup_path" ]]; then
            print_error "Failed to create backup of $name! Aborting."
            return 1
        fi
        
        print_success "Backup created: ${backup_path}"
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
# WSL DETECTION & HELPER FUNCTIONS
# ======================================================================

# Detect if script is running inside WSL
detect_wsl() {
    if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
        return 0  # Is WSL
    fi
    return 1  # Not WSL
}

# Get Windows username from WSL environment
get_windows_username() {
    # Method 1: Try using powershell.exe to get Windows username
    if command_exists powershell.exe; then
        local win_user=$(powershell.exe -NoProfile -Command '$env:USERNAME' 2>/dev/null | tr -d '\r\n')
        if [[ -n "$win_user" ]]; then
            echo "$win_user"
            return 0
        fi
    fi
    
    # Method 2: Check if WSL username matches a Windows user directory
    if [[ -d "/mnt/c/Users/$USER" ]]; then
        echo "$USER"
        return 0
    fi
    
    # Method 3: List available Windows users and prompt
    if [[ -d "/mnt/c/Users" ]]; then
        local users=($(ls -1 /mnt/c/Users 2>/dev/null | grep -v "^Public$\|^Default$\|^All Users$"))
        if [[ ${#users[@]} -eq 1 ]]; then
            # Only one user found
            echo "${users[0]}"
            return 0
        elif [[ ${#users[@]} -gt 1 ]]; then
            # Multiple users found, prompt
            print_warning "Multiple Windows user accounts detected"
            echo ""
            echo "Available Windows users:"
            local i=1
            for user in "${users[@]}"; do
                echo "  ${cyan}$i)${textreset} $user"
                ((i++))
            done
            echo ""
            echo -n "${yellow}Enter Windows username or number [1-${#users[@]}]: ${textreset}"
            read -r choice
            
            # Check if input is a number
            if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#users[@]} ]]; then
                echo "${users[$((choice-1))]}"
                return 0
            elif [[ -n "$choice" ]]; then
                echo "$choice"
                return 0
            fi
        fi
    fi
    
    return 1  # Failed to detect
}

# Check if mirrored networking is already configured
check_wsl_config_has_mirrored() {
    local config_file=$1
    
    if [[ ! -f "$config_file" ]]; then
        return 1  # File doesn't exist
    fi
    
    # Check if file contains networkingMode=mirrored under [wsl2] section
    local in_wsl2_section=false
    while IFS= read -r line; do
        # Remove leading/trailing whitespace and comments
        line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s/#.*//')
        
        # Check for section headers
        if [[ "$line" =~ ^\[.*\]$ ]]; then
            if [[ "$line" == "[wsl2]" ]]; then
                in_wsl2_section=true
            else
                in_wsl2_section=false
            fi
            continue
        fi
        
        # Check for networkingMode=mirrored in [wsl2] section
        if [[ "$in_wsl2_section" == true ]] && [[ "$line" =~ ^networkingMode[[:space:]]*=[[:space:]]*mirrored[[:space:]]*$ ]]; then
            return 0  # Found mirrored networking
        fi
    done < "$config_file"
    
    return 1  # Mirrored networking not found
}

# ======================================================================
# MAIN INSTALLATION FUNCTIONS
# ======================================================================

install_build_tools() {
    print_section "${GEAR} Installing Build Tools"
    
    print_info "Installing C compiler toolchain for Neovim plugin compilation..."
    print_info "This enables: telescope-fzf-native, nvim-treesitter, CopilotChat"
    
    # Detect OS
    local os_type="$(uname -s)"
    
    case "$os_type" in
        Darwin*)
            # macOS - Install Xcode Command Line Tools
            if ! command_exists gcc || ! command_exists make; then
                print_step "Installing Xcode Command Line Tools" "gcc, make, clang"
                
                # Check if Xcode CLI tools are already installed
                if xcode-select -p &>/dev/null; then
                    print_info "Xcode Command Line Tools already installed"
                else
                    # Install Xcode CLI tools
                    xcode-select --install 2>/dev/null || true
                    
                    print_warning "Please complete the Xcode Command Line Tools installation dialog"
                    print_info "After installation completes, re-run this script: ./install.sh"
                    
                    # Wait for user to complete installation
                    echo ""
                    read -p "Press Enter after completing the installation (or Ctrl+C to exit)..."
                fi
            fi
            
            # Install cmake via Homebrew
            install_with_brew "cmake" "CMake"
            ;;
            
        Linux*)
            # Linux - Use package manager
            print_step "Installing build tools" "gcc, make, cmake"
            
            if command_exists apt-get; then
                # Debian/Ubuntu
                if ! command_exists gcc || ! command_exists make; then
                    sudo apt-get update -qq
                    sudo apt-get install -y build-essential cmake
                    print_success "Installed build-essential and CMake (apt)"
                else
                    print_info "Build tools already installed"
                fi
            elif command_exists dnf; then
                # Fedora/RHEL
                if ! command_exists gcc || ! command_exists make; then
                    sudo dnf groupinstall -y "Development Tools"
                    sudo dnf install -y cmake
                    print_success "Installed Development Tools and CMake (dnf)"
                else
                    print_info "Build tools already installed"
                fi
            elif command_exists pacman; then
                # Arch Linux
                if ! command_exists gcc || ! command_exists make; then
                    sudo pacman -S --noconfirm base-devel cmake
                    print_success "Installed base-devel and CMake (pacman)"
                else
                    print_info "Build tools already installed"
                fi
            else
                print_warning "Unsupported Linux distribution. Please install gcc, make, and cmake manually."
            fi
            ;;
            
        *)
            print_warning "Unsupported OS: $os_type. Please install gcc, make, and cmake manually."
            ;;
    esac
    
    # Verify installations
    print_step "Verifying build tools installation"
    
    local build_tools_ready=true
    
    if command_exists gcc; then
        local gcc_version=$(gcc --version 2>&1 | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        if [[ -n "$gcc_version" ]]; then
            print_success "GCC compiler ready (v$gcc_version)"
        else
            print_success "GCC compiler ready"
        fi
    elif command_exists clang; then
        local clang_version=$(clang --version 2>&1 | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        if [[ -n "$clang_version" ]]; then
            print_success "Clang compiler ready (v$clang_version)"
        else
            print_success "Clang compiler ready"
        fi
    else
        print_warning "No C compiler found (gcc or clang)"
        build_tools_ready=false
    fi
    
    if command_exists make; then
        print_success "GNU Make ready"
    else
        print_warning "Make not found in PATH"
        build_tools_ready=false
    fi
    
    if command_exists cmake; then
        local cmake_version=$(cmake --version 2>&1 | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        if [[ -n "$cmake_version" ]]; then
            print_success "CMake ready (v$cmake_version)"
        else
            print_success "CMake ready"
        fi
    else
        print_warning "CMake not found in PATH"
        build_tools_ready=false
    fi
    
    if [[ "$build_tools_ready" = true ]]; then
        print_success "Build tools configured successfully"
    else
        print_warning "Some build tools may require shell restart to be available"
        print_info "Restart your terminal, then run: ./install.sh"
    fi
    
    echo ""
    print_success "Build tools installation complete!"
}

install_development_tools() {
    print_section "${PACKAGE} Installing Development Tools (Optional)"
    
    print_info "Development tools enable LSP servers for various languages in Neovim"
    print_info "Includes: Node.js (npm), Go, Python"
    echo ""
    
    # Prompt user with default Y
    read -p "Install development tools? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Skipping development tools installation"
        print_info "You can install later with: ${bold}brew install node go python${textreset}"
        return
    fi
    
    echo ""
    print_step "Installing development tools" "Node.js, Go, Python"
    
    # Detect OS and install accordingly
    case "$(uname -s)" in
        Darwin*)
            # macOS - Use Homebrew
            install_with_brew "node" "Node.js (npm)"
            install_with_brew "go" "Go (golang)"
            install_with_brew "python@3" "Python"
            ;;
        Linux*)
            # Linux - Detect and use appropriate package manager
            if command_exists apt-get; then
                print_step "Installing via apt" "nodejs, npm, golang, python3"
                sudo apt-get update -qq
                sudo apt-get install -y nodejs npm golang python3 python3-pip
            elif command_exists dnf; then
                print_step "Installing via dnf" "nodejs, golang, python3"
                sudo dnf install -y nodejs golang python3 python3-pip
            elif command_exists pacman; then
                print_step "Installing via pacman" "nodejs, go, python"
                sudo pacman -S --noconfirm nodejs npm go python python-pip
            elif command_exists zypper; then
                print_step "Installing via zypper" "nodejs, go, python3"
                sudo zypper install -y nodejs npm go python3 python3-pip
            else
                print_warning "Could not detect package manager. Please install manually:"
                print_info "  Node.js: https://nodejs.org/"
                print_info "  Go: https://golang.org/dl/"
                print_info "  Python: https://www.python.org/downloads/"
                return
            fi
            ;;
        *)
            print_warning "Unsupported OS: $(uname -s)"
            print_info "Please install Node.js, Go, and Python manually"
            return
            ;;
    esac
    
    echo ""
    print_step "Verifying installations" "checking versions"
    
    # Verify Node.js/npm
    if command_exists node && command_exists npm; then
        local node_version=$(node --version 2>/dev/null || echo "unknown")
        local npm_version=$(npm --version 2>/dev/null || echo "unknown")
        print_success "Node.js $node_version and npm $npm_version installed"
        print_info "${dim}  Enables: TypeScript, JavaScript, HTML, CSS, JSON LSP servers${textreset}"
    else
        print_warning "Node.js/npm verification failed - may need shell restart"
    fi
    
    # Verify Go
    if command_exists go; then
        local go_version=$(go version 2>/dev/null | awk '{print $3}' || echo "unknown")
        print_success "Go $go_version installed"
        print_info "${dim}  Enables: Go language server (gopls), gofumpt${textreset}"
    else
        print_warning "Go verification failed - may need shell restart"
    fi
    
    # Verify Python
    if command_exists python3 && command_exists pip3; then
        local python_version=$(python3 --version 2>/dev/null | awk '{print $2}' || echo "unknown")
        print_success "Python $python_version installed"
        print_info "${dim}  Enables: Python LSP servers and formatters${textreset}"
    else
        print_warning "Python verification failed - may need shell restart"
    fi
    
    echo ""
    print_success "Development tools installation complete!"
    print_info "After installation, run ${bold}:Mason${textreset} in Neovim to install LSP servers"
}

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

    # Check if zsh is installed first
    if ! command_exists zsh; then
        print_step "Installing zsh" "required for Oh My Zsh"
        install_with_brew "zsh" "Zsh shell"
    fi

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

# Detect potential secrets in configuration files
detect_secrets() {
    local file_path=$1
    
    if [[ ! -f "$file_path" ]]; then
        return 1
    fi
    
    # Look for common secret indicators (case-insensitive)
    if grep -qi "bearer\|api[_-]key\|token\|password\|secret" "$file_path" 2>/dev/null; then
        return 0  # Secrets detected
    fi
    
    return 1  # No secrets detected
}

# Analyze agents directory for custom (non-repo) agents
analyze_custom_agents() {
    local user_agents_dir=$1
    local repo_agents_dir=$2
    
    if [[ ! -d "$user_agents_dir" ]]; then
        return 1  # No user agents directory
    fi
    
    local custom_count=0
    
    # Find agents in user dir that don't exist in repo
    while IFS= read -r -d '' user_agent; do
        local basename=$(basename "$user_agent")
        if [[ ! -f "$repo_agents_dir/$basename" ]]; then
            ((custom_count++))
            echo "$basename"  # Output custom agent name
        fi
    done < <(find "$user_agents_dir" -type f -name "*.md" -print0 2>/dev/null)
    
    return $custom_count
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

install_opencode() {
    print_section "${STAR} Installing and Configuring OpenCode"

    # Install OpenCode if not already installed
    if ! command_exists opencode; then
        print_step "Installing OpenCode" "via Homebrew"
        if brew install --quiet anomalyco/tap/opencode 2>/dev/null; then
            print_success "OpenCode installed successfully!"
        else
            print_error "Failed to install OpenCode"
            return 1
        fi
    else
        print_info "OpenCode is already installed, skipping..."
    fi

    # Setup OpenCode configuration
    print_step "Setting up OpenCode configuration" "~/.config/opencode"

    local opencode_config_source="$(pwd)/opencode_global_config"
    local opencode_config_target="$HOME/.config/opencode"

    if [[ ! -d "$opencode_config_source" ]]; then
        print_error "OpenCode configuration source not found at $opencode_config_source"
        return 1
    fi

    # Create target directory if it doesn't exist
    mkdir -p "$opencode_config_target"

    # Initialize backup session for this run
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_session="$opencode_config_target/.backups/$timestamp"
    mkdir -p "$backup_session"
    echo "OpenCode configuration backup - $(date)" > "$backup_session/info.txt"

    # =================================================================
    # Handle opencode.json with secret detection
    # =================================================================
    local opencode_json_source="$opencode_config_source/opencode.json"
    local opencode_json_target="$opencode_config_target/opencode.json"

    if [[ -f "$opencode_json_source" ]]; then
        # Check for secrets in existing config
        if [[ -f "$opencode_json_target" ]] && ! [[ -L "$opencode_json_target" ]]; then
            if detect_secrets "$opencode_json_target"; then
                print_warning "Detected potential secrets/API keys in your opencode.json!"
                echo ""
                echo "${bold}${yellow}Your configuration may contain sensitive data${textreset}"
                echo ""
                echo "${bold}${cyan}Options:${textreset}"
                echo "  ${cyan}1)${textreset} Backup current config, symlink to repo (you'll need to re-add secrets)"
                echo "  ${cyan}2)${textreset} Keep your current file (recommended if you have custom secrets)"
                echo "  ${cyan}3)${textreset} Abort installation"
                echo ""
                echo -n "${yellow}Choose [1-3] (default: 2): ${textreset}"
                read -r choice
                choice=${choice:-2}  # Default to option 2 (keep current)
                
                case "$choice" in
                    1)
                        local backup_path="$backup_session/opencode.json"
                        cp "$opencode_json_target" "$backup_path"
                        
                        if [[ ! -f "$backup_path" ]]; then
                            print_error "Failed to backup opencode.json! Aborting."
                            return 1
                        fi
                        
                        print_success "Backed up to: $backup_path"
                        rm "$opencode_json_target"
                        ln -sf "$opencode_json_source" "$opencode_json_target"
                        print_success "Symlinked opencode.json (restore secrets from backup)"
                        echo "${dim}    To restore secrets: review $backup_path${textreset}"
                        ;;
                    2)
                        print_info "Keeping your existing opencode.json (skipping symlink)"
                        ;;
                    3)
                        print_error "Installation aborted by user"
                        return 1
                        ;;
                    *)
                        print_error "Invalid choice, keeping existing file"
                        ;;
                esac
            else
                # No secrets detected, safe to symlink
                create_symlink "$opencode_json_source" "$opencode_json_target" "OpenCode config"
            fi
        else
            # File doesn't exist or is already a symlink
            create_symlink "$opencode_json_source" "$opencode_json_target" "OpenCode config"
        fi
    else
        print_warning "opencode.json not found at $opencode_json_source"
    fi

    # =================================================================
    # Handle agents directory with custom agent detection
    # =================================================================
    local agents_source="$opencode_config_source/agents"
    local agents_target="$opencode_config_target/agents"

    if [[ -d "$agents_source" ]]; then
        # Check for custom agents before proceeding
        if [[ -d "$agents_target" ]] && ! [[ -L "$agents_target" ]]; then
            print_step "Analyzing existing agents directory" "checking for custom agents"
            
            # Get custom agents list
            local custom_agents_output=$(analyze_custom_agents "$agents_target" "$agents_source")
            local custom_count=$?
            
            if [[ $custom_count -gt 0 ]]; then
                print_warning "Found $custom_count custom agent(s) not in repository:"
                echo "$custom_agents_output" | while IFS= read -r agent; do
                    if [[ -n "$agent" ]]; then
                        echo "    ${yellow}• ${agent}${textreset}"
                    fi
                done
                echo ""
                echo "${bold}${cyan}Options:${textreset}"
                echo "  ${cyan}1)${textreset} Backup and symlink (custom agents preserved in backup)"
                echo "  ${cyan}2)${textreset} Keep existing agents directory (recommended)"
                echo ""
                echo -n "${yellow}Choose [1-2] (default: 2): ${textreset}"
                read -r choice
                choice=${choice:-2}
                
                case "$choice" in
                    1)
                        local backup_path="$backup_session/agents"
                        cp -r "$agents_target" "$backup_path"
                        
                        if [[ ! -d "$backup_path" ]]; then
                            print_error "Failed to backup agents directory! Aborting."
                            return 1
                        fi
                        
                        print_success "Backed up agents to: $backup_path"
                        rm -rf "$agents_target"
                        ln -sf "$agents_source" "$agents_target"
                        echo "    ${green}${LINK} OpenCode agents${textreset} → ${dim}$agents_target${textreset}"
                        print_info "Your custom agents are in: $backup_path"
                        ;;
                    2)
                        print_info "Keeping your existing agents directory (skipping symlink)"
                        ;;
                    *)
                        print_error "Invalid choice, keeping existing directory"
                        ;;
                esac
            else
                # No custom agents, safe to symlink with improved logic
                if [[ -L "$agents_target" ]]; then
                    # Check if it's a dangling symlink
                    if [[ ! -e "$agents_target" ]]; then
                        print_warning "Agents directory is a dangling symlink, removing..."
                    else
                        print_info "OpenCode agents directory symlink already exists, updating..."
                    fi
                    rm "$agents_target"
                elif [[ -d "$agents_target" ]]; then
                    # Backup with timestamp
                    local backup_path="$backup_session/agents"
                    print_warning "OpenCode agents directory exists, backing up..."
                    cp -r "$agents_target" "$backup_path"
                    
                    if [[ ! -d "$backup_path" ]]; then
                        print_error "Failed to backup agents directory! Aborting."
                        return 1
                    fi
                    
                    print_success "Agents backup created: $backup_path"
                    rm -rf "$agents_target"
                fi
                
                ln -sf "$agents_source" "$agents_target"
                echo "    ${green}${LINK} OpenCode agents${textreset} → ${dim}$agents_target${textreset}"
            fi
        else
            # Directory doesn't exist or is already a symlink
            if [[ -L "$agents_target" ]]; then
                if [[ ! -e "$agents_target" ]]; then
                    print_warning "Agents directory is a dangling symlink, removing..."
                else
                    print_info "OpenCode agents directory symlink already exists, updating..."
                fi
                rm "$agents_target"
            fi
            
            ln -sf "$agents_source" "$agents_target"
            echo "    ${green}${LINK} OpenCode agents${textreset} → ${dim}$agents_target${textreset}"
        fi
    else
        print_warning "agents directory not found at $agents_source"
    fi

    # =================================================================
    # Handle all other directories and files (commands, etc.)
    # =================================================================
    print_step "Symlinking additional OpenCode configuration" "commands and other files"
    
    for item in "$opencode_config_source"/*; do
        if [[ -e "$item" ]]; then
            local item_name=$(basename "$item")
            local item_target="$opencode_config_target/$item_name"
            
            # Skip opencode.json and agents (already handled above)
            if [[ "$item_name" == "opencode.json" ]] || [[ "$item_name" == "agents" ]]; then
                continue
            fi
            
            if [[ -d "$item" ]]; then
                # Handle directories (e.g., commands/)
                if [[ -L "$item_target" ]]; then
                    print_info "OpenCode $item_name directory symlink already exists, updating..."
                    rm "$item_target"
                elif [[ -d "$item_target" ]]; then
                    local backup_path="$backup_session/$item_name"
                    print_warning "OpenCode $item_name directory exists, backing up..."
                    cp -r "$item_target" "$backup_path"
                    
                    if [[ ! -d "$backup_path" ]]; then
                        print_error "Failed to backup $item_name directory! Skipping."
                        continue
                    fi
                    
                    print_success "$item_name backup created: $backup_path"
                    rm -rf "$item_target"
                fi
                
                ln -sf "$item" "$item_target"
                echo "    ${green}${LINK} OpenCode $item_name${textreset} → ${dim}$item_target${textreset}"
            elif [[ -f "$item" ]]; then
                # Handle individual files (if any exist beyond opencode.json)
                if [[ -f "$item_target" ]] && ! [[ -L "$item_target" ]]; then
                    local backup_path="$backup_session/$item_name"
                    print_warning "OpenCode $item_name exists, backing up..."
                    cp "$item_target" "$backup_path"
                    print_success "$item_name backup created: $backup_path"
                fi
                
                create_symlink "$item" "$item_target" "OpenCode $item_name"
            fi
        fi
    done

    # =================================================================
    # Show backup session summary
    # =================================================================
    echo ""
    if [[ -n "$(ls -A "$backup_session" 2>/dev/null | grep -v '^info.txt$')" ]]; then
        print_info "Backups created in: $backup_session"
        echo "${dim}    To restore: copy backups from this directory to ~/.config/opencode${textreset}"
    else
        # Clean up empty backup session (only has info.txt)
        rm -rf "$backup_session" 2>/dev/null || true
        rmdir "$opencode_config_target/.backups" 2>/dev/null || true
    fi

    echo ""
    print_success "OpenCode installation and configuration complete!"
}

install_wsl_networking() {
    print_section "${GEAR} Configuring WSL Networking"
    
    # Check if running inside WSL
    if ! detect_wsl; then
        print_info "Not running in WSL environment, skipping WSL networking configuration"
        print_info "This step only applies when running the script inside WSL2"
        return 0
    fi
    
    print_info "Detected WSL environment"
    print_info "Configuring mirrored networking for seamless localhost access..."
    echo ""
    
    # Get Windows username
    print_step "Detecting Windows username" "for .wslconfig path"
    local win_username=$(get_windows_username)
    
    if [[ -z "$win_username" ]]; then
        print_error "Failed to detect Windows username"
        print_warning "Please configure .wslconfig manually if needed"
        return 1
    fi
    
    print_success "Windows username: $win_username"
    
    # Construct Windows .wslconfig path (accessed via WSL mount)
    local wsl_config_path="/mnt/c/Users/$win_username/.wslconfig"
    print_info "Target: $wsl_config_path"
    echo ""
    
    # Check if Windows filesystem is accessible
    if [[ ! -d "/mnt/c/Users/$win_username" ]]; then
        print_error "Cannot access Windows user directory: /mnt/c/Users/$win_username"
        print_warning "Please ensure Windows filesystem is mounted at /mnt/c/"
        return 1
    fi
    
    # Check if .wslconfig already has mirrored networking
    if [[ -f "$wsl_config_path" ]]; then
        print_step "Checking existing .wslconfig" "parsing configuration"
        
        if check_wsl_config_has_mirrored "$wsl_config_path"; then
            print_success "Mirrored networking already configured!"
            print_info "Your .wslconfig is already set up correctly"
            echo ""
            echo "${dim}    Current config: $wsl_config_path${textreset}"
            return 0
        fi
        
        # Existing config without mirrored networking
        print_warning "Existing .wslconfig found without mirrored networking"
        echo ""
        echo "${bold}${yellow}Your .wslconfig needs mirrored networking configuration${textreset}"
        echo ""
        echo "${dim}Current file: $wsl_config_path${textreset}"
        echo ""
        echo "${bold}${cyan}Options:${textreset}"
        echo "  ${cyan}1)${textreset} Backup and append mirrored networking settings (recommended)"
        echo "  ${cyan}2)${textreset} Backup and replace with template configuration"
        echo "  ${cyan}3)${textreset} Skip WSL networking configuration"
        echo ""
        echo -n "${yellow}Choose [1-3] (default: 1): ${textreset}"
        read -r choice
        choice=${choice:-1}  # Default to option 1
        
        case "$choice" in
            1)
                # Backup and append
                local backup_path="${wsl_config_path}.backup.$(date +%Y%m%d_%H%M%S)"
                print_step "Backing up existing .wslconfig" "$backup_path"
                
                if cp "$wsl_config_path" "$backup_path"; then
                    print_success "Backup created: $backup_path"
                else
                    print_error "Failed to create backup! Aborting."
                    return 1
                fi
                
                print_step "Appending mirrored networking settings" "merging configuration"
                
                # Check if [wsl2] section exists
                if grep -q "^\[wsl2\]" "$wsl_config_path" 2>/dev/null; then
                    # Append to existing [wsl2] section
                    # Create temporary file with merged content
                    local temp_file=$(mktemp)
                    local in_wsl2=false
                    local added_settings=false
                    
                    while IFS= read -r line; do
                        echo "$line" >> "$temp_file"
                        
                        if [[ "$line" =~ ^\[wsl2\] ]]; then
                            in_wsl2=true
                        elif [[ "$line" =~ ^\[.*\] ]]; then
                            if [[ "$in_wsl2" == true ]] && [[ "$added_settings" == false ]]; then
                                # Add settings before new section
                                echo "" >> "$temp_file"
                                echo "# Added by NairoVIM installer - $(date +%Y-%m-%d)" >> "$temp_file"
                                echo "networkingMode=mirrored" >> "$temp_file"
                                echo "dnsTunneling=true" >> "$temp_file"
                                echo "firewall=true" >> "$temp_file"
                                echo "autoProxy=true" >> "$temp_file"
                                added_settings=true
                            fi
                            in_wsl2=false
                        fi
                    done < "$wsl_config_path"
                    
                    # If we're still in [wsl2] section at EOF, add settings
                    if [[ "$in_wsl2" == true ]] && [[ "$added_settings" == false ]]; then
                        echo "" >> "$temp_file"
                        echo "# Added by NairoVIM installer - $(date +%Y-%m-%d)" >> "$temp_file"
                        echo "networkingMode=mirrored" >> "$temp_file"
                        echo "dnsTunneling=true" >> "$temp_file"
                        echo "firewall=true" >> "$temp_file"
                        echo "autoProxy=true" >> "$temp_file"
                    fi
                    
                    mv "$temp_file" "$wsl_config_path"
                else
                    # No [wsl2] section, append entire section
                    echo "" >> "$wsl_config_path"
                    echo "# Added by NairoVIM installer - $(date +%Y-%m-%d)" >> "$wsl_config_path"
                    echo "[wsl2]" >> "$wsl_config_path"
                    echo "networkingMode=mirrored" >> "$wsl_config_path"
                    echo "dnsTunneling=true" >> "$wsl_config_path"
                    echo "firewall=true" >> "$wsl_config_path"
                    echo "autoProxy=true" >> "$wsl_config_path"
                fi
                
                print_success "Mirrored networking settings appended"
                ;;
            2)
                # Backup and replace
                local backup_path="${wsl_config_path}.backup.$(date +%Y%m%d_%H%M%S)"
                print_step "Backing up existing .wslconfig" "$backup_path"
                
                if cp "$wsl_config_path" "$backup_path"; then
                    print_success "Backup created: $backup_path"
                else
                    print_error "Failed to create backup! Aborting."
                    return 1
                fi
                
                print_step "Replacing with template configuration" "wslconfig.template"
                
                local template_path="$(pwd)/wslconfig.template"
                if [[ ! -f "$template_path" ]]; then
                    print_error "Template file not found: $template_path"
                    return 1
                fi
                
                if cp "$template_path" "$wsl_config_path"; then
                    print_success "Configuration replaced with template"
                else
                    print_error "Failed to replace configuration"
                    return 1
                fi
                ;;
            3)
                print_info "Skipping WSL networking configuration"
                print_info "You can configure manually later: $wsl_config_path"
                return 0
                ;;
            *)
                print_error "Invalid choice, skipping WSL networking configuration"
                return 1
                ;;
        esac
    else
        # No existing .wslconfig, create from template
        print_step "Creating .wslconfig from template" "enabling mirrored networking"
        
        local template_path="$(pwd)/wslconfig.template"
        if [[ ! -f "$template_path" ]]; then
            print_error "Template file not found: $template_path"
            print_warning "Please create .wslconfig manually if needed"
            return 1
        fi
        
        if cp "$template_path" "$wsl_config_path"; then
            print_success "Created .wslconfig with mirrored networking"
        else
            print_error "Failed to create .wslconfig"
            return 1
        fi
    fi
    
    # Show restart warning
    echo ""
    print_warning "WSL restart required for changes to take effect!"
    echo ""
    echo "${bold}${yellow}To apply networking changes:${textreset}"
    echo "  ${cyan}1.${textreset} Open PowerShell or Windows Terminal (on Windows side)"
    echo "  ${cyan}2.${textreset} Run: ${bold}${cyan}wsl --shutdown${textreset}"
    echo "  ${cyan}3.${textreset} Restart your WSL session"
    echo ""
    print_info "After restart, both localhost:PORT and 127.0.0.1:PORT will work"
    echo ""
    
    print_success "WSL networking configuration complete!"
}

print_installation_summary() {
    echo ""
    echo "${bold}${magenta}╔══════════════════════════════════════════════════════════════════════════════════════╗${textreset}"
    echo "${bold}${magenta}║${textreset}  ${bold}${green}🎉 INSTALLATION COMPLETE! 🎉${textreset}${magenta}${bold}                                                       ║${textreset}"
    echo "${bold}${magenta}╚══════════════════════════════════════════════════════════════════════════════════════╝${textreset}"
    echo ""
    echo "${bold}${cyan}📋 Installation Summary:${textreset}"
    echo "${green}${CHECK_MARK}${textreset} Build tools installed (gcc/clang, make, cmake)"
    echo "${green}${CHECK_MARK}${textreset} Development tools installed (Node.js, Go, Python) [optional]"
    echo "${green}${CHECK_MARK}${textreset} Dotfiles linked (.zshrc, .vimrc, .tmux.conf, .ripgreprc)"
    echo "${green}${CHECK_MARK}${textreset} Neovim installed and configured"
    echo "${green}${CHECK_MARK}${textreset} Tmux installed with Plugin Manager (TPM)"
    echo "${green}${CHECK_MARK}${textreset} Oh My Zsh installed"
    echo "${green}${CHECK_MARK}${textreset} CLI tools installed (fzf, ripgrep, bat, scooter)"
    echo "${green}${CHECK_MARK}${textreset} UV/UVX installed for MCP plugins"
    echo "${green}${CHECK_MARK}${textreset} Lazygit installed and configured"
    echo "${green}${CHECK_MARK}${textreset} OpenCode installed and configured"
    
    if detect_wsl; then
        echo "${green}${CHECK_MARK}${textreset} WSL networking configured (mirrored mode)"
    fi
    
    echo ""
    echo "${bold}${yellow}🚀 Next Steps:${textreset}"
    echo "${cyan}1.${textreset} Run ${bold}${cyan}tmux${textreset} to start your enhanced terminal session"
    echo "${cyan}2.${textreset} Run ${bold}${cyan}nvim${textreset} to start Neovim and let plugins install"
    echo "${cyan}3.${textreset} In tmux, press ${bold}${cyan}prefix + I${textreset} to install tmux plugins"
    echo "${cyan}4.${textreset} Consider installing ${bold}${cyan}powerlevel10k${textreset} theme for enhanced zsh experience"
    
    if detect_wsl; then
        echo "${cyan}5.${textreset} ${bold}${yellow}[WSL]${textreset} Run ${bold}${cyan}wsl --shutdown${textreset} in PowerShell, then restart WSL for networking changes"
    fi
    
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
    install_build_tools
    install_development_tools
    install_dotfiles
    install_neovim
    install_tmux
    install_oh_my_zsh
    install_cli_tools
    install_uv
    install_lazygit
    install_opencode
    install_wsl_networking

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

