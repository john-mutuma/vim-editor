# NairoVIM Troubleshooting Guide

Comprehensive guide to resolving common issues with NairoVIM.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Plugin Issues](#plugin-issues)
- [LSP Issues](#lsp-issues)
- [AI Assistant Issues](#ai-assistant-issues)
- [Git Integration Issues](#git-integration-issues)
- [UI and Display Issues](#ui-and-display-issues)
- [Performance Issues](#performance-issues)
- [Keybinding Conflicts](#keybinding-conflicts)
- [Terminal and Shell Issues](#terminal-and-shell-issues)
- [Getting Help](#getting-help)

---

## Installation Issues

### Homebrew not found

**Problem:** Installation script cannot find Homebrew.

**Solution:**

```bash
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (follow post-install instructions)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### Installation script fails

**Problem:** Installation script encounters errors.

**Solution:**

```bash
# Check for errors in the output
./install.sh 2>&1 | tee install.log

# Run individual steps manually if needed
brew install neovim tmux fzf ripgrep bat lazygit

# Verify installations
nvim --version
tmux -V
fzf --version
```

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
# iTerm2: Preferences → Profiles → Text → Font
# Terminal.app: Preferences → Profiles → Text → Font
# Ghostty: Edit config file

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
# Try different terminal emulator
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

### Tmux integration not working

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

### Shell completions missing

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
