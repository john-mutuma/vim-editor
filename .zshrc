# Enable Powerlevel10k instant prompt (if theme is installed)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$(which watchman):/usr/sbin:/sbin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Use powerlevel10k if installed, otherwise fall back to robbyrussell
if [[ -d "$ZSH/custom/themes/powerlevel10k" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
else
  ZSH_THEME="robbyrussell"
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'  # Use nvim for all sessions (mvim is macOS GUI only)
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#


# export FZF_BASE="$HOME/.fzf"  # Commented out - let Oh-My-Zsh auto-detect FZF location

# Uncomment the following line to disable fuzzy completion
# export DISABLE_FZF_AUTO_COMPLETION="true"

# Uncomment the following line to disable key bindings (CTRL-T, CTRL-R, ALT-C)
# export DISABLE_FZF_KEY_BINDINGS="true"

# Removed duplicate plugins=(fzf) array - already included in line 81 before Oh-My-Zsh loads

set -o vi

# Re-bind FZF keys after enabling Vi mode (Vi mode overrides default bindings)
# Note: The Oh-My-Zsh FZF plugin sources key-bindings, but Vi mode needs explicit rebinding
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  # Explicitly bind Ctrl+R in Vi insert mode (in case Vi mode reset it)
  bindkey -M viins '^R' fzf-history-widget
  bindkey -M vicmd '^R' fzf-history-widget
fi

# Removed conflicting manual FZF configuration - Oh-My-Zsh FZF plugin handles setup automatically

export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Azure auth (if installed)
[ -d "$HOME/.azureauth/0.8.3" ] && export PATH="${PATH}:$HOME/.azureauth/0.8.3"

# ----------------------------------------------------------------------
# Platform-specific setup (macOS vs Linux/WSL)
# ----------------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS specific configuration
  export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
  export PATH="$PATH:$ANDROID_SDK_ROOT/tools"
  export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"
  
  # Homebrew setup (macOS)
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/bin:$PATH"
    
    # NVM via Homebrew (macOS)
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  # Linux/WSL specific configuration
  # Homebrew on Linux (if installed)
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  
  # Android SDK on Linux (if installed)
  if [[ -d "$HOME/Android/Sdk" ]]; then
    export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
    export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
    export PATH="$PATH:$ANDROID_SDK_ROOT/tools"
    export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"
  fi
  
  # NVM on Linux (standard location)
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Go (cross-platform)
if [[ -d "/usr/local/go/bin" ]]; then
  export PATH="$PATH:/usr/local/go/bin"
fi

ulimit -n 4096

# lazygit config dir
export CONFIG_DIR="$HOME/.config/lazygit"

# ripgreprc
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# npm global packages
export PATH="$HOME/.npm-global/bin:$PATH"

# NVM - auto-use Node 22 if nvm is available
if command -v nvm &> /dev/null; then
  nvm use 22 2>/dev/null || true
fi

# Custom env file (if exists)
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# bun completions (cross-platform)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ----------------------------------------------------------------------
# WSL Clipboard Integration
# ----------------------------------------------------------------------
# Enhanced clipboard support for WSL2 + OpenCode terminal
if [[ -n "$WSL_DISTRO_NAME" ]] || grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    # Core clipboard functions using Windows clipboard tools
    alias pbcopy='/mnt/c/Windows/system32/clip.exe'
    
    pbpaste() {
        /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Get-Clipboard" 2>/dev/null | sed 's/\r$//'
    }
    
    # OpenCode terminal clipboard helpers
    if [ -n "$OPENCODE" ]; then
        # Override common clipboard commands to use Windows clipboard
        alias xclip='/mnt/c/Windows/system32/clip.exe'
        alias xsel='/mnt/c/Windows/system32/clip.exe'
        alias wl-copy='/mnt/c/Windows/system32/clip.exe'
        
        # Convenient clipboard shortcuts
        alias copy='/mnt/c/Windows/system32/clip.exe'
        alias paste='pbpaste'
    fi
    
    # Export for use in scripts
    export COPY_CMD="/mnt/c/Windows/system32/clip.exe"
    export PASTE_CMD="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command Get-Clipboard"
fi

# Added by Agency Claude Code installer
export PATH="/home/johnmutuma/.claude-cli/currentVersion:$PATH"
