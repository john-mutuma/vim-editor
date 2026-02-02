# NairoVIM Architecture & Technical Reference

Complete technical documentation for NairoVIM's architecture, plugin ecosystem, and performance characteristics.

## Table of Contents

- [Directory Structure](#directory-structure)
- [Design Principles](#design-principles)
- [Configuration Flow](#configuration-flow)
- [Performance](#performance)
- [Plugin Ecosystem](#plugin-ecosystem)
- [Terminal & Shell Integration](#terminal--shell-integration)
- [Complete Keybinding Reference](#complete-keybinding-reference)
- [AI Tools](#ai-tools)
- [Security Considerations](#security-considerations)
- [Extending NairoVIM](#extending-nairovim)
- [Additional Resources](#additional-resources)

---

## Directory Structure

```
nvim/
├── lua/
│   └── nairovim/
│       ├── core/              # Core configuration
│       │   ├── init.lua       # Entry point
│       │   ├── options.lua    # Vim options
│       │   └── keymaps.lua    # Core keybindings
│       ├── plugins/           # Plugin configurations
│       │   ├── ai/            # AI plugins (Avante, Copilot, OpenCode)
│       │   ├── dap/           # Debugging (DAP)
│       │   ├── lsp/           # Language servers (Mason, LSP, Lspsaga)
│       │   ├── mcp/           # Model Context Protocol (MCPHub)
│       │   ├── customizations/
│       │   │   ├── highlights/ # Plugin-specific highlights
│       │   │   └── keymaps/    # Plugin-specific keybindings
│       │   └── *.lua          # Individual plugin configs
│       ├── types/             # Type definitions
│       │   ├── highlight.lua  # Highlight types
│       │   └── keymap.lua     # Keymap types
│       ├── utils/             # Utility functions
│       │   ├── common.lua     # Common utilities
│       │   ├── git.lua        # Git helpers
│       │   ├── theme.lua      # Theme utilities
│       │   ├── windows.lua    # Window management
│       │   └── workspace.lua  # Workspace helpers
│       └── lazy.lua           # Plugin manager setup
├── init.lua                   # Neovim entry point
└── lazy-lock.json            # Plugin version lockfile
```

---

## Design Principles

### 1. Modular Organization

- Each plugin has its own configuration file
- Related plugins grouped by function (ai/, lsp/, dap/)
- Customizations separated from core configs

### 2. Separation of Concerns

- Core settings isolated in `core/`
- Plugin configurations in `plugins/`
- Reusable utilities in `utils/`
- Type definitions in `types/`

### 3. Lazy Loading Strategy

All plugins use lazy loading to optimize startup time:

```lua
-- Example: Load only when needed
{
  "plugin-name",
  event = "BufReadPre",        -- Load on buffer read
  cmd = "PluginCommand",       -- Load on command
  ft = "javascript",           -- Load for filetype
  keys = "<leader>key",        -- Load on keybinding
}
```

### 4. Reusable Utilities

Common utilities available in `utils/`:

- `create_backdrop()` - Consistent window backdrops
- `with_win_backdrop()` - Window lifecycle management
- `setup_keymap()` - Type-safe keybinding creation
- `get_git_root()` - Git workspace detection

### 5. Type Safety

- Custom type definitions for highlights and keymaps
- Lua Language Server annotations
- Autocomplete support with `lazydev.nvim`

---

## Configuration Flow

```
init.lua
  ↓
core/init.lua (loads core/options.lua, core/keymaps.lua)
  ↓
lazy.lua (plugin manager setup)
  ↓
plugins/init.lua (loads all plugin configs)
  ↓
Individual plugin files load on-demand
```

---

## Performance

### Startup Performance

| Metric | Cold Start | Warm Start |
|--------|-----------|------------|
| **Startup Time** | ~80-120ms | ~40-60ms |
| **Plugins Loaded** | 15-20/70+ | 10-15/70+ |
| **Memory Usage** | ~50-80MB | ~40-60MB |

### Performance Features

- **Lazy Loading**: Plugins load on-demand (event, command, filetype triggers)
- **Async Operations**: Non-blocking file operations, LSP requests, and searches
- **Incremental Parsing**: Treesitter updates syntax highlighting incrementally
- **Smart Caching**: Telescope and LSP results cached for faster subsequent access
- **Optimized Icons**: Web devicons loaded only when needed

### Benchmarking Your Setup

```bash
# Measure startup time
nvim --startuptime startup.log +qa && tail -1 startup.log

# Profile plugin load times
:Lazy profile

# Check LSP performance
:LspInfo
```

### Optimization Tips

- Use `git files` search (`<C-S>f`) instead of `find_files` for large repositories
- Disable unused LSP features via Mason if you don't need them
- Keep plugin count reasonable - remove unused plugins via `:Lazy`
- Use `ripgrep` for searches (automatically used by Telescope/FZF)

---

## Plugin Ecosystem

NairoVIM includes 70+ carefully selected plugins organized into functional categories.

### 🤖 AI & Code Assistance (4 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **opencode.nvim** | AI terminal assistant | Terminal-based AI interaction, session management, Claude integration |
| **avante.nvim** | Advanced AI coding assistant | Context-aware suggestions, slash commands, multi-provider support (Claude, GPT, Copilot) |
| **copilot.lua** | GitHub Copilot integration | Real-time code completion, AI-powered suggestions |
| **CopilotChat.nvim** | Copilot chat interface | Interactive AI conversations, code explanations |

### 🔍 LSP & Language Support (9 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **mason.nvim** | LSP/DAP/linter installer | Easy package management, auto-installation |
| **mason-lspconfig.nvim** | Mason + lspconfig bridge | Automatic LSP server configuration |
| **nvim-lspconfig** | LSP configuration | 20+ language server configurations |
| **lspsaga.nvim** | Enhanced LSP UI | Beautiful hover docs, diagnostics, code actions |
| **glance.nvim** | Peek definitions/references | Split-view code navigation |
| **lsp-lens.nvim** | Show reference counts | Inline reference/implementation counts |
| **lazydev.nvim** | Neovim Lua development | Type checking, completion for Neovim API |
| **none-ls.nvim** | Formatting & diagnostics | Integrates external formatters/linters |
| **mason-null-ls.nvim** | Mason + null-ls bridge | Auto-install formatters/linters |

### 🐛 Debugging (3 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **nvim-dap** | Debug Adapter Protocol | Multi-language debugging support |
| **nvim-dap-ui** | DAP user interface | Visual debugging panels, variable inspection |
| **nvim-dap-vscode-js** | JavaScript/TypeScript debugging | Node.js, browser debugging |

### 🌳 Git Integration (3 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **gitsigns.nvim** | Git decorations | Inline git blame, hunk operations, diff view |
| **snacks.nvim** (lazygit) | Embedded Lazygit | Full git workflow in Neovim, staging, commits, push/pull |
| **diffview.nvim** | Advanced diff viewer | Merge conflict resolution, file history |

### 🔎 Search & Navigation (5 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **telescope.nvim** | Fuzzy finder | Files, grep, buffers, git branches, help tags |
| **telescope-fzf-native.nvim** | FZF sorter for Telescope | Faster fuzzy matching |
| **fzf-lua** | FZF Lua integration | Alternative fuzzy finder |
| **nvim-tree.lua** | File explorer | Tree-style file management, git integration |
| **grug-far.nvim** | Advanced search/replace (Scooter) | Project-wide find and replace |

### 🎨 UI Enhancement (12 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **tokyonight.nvim** | Tokyo Night theme | Dark/light variants, extensive plugin support |
| **catppuccin/nvim** | Catppuccin theme | Mocha, Macchiato, Frappe, Latte variants |
| **gruvbox.nvim** | Gruvbox theme | Retro groove color scheme |
| **nightfox.nvim** | Nightfox theme family | Multiple variants (nordfox, duskfox, etc.) |
| **neovim-ayu** | Ayu theme | Mirage, dark, light variants |
| **lualine.nvim** | Status line | Beautiful, customizable status bar |
| **bufferline.nvim** | Buffer tabs | Visual buffer management |
| **indent-blankline.nvim** | Indent guides | Visual indentation lines |
| **noice.nvim** | Enhanced UI | Better command line, notifications, messages |
| **nvim-notify** | Notification manager | Beautiful floating notifications |
| **which-key.nvim** | Keybinding helper | Shows available keybindings as you type |
| **dressing.nvim** | Better UI inputs | Enhanced vim.ui interfaces |

### ✏️ Editing Tools (8 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **nvim-treesitter** | Syntax parsing | Better highlighting, text objects, code folding |
| **nvim-cmp** | Completion engine | Autocomplete from multiple sources |
| **nvim-autopairs** | Auto-close pairs | Brackets, quotes, HTML tags |
| **vim-surround** | Surround text | Easily add/change/delete surroundings |
| **quick-scope** | Better f/F/t/T motions | Highlights unique characters |
| **vim-highlightedyank** | Highlight yanked text | Visual feedback for yanking |
| **ReplaceWithRegister** | Replace with register | `gr` motion to replace text |
| **nvim-ts-autotag** | Auto-close HTML tags | Treesitter-based tag completion |

### 📝 Markdown Support (2 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **render-markdown.nvim** | Markdown rendering | In-editor markdown preview |
| **markdown-preview.nvim** | Browser preview | Live browser markdown preview |

### 🔧 Utilities (10+ plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **plenary.nvim** | Lua utilities | Required by many plugins |
| **nui.nvim** | UI components | Popup, split, input components |
| **nvim-web-devicons** | File icons | Beautiful file type icons |
| **toggleterm.nvim** | Terminal manager | Floating/split terminals |
| **zen-mode.nvim** | Distraction-free mode | Focused writing/coding |
| **vim-peekaboo** | Register preview | Shows registers when using `"` or `@` |
| **emmet-vim** | Emmet support | HTML/CSS expansion |
| **lspkind.nvim** | VSCode-like icons | Icons for completion items |
| **tiny-inline-diagnostic.nvim** | Inline diagnostics | Show diagnostics inline |
| **img-clip.nvim** | Image clipboard | Paste images into markdown |
| **conform.nvim** | Code formatting | Async formatting with multiple formatters |

### 📦 Plugin Management

| Plugin | Description |
|--------|-------------|
| **lazy.nvim** | Plugin manager | Lazy loading, lockfile, profiling |

---

## Terminal & Shell Integration

NairoVIM integrates seamlessly with modern terminal emulators and shell workflows across all platforms.

### Terminal Emulators by Platform

#### macOS / Linux: Ghostty (Recommended)

**Ghostty** is the recommended terminal for local development on macOS and Linux. It offers:

- ⚡ **GPU-accelerated rendering** - Blazing fast performance
- 🎨 **Native transparency & blur** - Beautiful UI integration
- ⌨️ **Built-in split/tab management** - No multiplexer needed
- 🔧 **tmux-like keybindings** - Familiar Ctrl+b prefix workflow
- 🎯 **Modern features** - Native ligatures, color schemes, shell integration

**Ghostty Keybindings:**

```bash
# Splits
Ctrl+b + |     # Vertical split
Ctrl+b + -     # Horizontal split

# Navigation
Ctrl+b + h/j/k/l   # Navigate between splits

# Tabs
Ctrl+b + c     # New tab
Ctrl+b + n/p   # Next/previous tab

# Zoom
Ctrl+b + z     # Toggle zoom on current split

# Management
Ctrl+b + x     # Close current split/tab
```

**Installation & Configuration:**

```bash
# Install via Homebrew
brew install --cask ghostty

# Config is auto-linked by install.sh
~/.config/ghostty/config -> ~/vim-editor/ghostty_config

# Pre-configured with:
# - TokyoNight theme
# - tmux-like keybindings (Ctrl+b prefix)
# - Nerd Font support
# - Shell integration
```

#### Windows: Windows Terminal (Recommended)

**Windows Terminal** is the recommended terminal for Windows with NairoVIM. It provides:

- ⚡ **GPU-accelerated rendering** - Fast, smooth performance
- 🎨 **Modern UI** - Acrylic transparency and themes
- ⌨️ **Built-in split/tab management** - Multiple panes and tabs
- 🔧 **tmux-like keybindings** - Configured with Ctrl+b prefix
- 🎯 **Windows integration** - PowerShell, CMD, and WSL support

**Windows Terminal Keybindings:**

```powershell
# Splits
Ctrl+b + -     # Horizontal split
Ctrl+b + =     # Vertical split

# Navigation
Ctrl+b + h/j/k/l   # Navigate between panes

# Tabs
Ctrl+b + c     # New tab
Ctrl+b + n/p   # Next/previous tab

# Zoom
Ctrl+b + z     # Toggle pane zoom

# Management
Ctrl+b + x     # Close current pane
```

**Installation & Configuration:**

```powershell
# Install via Scoop (automated by install.ps1)
scoop install windows-terminal

# Or via winget
winget install Microsoft.WindowsTerminal

# Config is auto-linked by install.ps1
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json

# Pre-configured with:
# - TokyoNight color scheme
# - JetBrainsMono Nerd Font
# - tmux-like keybindings (Ctrl+b prefix)
# - Multiple profiles (PowerShell, CMD, WSL)
```

### Platform Comparison

| Feature | Ghostty (macOS/Linux) | Windows Terminal | tmux (Legacy) |
|---------|----------------------|------------------|---------------|
| **Performance** | GPU-accelerated | GPU-accelerated | Terminal + multiplexer overhead |
| **UI Integration** | Native transparency/blur | Acrylic transparency | Requires terminal support |
| **Split Management** | Built-in (Ctrl+b) | Built-in (Ctrl+b) | Requires tmux session |
| **Tab Support** | Native tabs | Native tabs | Windows/panes only |
| **Configuration** | Single config file | JSON settings | Separate .tmux.conf |
| **Platform** | macOS, Linux | Windows 10/11 | Cross-platform |
| **Use Case** | **Local dev (macOS/Linux)** | **Local dev (Windows)** | Remote/SSH workflows |

### Configuration File Locations

| Platform | Config File | Location |
|----------|------------|----------|
| **macOS** (Ghostty) | `ghostty_config` | `~/.config/ghostty/config` |
| **Linux** (Ghostty) | `ghostty_config` | `~/.config/ghostty/config` |
| **Windows** (Windows Terminal) | `windows-terminal-settings.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json` |
| **All** (Neovim) | `nvim/` directory | macOS/Linux: `~/.config/nvim`<br>Windows: `%LOCALAPPDATA%\nvim` |

### Legacy Option: tmux

> **Note:** tmux is supported on macOS/Linux but relegated to legacy/remote workflows only. For local development, use platform-native terminals (Ghostty or Windows Terminal).

**When to use tmux:**

- ✅ SSH/remote development
- ✅ Server administration
- ✅ Session persistence requirements
- ❌ Local development (use platform-native terminal instead)

**tmux Features:**

- Session persistence across disconnects
- Complex pane layouts
- Copy mode with vi keybindings
- Scriptable multiplexing

**Installation (macOS/Linux only):**

```bash
# Optional - only if you need tmux for remote work
brew install tmux

# TPM (tmux plugin manager) - optional
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Shell Configuration

#### macOS / Linux (zsh)

NairoVIM includes a pre-configured `.zshrc` with:

- **oh-my-zsh** framework
- **Powerlevel10k** theme
- **fzf** integration (Ctrl+R, Ctrl+T)
- **vi-mode** keybindings
- **zsh-autosuggestions**
- **git aliases** and completions
- **bun runtime** with PATH setup
- **nvim** as default editor

**Environment Variables:**

```bash
export EDITOR="nvim"
export VISUAL="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export ANTHROPIC_API_KEY="your-key"  # For Avante AI
```

#### Windows (PowerShell)

NairoVIM configures PowerShell with:

- **Oh My Posh** - Modern prompt theme engine
- **TokyoNight theme** - Matching terminal colors
- **PSReadLine** - Enhanced command-line editing
- **Git integration** - Branch status and autocomplete
- **fzf integration** - Fuzzy finding in PowerShell
- **nvim** as default editor

**PowerShell Profile Location:**

```powershell
# Profile auto-configured by install.ps1
$PROFILE  # Usually: C:\Users\<username>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

**Environment Variables:**

```powershell
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
$env:RIPGREP_CONFIG_PATH = "$HOME\.ripgreprc"
$env:ANTHROPIC_API_KEY = "your-key"  # For Avante AI
```

**Useful PowerShell Aliases:**

```powershell
# Added by install.ps1
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim
```

---

## Complete Keybinding Reference

Comprehensive guide to all custom keybindings. Leader key is `,` by default.

### File & Search Navigation

| Keybinding | Mode | Description | Plugin |
|------------|------|-------------|---------|
| `<C-S>f` | n | Find git files | Telescope |
| `<C-S>s` | n | Live grep search | Telescope |
| `<C-S>b` | n | Switch buffers | Telescope |
| `<C-S>r` | n | Recent files | Telescope |
| `<C-S>h` | n | Help tags | Telescope |
| `<C-S>y` | n | Git branches | Telescope |
| `<C-n>` | n | Toggle file explorer | NvimTree |
| `<C-F>f` | n | FZF git files | FZF |
| `<C-F>s` | n | FZF ripgrep search | FZF |
| `<C-F>b` | n | FZF buffers | FZF |
| `<C-F>y` | n | FZF git branches | FZF |

### LSP & Code Intelligence

| Keybinding | Mode | Description | Plugin |
|------------|------|-------------|---------|
| `gd` | n | Go to definition | Glance |
| `gD` | n | Go to declaration | LSP |
| `gi` | n | Go to implementation | Glance |
| `gR` | n | Find references | Glance |
| `gT` | n | Go to type definition | Glance |
| `g>` | n | Outgoing calls | Lspsaga |
| `g<` | n | Incoming calls | Lspsaga |
| `K` | n | Hover documentation | Lspsaga |
| `<leader>ca` | n | Code actions | Lspsaga |
| `<leader>rn` | n | Rename symbol | Lspsaga |
| `<leader>d` | n | Line diagnostics | Lspsaga |
| `<leader>D` | n | Buffer diagnostics | Lspsaga |
| `<leader>wd` | n | Workspace diagnostics | Lspsaga |
| `]e` | n | Next diagnostic | Lspsaga |
| `[e` | n | Previous diagnostic | Lspsaga |

### AI Assistant - OpenCode

| Keybinding | Mode | Description |
|------------|------|-------------|
| `<leader>ot` | n | Toggle OpenCode terminal |
| `<leader>oA` | n | Ask general question |
| `<leader>oa` | n | Ask about cursor position |
| `<leader>oa` | v | Ask about selection |
| `<leader>o+` | n | Add buffer to prompt |
| `<leader>o+` | v | Add selection to prompt |
| `<leader>on` | n | New session |
| `<leader>oy` | n | Copy last response |
| `<leader>os` | n,v | Select prompt |
| `<leader>oe` | n | Explain code at cursor |
| `<S-C-u>` | n | Messages half page up |
| `<S-C-d>` | n | Messages half page down |

### AI Assistant - Copilot

| Keybinding | Mode | Description |
|------------|------|-------------|
| `<leader>cp` | n,v | Open Copilot Chat |

### Git Integration

| Keybinding | Mode | Description | Plugin |
|------------|------|-------------|---------|
| `<leader>G` | n | Open Lazygit | Snacks |
| `]c` | n | Next git hunk | Gitsigns |
| `[c` | n | Previous git hunk | Gitsigns |
| `<leader>hs` | n,v | Stage hunk | Gitsigns |
| `<leader>hr` | n,v | Reset hunk | Gitsigns |
| `<leader>hS` | n | Stage entire buffer | Gitsigns |
| `<leader>hu` | n | Undo stage hunk | Gitsigns |
| `<leader>hR` | n | Reset entire buffer | Gitsigns |
| `<leader>hp` | n | Preview hunk | Gitsigns |
| `<leader>hb` | n | Blame current line | Gitsigns |
| `<leader>hB` | n | Full blame for line | Gitsigns |
| `<leader>htb` | n | Toggle line blame | Gitsigns |
| `<leader>hd` | n | Diff this buffer | Gitsigns |
| `<leader>hD` | n | Diff against last commit | Gitsigns |
| `<leader>htd` | n | Toggle deleted lines | Gitsigns |
| `ih` | o,x | Select hunk (text object) | Gitsigns |

### Search & Replace

| Keybinding | Mode | Description | Plugin |
|------------|------|-------------|---------|
| `<leader>s` | n | Open find and replace | Scooter |
| `<leader>r` | v | Search selected text | Scooter |

### UI & Window Management

| Keybinding | Mode | Description | Plugin |
|------------|------|-------------|---------|
| `<leader>F` | n | Toggle window maximizer | Maximizer |
| `gq` | n | Close current window | Built-in |
| `<C-T>o` | n | Close all other tabs | Built-in |
| `<leader>qq` | n | Quit all windows (soft) | Built-in |
| `<leader>QQ` | n | Quit all windows (force) | Built-in |
| `<leader><CR>` | n | Clear search highlights | Built-in |
| `<leader>DD` | n | Dark theme (tokyonight-night) | Colorscheme |
| `<leader>LL` | n | Light theme (tokyonight-day) | Colorscheme |

### Editing & Text Manipulation

| Keybinding | Mode | Description |
|------------|------|-------------|
| `jk` | i | Exit insert mode |
| `<C-U>` | i | Uppercase current word |
| `j` | n | Move down (respect folds) |
| `k` | n | Move up (respect folds) |
| `<leader>ww` | n | Save file (no autocmd) |
| `<leader>w<CR>` | n | Save file (no autocmd) |

**Additional editing features from plugins:**

- **vim-surround**: `ys`, `cs`, `ds` for surrounding text
- **quick-scope**: Highlights unique characters for `f`, `F`, `t`, `T` motions
- **vim-peekaboo**: Shows register contents when using `"` or `@`
- **nvim-autopairs**: Auto-close brackets, quotes, and HTML tags
- **emmet-vim**: `<C-y>,` for HTML/CSS expansion

---

## AI Tools

### OpenCode - Primary Recommendation

**Terminal-integrated AI assistant with Claude Sonnet 4.5**

#### Setup

```bash
# Set API key
export ANTHROPIC_API_KEY="your-key"

# Get key from: https://console.anthropic.com/
```

#### Core Commands

| Command | Keybinding | Description |
|---------|------------|-------------|
| Toggle terminal | `<leader>ot` | Open/close OpenCode |
| Ask | `<leader>oa` | Ask about cursor/selection |
| Add context | `<leader>o+` | Add file/selection to context |
| General ask | `<leader>oA` | Ask with full context |
| Explain | `<leader>oe` | Explain code at cursor |
| New session | `<leader>on` | Start fresh session |

#### Example Workflows

**Code Review:**
```bash
<leader>oa  # Ask about current function
"Review this function for bugs and improvements"
```

**Multi-File Context:**
```bash
<leader>o+  # Add current file
<leader>o+  # Add another file (repeat as needed)
<leader>oA  # Ask with all context
"How do these files work together?"
```

**Refactoring:**
```bash
# Select code in visual mode
<leader>oa
"Refactor this to be more efficient"
```

#### Features

- ✅ Context-aware with file/cursor position
- ✅ Multi-file context support
- ✅ Session persistence
- ✅ Markdown rendering in terminal
- ✅ Fast & efficient
- ✅ Direct API calls (privacy-focused)

#### Cost

- Claude Sonnet 4.5: ~$3 per million input tokens, ~$15 per million output tokens
- Average query: $0.01 - $0.05
- Typical daily usage: $0.50 - $2.00
- More cost-effective than Copilot subscription for light-moderate usage

### Avante AI - Alternative Assistant

**Sidebar AI chat with multi-provider support**

#### Setup

```bash
# Set API key for your provider
export ANTHROPIC_API_KEY="key"  # or OPENAI_API_KEY
```

#### Usage

```bash
:AvanteAsk    # Ask questions
:AvanteChat   # Open chat
:AvanteEdit   # Edit code with AI
```

#### When to Use Avante

- Need sidebar chat interface
- Want to compare multiple AI providers
- Prefer visual code diffs
- Use slash commands like `/pr_description`

### GitHub Copilot - Code Completion

**Real-time code suggestions**

#### Setup

```bash
:Copilot auth   # Authenticate (requires subscription)
:Copilot status # Check status
```

#### Usage

- Inline suggestions (automatic as you type)
- Chat interface: `<leader>cp`
- Tab to accept suggestions

#### When to Use Copilot

- Need real-time autocomplete
- Already have Copilot subscription ($10/month)
- Want inline suggestions while typing

---

## Security Considerations

### API Key Management

**Environment Variables (Recommended)**

Store credentials in shell configuration:

```bash
# Add to ~/.zshrc or ~/.bashrc
export ANTHROPIC_API_KEY="your-key-here"
export OPENAI_API_KEY="your-key-here"
export GITHUB_TOKEN="your-token-here"
```

**Never commit API keys** to version control. The `.gitignore` excludes:
- `.env` files
- `*.secret` files
- Personal configuration overrides

### AI Provider Security

**Avante AI:**
- API keys loaded from environment variables
- Supports multiple providers (Claude, OpenAI, Copilot)
- No credentials stored in config files

**GitHub Copilot:**
- Authentication via OAuth (`gh auth login`)
- Tokens managed by GitHub CLI (`gh`)
- No plaintext credentials in Neovim

**OpenCode:**
- Configured via `opencode.json` (not tracked in git)
- API keys referenced from environment
- Session data stored locally, not in repo

### Safe Practices

✅ **Do:**
- Use environment variables for API keys
- Authenticate with `gh auth login` for GitHub services
- Keep `lazy-lock.json` updated for reproducible plugin versions
- Review plugin permissions before installation
- Use SSH keys for Git operations

❌ **Don't:**
- Commit `.env` files or secrets to version control
- Share your `opencode.json` with API keys
- Use plaintext passwords in any config files
- Install unverified plugins from unknown sources

### Data Privacy

**Local Data:**
- All configuration and session data stored locally
- No telemetry or analytics sent by NairoVIM itself
- Plugin data policies vary (review before use)

**AI Providers:**
- Code sent to AI services (Anthropic, OpenAI, GitHub) per their privacy policies
- Review provider terms before using AI features
- Use local-only features when working with sensitive code

### Workspace Security

```bash
# Protect sensitive files
echo "*.secret" >> .git/info/exclude
echo ".env*" >> .git/info/exclude

# Scan for accidentally committed secrets (recommended tool)
brew install gitleaks
gitleaks detect
```

---

## Extending NairoVIM

### Adding a New Plugin

1. **Create config file**: `lua/nairovim/plugins/new-plugin.lua`

2. **Add plugin spec with lazy loading**:

```lua
return {
  "author/plugin-name",
  event = "VeryLazy",  -- or cmd, ft, keys
  config = function()
    require("plugin-name").setup({
      -- your config
    })
  end,
}
```

3. **Add keybindings** (optional): `customizations/keymaps/new-plugin.lua`

4. Plugin auto-loads via `plugins/init.lua`

### Adding Custom Utilities

1. **Create utility file** in `utils/`:

```lua
local M = {}

M.my_function = function()
  -- implementation
end

return M
```

2. **Use anywhere**:

```lua
local util = require("nairovim.utils.your-util")
util.my_function()
```

### Modifying Existing Configurations

1. **Find the plugin config**: `lua/nairovim/plugins/<plugin-name>.lua`
2. **Edit the config table** inside the `config` function
3. **Restart Neovim** or reload with `:Lazy reload <plugin-name>`

### Creating Custom Keybindings

Add to `lua/nairovim/core/keymaps.lua`:

```lua
local map = vim.keymap.set

-- Your custom keybindings
map("n", "<leader>x", ":YourCommand<CR>", { desc = "Description" })
map("v", "<leader>y", ":YourVisualCommand<CR>", { desc = "Description" })
```

---

## Additional Resources

- **[README.md](README.md)** - User-facing installation and quick start guide
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Issue resolution guide
- **[FAQ.md](FAQ.md)** - Frequently asked questions
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines

---

*Last updated: 2025-10-31*
