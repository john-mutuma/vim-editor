# NairoVIM Troubleshooting Guide

Comprehensive guide to resolving common issues with NairoVIM.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Plugin Issues](#plugin-issues)
- [LSP Issues](#lsp-issues)
- [AI Assistant Issues](#ai-assistant-issues)
  - [OpenCode Slow in Large Repositories/Monorepos](#opencode-slow-in-large-repositoriesmonorepos)
- [Git Integration Issues](#git-integration-issues)
- [UI and Display Issues](#ui-and-display-issues)
- [Performance Issues](#performance-issues)
- [Keybinding Conflicts](#keybinding-conflicts)
- [Terminal and Shell Issues](#terminal-and-shell-issues)
  - [WSL Clipboard Integration Issues](#wsl-clipboard-integration-issues)
- [Getting Help](#getting-help)
- [Additional Documentation](#additional-documentation)

---

## Installation Issues

### macOS / Linux Installation Issues

#### Homebrew not found

**Problem:** Installation script cannot find Homebrew.

**Solution:**

```bash
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (follow post-install instructions)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

#### Installation script fails

**Problem:** Installation script encounters errors.

**Solution:**

```bash
# Check for errors in the output
./install.sh 2>&1 | tee install.log

# Run individual steps manually if needed
brew install neovim fzf ripgrep bat lazygit
brew install --cask ghostty  # Recommended terminal

# Verify installations
nvim --version
fzf --version
```

#### Permission denied errors

**Problem:** Cannot create symlinks or write to directories.

**Solution:**

```bash
# Ensure proper ownership
sudo chown -R $(whoami) ~/.config
sudo chown -R $(whoami) ~/.local

# Run install script again
./install.sh
```

### Windows Installation Issues

#### PowerShell version too old

**Problem:** PowerShell version is older than 5.1.

**Solution:**

```powershell
# Check PowerShell version
$PSVersionTable.PSVersion

# Install PowerShell 7+ (recommended)
winget install --id Microsoft.PowerShell --source winget

# Or via Scoop
scoop install pwsh

# Restart terminal and use pwsh.exe
pwsh
```

#### Scoop not found

**Problem:** Installation script cannot find Scoop package manager.

**Solution:**

```powershell
# Install Scoop manually
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod get.scoop.sh | Invoke-Expression

# Verify installation
scoop --version

# Add required buckets
scoop bucket add extras
scoop bucket add nerd-fonts

# Run install script again
.\install.ps1
```

#### Developer Mode not enabled

**Problem:** Symlink creation fails without Developer Mode.

**Solution:**

```powershell
# Option 1: Enable Developer Mode (Recommended)
# 1. Open Settings (Win + I)
# 2. Go to System → For developers
# 3. Enable "Developer Mode"
# 4. Restart PowerShell and run install.ps1 again

# Option 2: Run PowerShell as Administrator
# Right-click PowerShell → "Run as Administrator"
# Then run: .\install.ps1
```

#### Git not found on Windows

**Problem:** Git is not installed or not in PATH.

**Solution:**

```powershell
# Install Git via Scoop
scoop install git

# Or install Git for Windows
winget install Git.Git

# Verify installation
git --version

# Add to PATH if needed
$env:Path += ";C:\Program Files\Git\bin"
```

#### C compiler not found (Windows)

**Problem:** Neovim plugins fail to build with errors like "No C compiler found" or "gcc/make not found".

**Affected Plugins:**
- `telescope-fzf-native.nvim` - Requires make/cmake
- `nvim-treesitter` - Requires C compiler for parser compilation

**Solution:**

```powershell
# Automatic (recommended) - Re-run install script
.\install.ps1

# Manual installation via Scoop
scoop install mingw cmake

# Verify installation
gcc --version
make --version
cmake --version

# Restart terminal for PATH changes
```

**Rebuild plugins in Neovim:**

```vim
" Force rebuild telescope-fzf-native
:Lazy build telescope-fzf-native.nvim

" Update all treesitter parsers
:TSUpdate all

" Check health status
:checkhealth telescope
:checkhealth treesitter
```

**Alternative: Visual Studio Build Tools (Advanced)**

If MinGW doesn't work, install Visual Studio Build Tools:

```powershell
# Install Visual Studio Build Tools (6GB download)
winget install Microsoft.VisualStudio.2022.BuildTools

# During installation, select:
# - Desktop development with C++
# - Windows 10/11 SDK
```

#### C compiler not found (macOS/Linux)

**Problem:** Build tools are missing or incomplete.

**Solution (macOS):**

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Or install full Xcode from App Store
# Then enable command line tools:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Verify installation
gcc --version
make --version
cmake --version

# If cmake missing, install via Homebrew
brew install cmake
```

**Solution (Linux - Debian/Ubuntu):**

```bash
# Install build-essential
sudo apt-get update
sudo apt-get install -y build-essential cmake

# Verify installation
gcc --version
make --version
cmake --version
```

**Solution (Linux - Fedora/RHEL):**

```bash
# Install Development Tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y cmake

# Verify installation
gcc --version
make --version
cmake --version
```

**Solution (Linux - Arch):**

```bash
# Install base-devel
sudo pacman -S --noconfirm base-devel cmake

# Verify installation
gcc --version
make --version
cmake --version
```

### Common to All Platforms

### Neovim version too old

**Problem:** Installed Neovim version is older than required (0.9.0+).

**Solution:**

```bash
# Check version
nvim --version

# Upgrade Neovim
brew upgrade neovim

# If still old, try
brew uninstall neovim
brew install neovim --HEAD  # Install latest development version
```

### Permission denied errors

**Problem:** Cannot create symlinks or write to directories.

**Solution:**

```bash
# Ensure proper ownership
sudo chown -R $(whoami) ~/.config
sudo chown -R $(whoami) ~/.local

# Run install script again
./install.sh
```

---

## Plugin Issues

### Plugins not loading

**Problem:** Plugins are not loading on Neovim startup.

**Solution:**

```bash
# In Neovim - restore from lockfile
:Lazy restore

# Sync all plugins
:Lazy sync

# Force clean and reinstall
:Lazy clean
:Lazy sync

# Check for errors
:messages
```

### Specific plugin not working

**Problem:** A particular plugin is not functioning correctly.

**Solution:**

```bash
# Check plugin status
:Lazy

# View plugin logs
:Lazy log

# Profile plugin load times
:Lazy profile

# Disable plugin temporarily
# In lua/nairovim/plugins/problem-plugin.lua
return {
  "plugin/name",
  enabled = false,
}
```

### Lazy.nvim bootstrap fails

**Problem:** Plugin manager fails to install on first run.

**Solution:**

```bash
# Remove and reinstall plugin manager
rm -rf ~/.local/share/nvim/lazy/lazy.nvim

# Start Neovim (will auto-reinstall)
nvim
```

### Plugin update breaks functionality

**Problem:** After updating plugins, something stops working.

**Solution:**

```bash
# Restore to last working state
:Lazy restore

# Check lazy-lock.json for version differences
git diff lazy-lock.json

# Rollback specific plugin
:Lazy restore plugin-name
```

---

## LSP Issues

### LSP not starting

**Problem:** Language server doesn't start for a file.

**Solution:**

```bash
# Check LSP status
:LspInfo

# Check Mason installations
:Mason

# View LSP logs
:LspLog

# Restart LSP server
:LspRestart

# Check if server is installed
:checkhealth mason
```

### Language server not found

**Problem:** Error message about missing language server.

**Solution:**

```bash
# Install via Mason
:Mason
# Press 'i' on the language server to install

# Or install manually via command
:MasonInstall typescript-language-server
:MasonInstall pyright
:MasonInstall rust-analyzer

# Verify installation
:Mason  # Check for green checkmark
```

### Mason LSP Installation Errors

#### npm/Node.js not found

**Problem:** Mason fails to install LSP servers with error messages like:
- `[ERROR] Failed to spawn process. cmd="npm", err="ENOENT: no such file or directory"`
- `[ERROR] Installation failed for Package(name=typescript-language-server)`
- `[ERROR] Could not find executable "npm" in PATH`

**Affected packages:**
- typescript-language-server (TypeScript/JavaScript)
- eslint-lsp, html-lsp, css-lsp, json-lsp
- prettierd, markdownlint, cspell
- vscode-langservers-extracted

**Solution:**

**Windows:**
```powershell
scoop install nodejs
```

**macOS/Linux:**
```bash
brew install node
```

**Verify:**
```bash
node --version
npm --version
```

**Retry in Neovim:**
```vim
:Mason
# Navigate to failed package, press 'i' to install
# Or use: :MasonInstall typescript-language-server
```

#### Go not found

**Problem:** Mason fails with error messages like:
- `[ERROR] Could not find executable "go" in PATH`
- `[ERROR] Installation failed for Package(name=gopls)`

**Affected packages:**
- gopls (Go language server)
- gofumpt (Go formatter)
- goimports, golangci-lint

**Solution:**

**Windows:**
```powershell
scoop install go
```

**macOS/Linux:**
```bash
brew install go
```

**Verify:**
```bash
go version
```

**Retry in Neovim:**
```vim
:Mason
# Navigate to gopls, press 'i' to install
# Or use: :MasonInstall gopls
```

#### Python not found

**Problem:** Mason fails with error messages like:
- `[ERROR] Could not find executable "python" in PATH`
- `[ERROR] Could not find executable "pip" in PATH`

**Affected packages:**
- pyright, pylsp (Python language servers)
- black, isort, flake8 (Python formatters/linters)
- debugpy (Python debugger)

**Solution:**

**Windows:**
```powershell
scoop install python
```

**macOS/Linux:**
```bash
brew install python
```

**Verify:**
```bash
python --version  # or python3 --version
pip --version     # or pip3 --version
```

**Retry in Neovim:**
```vim
:Mason
# Navigate to pyright, press 'i' to install
# Or use: :MasonInstall pyright
```

#### PATH not updated after tool installation

**Problem:** Tools are installed but Mason still reports "not found in PATH".

**Solution:**

1. **Restart your terminal** - This refreshes environment variables
2. **Verify PATH includes tool directories:**

**Windows:**
```powershell
# Check PATH
$env:PATH -split ';'

# Should include scoop paths like:
# C:\Users\YourName\scoop\shims
# C:\Users\YourName\scoop\apps\nodejs\current\bin
```

**macOS/Linux:**
```bash
# Check PATH
echo $PATH | tr ':' '\n'

# Should include homebrew paths like:
# /opt/homebrew/bin (macOS Apple Silicon)
# /usr/local/bin (macOS Intel)
```

3. **Manually add to PATH if needed:**

**Windows (PowerShell profile):**
```powershell
# Edit profile
notepad $PROFILE

# Add scoop to PATH (if missing)
$env:PATH = "$env:USERPROFILE\scoop\shims;" + $env:PATH
```

**macOS/Linux (shell profile):**
```bash
# For zsh (default on macOS)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bashrc
source ~/.bashrc
```

4. **Restart Neovim after fixing PATH**

#### General Mason troubleshooting

**Check Mason health:**
```vim
:checkhealth mason
```

**View Mason logs:**
```vim
:Mason
# Press 'g?' to see keybindings
# Press 'g' then 'l' to view logs for a package
```

**Clear Mason cache and reinstall:**
```vim
# Remove Mason data directory
# Exit Neovim first, then:
# Unix: rm -rf ~/.local/share/nvim/mason
# Windows: Remove-Item -Recurse -Force ~\AppData\Local\nvim-data\mason

# Restart Neovim and reinstall
:Mason
# Press 'I' to install all missing packages
```

**Install during setup:**

If you're setting up NairoVIM for the first time, the installation scripts will prompt you to install Node.js, Go, and Python automatically. Answer "Y" to avoid these issues.

### Completions not working

**Problem:** No autocomplete suggestions appearing.

**Solution:**

```bash
# Check nvim-cmp status
:CmpStatus

# Verify sources are available
:lua =vim.inspect(require('cmp').get_config().sources)

# Ensure LSP is attached
:lua =vim.lsp.get_active_clients()

# Restart completion
:CmpRefresh
```

### Formatter not working

**Problem:** Code formatting doesn't work or produces errors.

**Solution:**

```bash
# Check null-ls status
:NullLsInfo

# Install formatter via Mason
:Mason
# Find and install formatter (e.g., prettier, black)

# Format manually to see errors
:lua vim.lsp.buf.format()

# Check formatter is in PATH
# For prettier:
which prettier

# Install if missing
npm install -g prettier
```

### Diagnostics not showing

**Problem:** No error/warning indicators in code.

**Solution:**

```bash
# Check LSP is running
:LspInfo

# Verify diagnostics config
:lua =vim.diagnostic.config()

# Toggle diagnostics
:lua vim.diagnostic.enable()

# Refresh buffer
:e!
```

---

## AI Assistant Issues

### GitHub Copilot not working

**Problem:** Copilot is not providing suggestions.

**Solution:**

```bash
# Check authentication status
:Copilot status

# Re-authenticate
:Copilot auth

# Disable/enable Copilot
:Copilot disable
:Copilot enable

# Check Node.js is installed
node --version  # Should be v16+

# Reinstall Copilot
:Lazy clean copilot.lua
:Lazy sync
```

### Avante AI not responding

**Problem:** Avante AI doesn't respond to queries.

**Solution:**

```bash
# Check API key is set
:lua =os.getenv("ANTHROPIC_API_KEY")
# Should show your key, not nil

# Verify provider configuration
:AvanteInfo

# Check network connectivity
curl https://api.anthropic.com/v1/health

# Set API key if missing
export ANTHROPIC_API_KEY="your-key"
source ~/.zshrc
```

### OpenCode terminal not opening

**Problem:** OpenCode terminal doesn't open with `<leader>ot`.

**Solution:**

```bash
# Check OpenCode installation
which opencode

# Verify configuration
cat ~/.config/opencode.json

# Check environment variables
env | grep -i api

# Check keybinding
:nmap <leader>ot

# Try opening directly
:OpenCode
```

### API rate limits

**Problem:** AI provider returns rate limit errors.

**Solution:**

- **Anthropic Claude:** Check usage at https://console.anthropic.com/
- **OpenAI:** Check usage at https://platform.openai.com/usage
- **GitHub Copilot:** Subscription-based, shouldn't have limits
- Wait a few minutes before retrying
- Consider upgrading API tier if hitting limits frequently

### OpenCode slow in large repositories/monorepos

**Problem:** OpenCode becomes very slow after adding large directories (especially documentation) to git sparse-checkout or working in large monorepos.

**Symptoms:**
- Long response times (seconds → minutes)
- OpenCode hangs during file indexing
- High disk usage in `~/.local/share/opencode/`
- Sluggish chat interactions

**Root Cause:**

OpenCode creates repository snapshots and indexes all files for context gathering. Large documentation directories or monorepos with thousands of files can result in:
- Multi-GB snapshot directories
- Massive session diff files (500MB+)
- Slow file traversal on every query

**Investigation:**

```bash
# Check OpenCode cache sizes
du -sh ~/.local/share/opencode/snapshot/*    # Repository snapshots
du -sh ~/.local/share/opencode/storage/*     # Session data, diffs
du -sh ~/.local/share/opencode/opencode.db*  # Database

# Identify which repositories have snapshots
for dir in ~/.local/share/opencode/snapshot/*/; do
  if [ -f "$dir/config" ]; then
    echo "=== Snapshot: $(basename $dir) ==="
    du -sh "$dir"
    grep worktree "$dir/config"
    echo ""
  fi
done
```

**Solution 1: Clear Cache for Specific Repository**

```bash
# 1. Stop OpenCode first (in Neovim)
:lua require("opencode").stop()

# 2. Find the snapshot hash for your slow repository
ls -lah ~/.local/share/opencode/snapshot/
# Look at the config files to identify your repo

# 3. Remove the specific snapshot (replace HASH with actual hash)
rm -rf ~/.local/share/opencode/snapshot/HASH

# 4. Optional: Clear large session diffs
find ~/.local/share/opencode/storage/session_diff/ -type f -size +100M -delete

# 5. Verify cleanup
du -sh ~/.local/share/opencode/
```

**Solution 2: Create `.opencodeignore` File**

Prevent OpenCode from indexing unnecessary files by creating `.opencodeignore` in your repository root:

```gitignore
# Documentation directories
**/docs/**
**/documentation/**
**/doc/**

# Build outputs and dependencies
**/node_modules/**
**/dist/**
**/build/**
**/.next/**

# Generated files
**/*.min.js
**/*.generated.*
**/generated/**

# Large assets
**/assets/**
**/static/**
**/*.png
**/*.jpg

# Test fixtures
**/fixtures/**
**/__snapshots__/**

# Lock files
**/package-lock.json
**/yarn.lock
```

**Solution 3: Nuclear Option (Clear All Cache)**

```bash
# Stop OpenCode first
:lua require("opencode").stop()

# Clear all cache (CAUTION: Loses all conversation history)
rm -rf ~/.local/share/opencode/snapshot/*
rm -rf ~/.local/share/opencode/storage/*
rm ~/.local/share/opencode/opencode.db*

# This will recover several GB of disk space
```

**Prevention:**

1. **Always use `.opencodeignore`** in large repositories
2. **Be selective with sparse-checkout** - avoid adding massive doc directories
3. **Periodic maintenance** - Clear old snapshots monthly
4. **Monitor cache size** - Check `~/.local/share/opencode/` size regularly

**Template:**

A comprehensive `.opencodeignore` template is available at:
```
/path/to/vim-editor/.opencodeignore.template
```

Copy this to your repository root and customize for your needs.

**Expected Results:**

After clearing cache and adding `.opencodeignore`:
- ✅ OpenCode startup time: < 2 seconds
- ✅ First query response: < 5 seconds  
- ✅ Cache size: < 500MB per repository
- ✅ No more multi-GB snapshots

---

## Git Integration Issues

### Lazygit not opening

**Problem:** Lazygit doesn't open with `<leader>G`.

**Solution:**

```bash
# Check Lazygit installation
lazygit --version

# Install if missing
brew install lazygit

# Try opening manually
:lua Snacks.lazygit()

# Check keybinding
:nmap <leader>G

# Verify Snacks plugin loaded
:Lazy load snacks.nvim
```

### Gitsigns not showing

**Problem:** Git diff signs not appearing in gutter.

**Solution:**

```bash
# Check if in git repository
git status

# Refresh Gitsigns
:Gitsigns refresh

# View Gitsigns debug info
:Gitsigns debug_messages

# Toggle Gitsigns
:Gitsigns toggle_signs

# Check Gitsigns loaded
:lua =require('gitsigns')
```

### Diffview not working

**Problem:** Cannot open diff view.

**Solution:**

```bash
# Check plugin loaded
:lua =require('diffview')

# Open diffview manually
:DiffviewOpen

# Check git is available
git --version

# Try with specific ref
:DiffviewOpen HEAD~1

# Check for git repository
git rev-parse --git-dir
```

### Git authentication issues

**Problem:** Cannot push/pull from remote.

**Solution:**

```bash
# Check git credentials
git config --list | grep user

# Set credentials if missing
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# For HTTPS, use credential helper
git config --global credential.helper osxkeychain

# For SSH, check keys
ssh -T git@github.com
```

---

## UI and Display Issues

### Font icons not displaying

**Problem:** Icons show as boxes or question marks.

**Solution:**

```bash
# Install Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# Configure terminal to use Nerd Font
# Ghostty (recommended): Edit ~/.config/ghostty/config
font-family = "Hack Nerd Font Mono"

# Other terminals:
# iTerm2: Preferences → Profiles → Text → Font
# Terminal.app: Preferences → Profiles → Text → Font

# Verify font
# Open terminal and check if icons display correctly
echo ""  # Should show a nice icon
```

### Colors look wrong

**Problem:** Colors appear incorrect or washed out.

**Solution:**

```bash
# Check terminal color support
echo $TERM
# Should be: xterm-256color or screen-256color

# Set in shell config (~/.zshrc)
export TERM=xterm-256color

# Reload shell
source ~/.zshrc

# Try different colorscheme in Neovim
:colorscheme tokyonight-night
:colorscheme catppuccin
:colorscheme gruvbox

# Check true color support
:checkhealth
```

### Transparency not working

**Problem:** Window transparency/blur not working.

**Solution:**

```bash
# Check terminal supports transparency
# Ghostty (recommended): Edit ~/.config/ghostty/config
background-opacity = 0.95  # Adjust 0.0-1.0
background-blur-radius = 20

# Other terminals:
# iTerm2: Preferences → Profiles → Window → Transparency

# Check winblend settings in Neovim
:set winblend?  # Should show > 0

# Adjust transparency in plugin config
# Edit lua/nairovim/plugins/<plugin>.lua
winblend = 12,  # Adjust value 0-100

# Some terminals don't support winblend
# Use terminal's native transparency instead
```

### Slow rendering/lag

**Problem:** Screen rendering is slow or laggy.

**Solution:**

```bash
# Disable expensive features temporarily
:set lazyredraw
:set nocursorline

# Check plugin load times
:Lazy profile

# Disable Treesitter highlighting temporarily
:TSDisable highlight

# Reduce diagnostic update frequency
# Edit LSP config
update_in_insert = false,

# Check terminal performance
# Recommended: Use Ghostty for best performance
# Alternative: Try different terminal emulator (iTerm2, Alacritty)
```

### Status line not showing

**Problem:** Lualine or status line is missing.

**Solution:**

```bash
# Check lualine loaded
:lua =require('lualine')

# Reload lualine
:Lazy reload lualine.nvim

# Check laststatus setting
:set laststatus?  # Should be 2 or 3

# Set if needed
:set laststatus=3
```

---

## Performance Issues

### Slow startup

**Problem:** Neovim takes too long to start.

**Solution:**

```bash
# Profile startup time
nvim --startuptime startup.log +qa
cat startup.log | tail -20

# Check plugin load times
:Lazy profile

# Disable unused plugins
# Edit plugin file and add: enabled = false,

# Clean unused plugins
:Lazy clean

# Check for slow scripts
nvim --startuptime startup.log
# Look for lines with high cumulative time
```

### High memory usage

**Problem:** Neovim consumes too much memory.

**Solution:**

```bash
# Check Neovim process
ps aux | grep nvim

# Close unused buffers
:bufdo bd

# Restart LSP to free memory
:LspRestart

# Disable unused LSP features
# Edit Mason config to install only needed servers

# Check for memory leaks
:checkhealth
```

### Search is slow

**Problem:** File search or text search is slow.

**Solution:**

```bash
# Use git files instead of find_files
# <C-S>f instead of searching all files

# Ensure ripgrep is installed
rg --version
brew install ripgrep  # If missing

# Update Telescope config for better performance
:lua require('telescope.builtin').git_files()

# Exclude large directories
# Add to .gitignore:
node_modules/
.git/
dist/
build/
```

### LSP slow or hanging

**Problem:** LSP responses are slow or hang.

**Solution:**

```bash
# Check LSP log for errors
:LspLog

# Restart LSP
:LspRestart

# Check which servers are running
:LspInfo

# Disable unused servers
# Edit Mason config

# For large projects, adjust debounce
# In LSP config:
debounce_text_changes = 500,  # Increase from default
```

---

## Keybinding Conflicts

### Keybinding not working

**Problem:** A keybinding doesn't trigger expected action.

**Solution:**

```bash
# Check if key is mapped
:map <leader>key
:nmap <leader>key

# View all keybindings
:map

# Check for conflicts with Which-key
:WhichKey

# Test keybinding directly
:execute "normal \<leader>key"

# Check plugin is loaded
:Lazy
```

### Leader key not responding

**Problem:** Leader key combinations don't work.

**Solution:**

```bash
# Verify leader key setting
:let mapleader
# Should show: ,

# Check if leader is set
:lua =vim.g.mapleader

# Set leader key if missing (in core/options.lua)
vim.g.mapleader = ","

# Restart Neovim
```

### Multiple mappings for same key

**Problem:** One key triggers multiple actions.

**Solution:**

```bash
# Find all mappings for key
:verbose map <key>

# Remove unwanted mapping
# In config file:
vim.keymap.del("n", "<key>")

# Set with higher priority
vim.keymap.set("n", "<key>", callback, { noremap = true })
```

---

## Terminal and Shell Issues

### macOS / Linux Terminal Issues

#### Ghostty terminal issues

**Problem:** Ghostty terminal not working as expected with Neovim.

**Solution:**

```bash
# Check Ghostty is installed
ghostty --version

# Install if missing
brew install --cask ghostty

# Verify configuration file exists
cat ~/.config/ghostty/config
# Or
cat ~/Library/Application\ Support/com.mitchellh.ghostty/config

# Check TERM variable
echo $TERM  # Should be xterm-256color

# Reload Ghostty config
# Cmd + , (Preferences) or restart Ghostty

# Test keybindings (should use Ctrl+b prefix)
# Ctrl+b + | (vertical split)
# Ctrl+b + - (horizontal split)
# Ctrl+b + [ (navigate panes)
```

#### Ghostty config not loaded

**Problem:** Custom Ghostty configuration not applying.

**Solution:**

```bash
# Check config file location
ls -la ~/.config/ghostty/config

# If missing, create symlink (should be done by install.sh)
ln -sf ~/path/to/vim-editor/ghostty_config ~/.config/ghostty/config

# Verify config syntax
ghostty --config-check

# Restart Ghostty application
# macOS: Cmd + Q, then reopen

# Check if shell integration is working
echo $GHOSTTY_RESOURCES_DIR
```

#### Ghostty splits not working

**Problem:** Keybindings for splits/tabs don't work.

**Solution:**

```bash
# Verify keybindings in config
grep "keybind" ~/.config/ghostty/config

# Try alternative keybindings
# Ctrl+b + | (vertical split)
# Ctrl+b + - (horizontal split)
# Ctrl+b + c (new tab)
# Ctrl+b + n/p (next/previous tab)

# If keybindings conflict, check macOS shortcuts
# System Preferences → Keyboard → Shortcuts

# Try Cmd-based alternatives
# Cmd + d (vertical split)
# Cmd + Shift + d (horizontal split)
# Cmd + t (new tab)
```

### Windows Terminal Issues

#### Windows Terminal not installed

**Problem:** Windows Terminal is not installed or not found.

**Solution:**

```powershell
# Check if Windows Terminal is installed
winget list --id Microsoft.WindowsTerminal

# Install via winget
winget install Microsoft.WindowsTerminal

# Or install via Scoop
scoop install windows-terminal

# Or install from Microsoft Store
# Open Microsoft Store and search "Windows Terminal"
```

#### Windows Terminal settings not applying

**Problem:** Custom Windows Terminal configuration not loading.

**Solution:**

```powershell
# Check settings file location
Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal*\LocalState\settings.json"

# If symlink is broken, recreate it
# First, backup existing settings
Copy-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json" `
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json.backup"

# Create symlink (requires Developer Mode or admin)
$wtDir = (Get-ChildItem "$env:LOCALAPPDATA\Packages" -Filter "Microsoft.WindowsTerminal*")[0].FullName
New-Item -ItemType SymbolicLink `
  -Path "$wtDir\LocalState\settings.json" `
  -Target "$(Get-Location)\windows-terminal-settings.json" -Force

# Reload Windows Terminal (Ctrl+Shift+T to open new tab)
```

#### Windows Terminal keybindings not working

**Problem:** Ctrl+b prefix keybindings don't work in Windows Terminal.

**Solution:**

```powershell
# Check Windows Terminal settings
# Press Ctrl+, to open Settings

# Verify keybindings in settings.json
# Look for "actions" array with "ctrl+b|..." patterns

# Common fixes:
# 1. Ensure "useAcrylicInTabRow" is false for better performance
# 2. Check for conflicting keybindings in the actions section
# 3. Restart Windows Terminal completely (close all windows)

# Test keybindings manually:
# Ctrl+b then - (horizontal split)
# Ctrl+b then = (vertical split)
# Ctrl+b then h/j/k/l (navigate panes)
```

#### Symlink creation fails on Windows

**Problem:** Installation script fails to create symlinks.

**Solution:**

```powershell
# Option 1: Enable Developer Mode (Recommended)
# 1. Open Settings → System → For developers
# 2. Enable "Developer Mode"
# 3. Restart PowerShell
# 4. Run install.ps1 again

# Option 2: Run as Administrator
# Right-click PowerShell → "Run as Administrator"
# Then run: .\install.ps1

# Option 3: Use hard links or junctions instead
# Edit install.ps1 to use:
cmd /c mklink /J "target" "source"  # For directories
cmd /c mklink /H "target" "source"  # For files

# Verify symlinks created successfully
Get-Item "$env:LOCALAPPDATA\nvim" | Select-Object LinkType, Target
```

#### PowerShell execution policy error

**Problem:** Cannot run install.ps1 due to execution policy.

**Solution:**

```powershell
# Check current execution policy
Get-ExecutionPolicy

# Set execution policy for current user (recommended)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or bypass for single execution
PowerShell -ExecutionPolicy Bypass -File .\install.ps1

# If still blocked, unblock the script
Unblock-File .\install.ps1
```

#### Scoop installation fails

**Problem:** Scoop package manager fails to install.

**Solution:**

```powershell
# Ensure prerequisites
# 1. PowerShell 5.1 or later
$PSVersionTable.PSVersion

# 2. Set execution policy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Manual Scoop installation
Invoke-RestMethod get.scoop.sh | Invoke-Expression

# 4. Add buckets manually if needed
scoop bucket add extras
scoop bucket add nerd-fonts

# 5. Verify Scoop installation
scoop --version
scoop list
```

#### Neovim config path issues on Windows

**Problem:** Neovim cannot find configuration at `%LOCALAPPDATA%\nvim`.

**Solution:**

```powershell
# Check Neovim config path
nvim --version
# Look for "init.lua or init.vim locations"

# Verify symlink exists and is valid
Get-Item "$env:LOCALAPPDATA\nvim"

# If symlink is broken, recreate it
Remove-Item "$env:LOCALAPPDATA\nvim" -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$(Get-Location)\nvim"

# Alternative: Use $env:XDG_CONFIG_HOME
$env:XDG_CONFIG_HOME = "$env:USERPROFILE\.config"
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$env:USERPROFILE\.config", "User")

# Then create symlink at ~/.config/nvim
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\nvim" -Target "$(Get-Location)\nvim"
```

#### Oh My Posh theme not loading

**Problem:** Oh My Posh prompt theme not showing in PowerShell.

**Solution:**

```powershell
# Check Oh My Posh installation
oh-my-posh --version

# Reinstall if missing
scoop install oh-my-posh

# Verify PowerShell profile exists
Test-Path $PROFILE

# Check Oh My Posh init command in profile
Get-Content $PROFILE | Select-String "oh-my-posh"

# Manually add to profile if missing
$initCommand = @"
oh-my-posh init pwsh --config "`$env:POSH_THEMES_PATH\tokyonight_storm.omp.json" | Invoke-Expression
"@
Add-Content $PROFILE $initCommand

# Reload profile
. $PROFILE

# List available themes
Get-ChildItem "$env:POSH_THEMES_PATH" | Select-Object Name
```

### Tmux integration not working (Legacy - macOS/Linux only)

> **Note:** tmux is supported for legacy/remote workflows only. For local development, use Ghostty (macOS/Linux) or Windows Terminal (Windows).

**Problem:** Tmux features not working with Neovim.

**Solution:**

```bash
# Check tmux is running
tmux list-sessions

# Start tmux if not running
tmux

# Check tmux plugins installed
# Inside tmux: prefix + I

# Verify tmux config
cat ~/.tmux.conf

# Reload tmux config
# Inside tmux: prefix + r

# Check TERM in tmux
echo $TERM  # Should be screen-256color or tmux-256color
```

### Shell Configuration Issues

#### Shell completions missing (macOS/Linux)

**Problem:** Tab completions don't work in shell.

**Solution:**

```bash
# Source shell config
source ~/.zshrc

# Reinstall oh-my-zsh plugins
# Add to ~/.zshrc plugins array
plugins=(git fzf vi-mode zsh-autosuggestions)

# Install missing plugins
# For zsh-autosuggestions:
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Reload shell
exec zsh
```

### FZF keybindings not working

**Problem:** FZF keyboard shortcuts don't work in terminal.

**Solution:**

```bash
# Source FZF keybindings
# Add to ~/.zshrc:
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Reinstall FZF keybindings
$(brew --prefix)/opt/fzf/install

# Check FZF installation
which fzf
fzf --version

# Test FZF manually
fzf
```

### WSL Clipboard Integration Issues

#### Clipboard not syncing between WSL and Windows

**Problem:** Text copied in Neovim or terminal doesn't paste in Windows applications (and vice versa).

**Solution:**

NairoVIM automatically configures WSL clipboard integration, but you may need to ensure the setup is complete:

**1. Verify Neovim clipboard provider:**

```bash
# Check which clipboard provider is active
nvim --headless -c 'lua vim.print(vim.g.clipboard.name)' +qall

# Should output: WslClipboard-win32yank or WslClipboard
```

**2. Test manual clipboard operations:**

```bash
# Test copy to Windows clipboard
echo "test from WSL" | clip.exe
# Then paste in Windows Notepad with Ctrl+V

# Test paste from Windows clipboard
# First copy text in Windows (Ctrl+C)
powershell.exe -Command "Get-Clipboard"
```

**3. Verify win32yank installation:**

```bash
# Check if win32yank is installed
ls -lh ~/.local/bin/win32yank.exe

# If missing, install it
mkdir -p ~/.local/bin
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
python3 -m zipfile -e /tmp/win32yank.zip /tmp/
mv /tmp/win32yank.exe ~/.local/bin/win32yank.exe
chmod +x ~/.local/bin/win32yank.exe

# Test win32yank
echo "hello" | ~/.local/bin/win32yank.exe -i
~/.local/bin/win32yank.exe -o
```

**4. Reload shell configuration:**

```bash
# For bash users
source ~/.bashrc

# For zsh users
source ~/.zshrc
```

**5. Test in Neovim:**

```bash
nvim /tmp/test.txt
# Type: iHello from WSL<Esc>
# Copy line: yy
# Paste in Windows Notepad: Ctrl+V should show "Hello from WSL"
```

#### OpenCode terminal clipboard not working

**Problem:** Selecting text in OpenCode terminal shows "copied to clipboard" but doesn't paste in Windows.

**Root Cause:** OpenCode's terminal uses OSC 52 escape sequences which are handled internally but don't automatically bridge to Windows clipboard in WSL. This is a limitation of how OpenCode's terminal emulator works in WSL environments.

**Solution 1: Use shell piping (Recommended for multi-line content)**

Instead of selecting text with your mouse, pipe command output directly to clipboard:

```bash
# Copy command output
ls -la | /mnt/c/Windows/system32/clip.exe

# Copy file contents (works with multiple lines)
cat file.txt | /mnt/c/Windows/system32/clip.exe

# Copy specific output
echo -e "Line 1\nLine 2\nLine 3" | /mnt/c/Windows/system32/clip.exe

# After sourcing ~/.bashrc or ~/.zshrc, use aliases
cat multiline.txt | pbcopy
pbpaste
```

**Solution 2: Use keyboard shortcuts in OpenCode**

OpenCode has a keybind for copying messages:

```bash
# Focus on a message in OpenCode
# Press: Ctrl+X then y (messages_copy keybind)
# This copies the entire message content to clipboard
```

**Solution 3: Use cat + pipe for viewing and copying**

```bash
# Display content and copy simultaneously
cat file.txt | tee >(/ mnt/c/Windows/system32/clip.exe)

# Or simpler: display first, then copy
cat file.txt
cat file.txt | /mnt/c/Windows/system32/clip.exe
```

**Why mouse selection doesn't work:**

OpenCode's terminal text selection operates at the application level (not shell level). When you select text:
1. OpenCode captures the selection internally
2. Uses OSC 52 sequences for clipboard
3. Shows "copied to clipboard" message
4. But OSC 52 doesn't reach Windows clipboard in WSL2

The shell piping method works because it directly invokes Windows clipboard tools with full content, including all lines.

**Quick aliases for frequent copying:**

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Copy last command output
alias clast='fc -ln -1 | /mnt/c/Windows/system32/clip.exe'

# Copy current directory path
alias cpwd='pwd | /mnt/c/Windows/system32/clip.exe'

# Copy file with line numbers
alias ccat='cat -n'
```

#### Clipboard breaks after WSL restart

**Problem:** Clipboard integration stops working after restarting WSL.

**Solution:**

```bash
# Ensure WSLg is running (provides clipboard services)
ps aux | grep -i wsl

# Restart WSLg if needed (from Windows PowerShell)
# wsl --shutdown
# wsl

# Verify DISPLAY is set
echo $DISPLAY  # Should show :0 or similar

# Test Windows executables are accessible
which clip.exe powershell.exe

# Reinstall win32yank if path is broken
export PATH="$HOME/.local/bin:$PATH"
```

#### Neovim paste inserts Windows line endings (^M)

**Problem:** Pasting from Windows clipboard inserts carriage returns.

**Solution:**

NairoVIM automatically strips `\r` characters, but if you still see them:

```vim
" In Neovim, remove manually:
:%s/\r//g

" Or configure dos2unix
:set ff=unix
```

The clipboard provider should handle this automatically with the `--lf` flag (win32yank) or `replace("`r", "")` (PowerShell).

---

### WSL Localhost Networking Issues

#### Can't access localhost:PORT from Windows browser

**Problem:** Services running in WSL (e.g., development servers on `localhost:3000`, `localhost:9090`) are not accessible from Windows browser using `localhost`, but work with `127.0.0.1`.

**Example:**
- ✅ `http://127.0.0.1:9090` works in Windows browser
- ❌ `http://localhost:9090` doesn't work in Windows browser

**Root Cause:** WSL2 uses virtualized networking with its own network adapter and IP address. Windows automatically forwards the numeric IP address `127.0.0.1` to WSL2's network, but does NOT forward the hostname `localhost` by default.

**Solution:** Enable WSL2 mirrored networking mode for seamless localhost access in both directions (Windows ↔ WSL).

---

#### Automatic Setup (Recommended)

**NairoVIM's Windows installation script automatically configures mirrored networking.**

If you ran `install.ps1`, this should already be set up. To verify:

```powershell
# Check if .wslconfig exists (in PowerShell)
Get-Content $env:USERPROFILE\.wslconfig

# Should contain:
# [wsl2]
# networkingMode=mirrored
```

If configured, restart WSL to apply changes:

```powershell
wsl --shutdown
wsl
```

---

#### Manual Setup

If you didn't use the installer or need to configure manually:

**1. Create or edit `.wslconfig` file:**

```powershell
# In Windows PowerShell
notepad $env:USERPROFILE\.wslconfig
```

**2. Add the following content:**

```ini
[wsl2]
# Enable mirrored networking mode for seamless localhost access
networkingMode=mirrored

# Additional recommended settings
dnsTunneling=true
firewall=true
autoProxy=true
```

**3. Restart WSL completely:**

```powershell
# Shut down all WSL instances
wsl --shutdown

# Start WSL again
wsl
```

**4. Verify it works:**

```bash
# In WSL, start a test server (example with Python)
python3 -m http.server 8080
```

Then open in Windows browser:
- ✅ `http://localhost:8080` should now work
- ✅ `http://127.0.0.1:8080` should also work

---

#### Requirements

**Mirrored networking requires:**
- Windows 11 version 22H2 (Build 22621) or later
- OR Windows 10 with Build 19041 or later
- WSL2 (not WSL1)

**Check your Windows version:**

```powershell
# In PowerShell
winver

# Or check WSL version
wsl --version
```

If you have an older Windows version, mirrored networking is not available. Use `127.0.0.1:PORT` instead of `localhost:PORT`.

---

#### Trade-offs and Considerations

**Benefits:**
- ✅ Seamless localhost access from Windows to WSL
- ✅ Bidirectional: WSL can also access Windows services via localhost
- ✅ Simplified development workflow (no IP lookups needed)
- ✅ More consistent with native Linux/macOS behavior

**Potential Issues:**
- ⚠️ **Port conflicts:** If the same port is used by services in both Windows and WSL, conflicts may occur
- ⚠️ **Firewall rules:** Windows Firewall rules now apply to WSL (controlled by `firewall=true` setting)
- ⚠️ **Network troubleshooting:** Some networking diagnostic tools may behave differently

---

#### Troubleshooting Mirrored Networking

**Issue: Mirrored networking not working after configuring**

```bash
# 1. Verify WSL is completely shut down
wsl --shutdown

# 2. Wait 8-10 seconds for full shutdown
Start-Sleep -Seconds 10

# 3. Restart WSL
wsl

# 4. Check network configuration in WSL
ip addr show eth0

# With mirrored mode, networking behavior should match Windows more closely
```

**Issue: Port conflicts after enabling mirrored mode**

If you get "Address already in use" errors:

```bash
# Check what's using the port in Windows
netstat -ano | findstr :PORT_NUMBER

# Or check in WSL
lsof -i :PORT_NUMBER
ss -tunlp | grep PORT_NUMBER
```

**Solution:** Use different ports for Windows and WSL services, or stop the conflicting service.

---

#### Alternative: Port Forwarding (Legacy Method)

If mirrored networking is not available or causes issues, use manual port forwarding:

**Option 1: Use numeric IP address**

```bash
# In WSL, find WSL IP address
ip addr show eth0 | grep inet

# Use this IP from Windows browser:
# http://172.xx.xx.xx:9090
```

**Option 2: PowerShell port forwarding script**

```powershell
# Get WSL IP address
$wslIp = wsl hostname -I
$wslIp = $wslIp.Trim()

# Forward port 9090
netsh interface portproxy add v4tov4 `
    listenport=9090 `
    listenaddress=127.0.0.1 `
    connectport=9090 `
    connectaddress=$wslIp

# To remove forwarding later:
# netsh interface portproxy delete v4tov4 listenport=9090 listenaddress=127.0.0.1
```

**Note:** Port forwarding requires running as Administrator and must be reconfigured if WSL IP changes (after restarts).

---

#### Additional Resources

- [Microsoft WSL Networking Documentation](https://learn.microsoft.com/en-us/windows/wsl/networking)
- [WSL Configuration (.wslconfig) Reference](https://learn.microsoft.com/en-us/windows/wsl/wsl-config)
- [Mirrored Networking Mode Guide](https://learn.microsoft.com/en-us/windows/wsl/networking#mirrored-mode-networking)

---

## Getting Help

### Running Diagnostics

**Check Neovim health:**

```bash
# Full health check
:checkhealth

# Specific plugin health
:checkhealth mason
:checkhealth telescope
:checkhealth lsp
```

**View logs and messages:**

```bash
# Neovim messages
:messages

# LSP log
:LspLog

# View recent logs
tail -f ~/.local/state/nvim/lsp.log
```

### Reset Configuration

If issues persist, try a fresh install:

```bash
# Backup current config
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup

# Fresh install
cd /path/to/nairovim
./install.sh

# If still issues, restore backup and investigate
mv ~/.config/nvim.backup ~/.config/nvim
```

### Collecting Debug Information

When filing an issue, include:

1. **Neovim version:**
   ```bash
   nvim --version
   ```

2. **Health check output:**
   ```bash
   :checkhealth > health.txt
   ```

3. **Error messages:**
   ```bash
   :messages
   ```

4. **Minimal reproduction:**
   - Steps to reproduce the issue
   - Expected vs actual behavior
   - Relevant configuration files

### File an Issue

If you've tried troubleshooting and still need help:

1. Visit the [GitHub repository](https://github.com/yourusername/nairovim/issues)
2. Search existing issues first
3. Create new issue with:
   - Clear description
   - Steps to reproduce
   - Debug information (see above)
   - Environment (OS, terminal, Neovim version)

### Community Resources

- **Neovim Docs:** `:help` in Neovim
- **Plugin Docs:** `:help plugin-name`
- **Neovim Reddit:** [r/neovim](https://reddit.com/r/neovim)
- **Neovim Discord:** [Neovim Discord Server](https://discord.gg/neovim)

---

## Additional Documentation

- **[README.md](README.md)** - Installation and quick start
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical details and plugin ecosystem
- **[FAQ.md](FAQ.md)** - Frequently asked questions
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines

---

*Last updated: 2025-10-31*
