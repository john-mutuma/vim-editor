# NairoVIM

**A modern, AI-powered Neovim IDE configuration that transforms your terminal into a comprehensive development environment.**

Transform your coding experience with NairoVIM - a sophisticated Neovim configuration that combines the legendary efficiency of Vim with modern IDE features, AI assistance, and a beautifully integrated terminal workflow. Whether you're a seasoned developer or new to terminal-based editing, NairoVIM provides everything you need for productive development.

## ✨ Key Features

- 🤖 **AI-Powered Development** - Integrated OpenCode, Avante AI, and GitHub Copilot support
- 🎨 **Beautiful UI** - Multiple themes with enhanced status bars and visual elements
- 🔍 **Advanced Search** - Telescope fuzzy finder with FZF and Ripgrep integration
- 📁 **Smart File Management** - Tree-style file explorer with git integration
- 🌳 **Language Intelligence** - LSP support for 20+ programming languages
- 🐛 **Integrated Debugging** - Debug Adapter Protocol with visual debugging
- 📊 **Git Workflow** - Embedded Lazygit with diff viewing and conflict resolution
- ⚡ **Performance Optimized** - Lazy-loaded plugins for fast startup (~40-120ms)
- 🛠️ **Extensible** - 70+ carefully selected plugins with modular architecture

## 📋 Prerequisites

### System Requirements

- **macOS or Linux** (Windows WSL supported)
- **Homebrew** - Package manager ([install here](https://brew.sh/))
- **Git** - Version control system
- **Terminal with 256-color support** - iTerm2, Terminal.app, Ghostty, or equivalent

### Optional but Recommended

- **Nerd Font** - For proper icon display ([download here](https://www.nerdfonts.com/))
- **Node.js** - For additional LSP servers and tools
- **Python 3** - For certain Neovim plugins

## 🚀 Quick Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/nairovim.git
   cd nairovim
   ```

2. **Run the installation script**:

   ```bash
   ./install.sh
   ```

3. **Start your development environment**:

   ```bash
   tmux
   nvim
   ```

That's it! The installation script will:

- ✅ Install Neovim and essential development tools
- ✅ Set up tmux with enhanced configuration
- ✅ Configure zsh with Oh My Zsh
- ✅ Install and configure 70+ Neovim plugins
- ✅ Set up development utilities (FZF, Ripgrep, Lazygit, etc.)
- ✅ Create backups of existing configurations

<details>
<summary>Manual Installation (click to expand)</summary>

1. **Install Homebrew** (if not already installed):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install core dependencies**:

   ```bash
   brew install neovim tmux fzf ripgrep bat lazygit
   ```

3. **Set up configuration files**:

   ```bash
   # Link dotfiles
   ln -sf "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"
   ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"
   
   # Link Neovim config
   ln -sf "$(pwd)/nvim" "$HOME/.config/nvim"
   ```

4. **Install tmux plugins**:

   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

5. **Install Oh My Zsh**:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

</details>

## 🎯 Quick Start Guide

### Starting a Development Session

```bash
# Start tmux session
tmux

# Open Neovim
nvim

# Find and open a file
<Ctrl-Shift>f

# Search for text across project
<Ctrl-Shift>s

# Open file explorer
<Ctrl-n>
```

### Essential Workflows

#### Git Workflow

```bash
# Open integrated Lazygit
,G

# Use vim-style navigation: j/k to move, space to stage
# Make commits and push directly from Neovim
```

#### AI-Assisted Coding

```bash
# Toggle OpenCode terminal (recommended)
,ot

# Ask about current code
,oa

# Add file context and ask questions
,o+
,oA
```

## ⌨️ Essential Keybindings

The leader key is `,` by default. Here are the most commonly used keybindings:

### File Navigation & Search

| Keybinding | Description |
|------------|-------------|
| `<C-S>f` | Find git files (Telescope) |
| `<C-S>s` | Live grep search across project |
| `<C-S>b` | Switch buffers |
| `<C-S>r` | Recent files |
| `<C-n>` | Toggle file explorer |
| `<C-F>f` | FZF git files (alternative) |

### LSP & Code Intelligence

| Keybinding | Description |
|------------|-------------|
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gR` | Find references |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `]e` / `[e` | Next/previous diagnostic |

### AI Assistance (OpenCode)

| Keybinding | Description |
|------------|-------------|
| `<leader>ot` | Toggle OpenCode terminal |
| `<leader>oa` | Ask about cursor/selection |
| `<leader>o+` | Add buffer/selection to context |
| `<leader>oe` | Explain code at cursor |
| `<leader>on` | New AI session |

### Git Integration

| Keybinding | Description |
|------------|-------------|
| `<leader>G` | Open Lazygit |
| `]c` / `[c` | Next/previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

### Window Management

| Keybinding | Description |
|------------|-------------|
| `<leader>F` | Maximize current window |
| `<leader>s` | Find and replace (Scooter) |
| `<leader><CR>` | Clear search highlights |
| `jk` | Exit insert mode |

> 📖 **See complete keybinding reference**: Check [ARCHITECTURE.md](doc/ARCHITECTURE.md#complete-keybinding-reference) for all 70+ keybindings.

## 🤖 AI Assistance Setup

### OpenCode - Primary AI Assistant (Recommended)

**OpenCode** provides seamless AI assistance directly in your terminal with full context awareness.

#### Quick Setup

1. **Set your Anthropic API key**:

   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export ANTHROPIC_API_KEY="your-api-key-here"
   
   # Reload shell
   source ~/.zshrc
   ```

2. **Get your API key** from [Anthropic Console](https://console.anthropic.com/)

3. **Start using OpenCode**:

   ```bash
   # In Neovim
   ,ot  # Toggle OpenCode terminal
   ```

#### Basic Usage

```bash
# Ask about current code
,oa

# Add file to context
,o+

# Ask general question with context
,oA

# Explain code at cursor
,oe

# Start new session
,on
```

**Key Features:**
- ✅ Context-aware with multi-file support
- ✅ Session persistence
- ✅ Beautiful markdown rendering in terminal
- ✅ Fast & efficient
- ✅ Direct API calls (privacy-focused)

**Cost:** ~$0.01-$0.05 per query, ~$0.50-$2.00 daily for typical usage

> 📖 **For alternative AI tools** (Avante, Copilot): See [ARCHITECTURE.md - AI Tools](doc/ARCHITECTURE.md#ai-tools)

## 🎨 Post-Installation Setup

### 1. Install a Nerd Font

```bash
# Recommended: Hack Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

Then configure your terminal to use the Nerd Font.

### 2. Set Up Language Servers

```bash
# In Neovim, open Mason
:Mason

# Install language servers for your languages:
# - TypeScript: typescript-language-server
# - Python: pyright
# - Rust: rust-analyzer
# - Go: gopls
# Navigate with j/k, press 'i' to install
```

### 3. Configure Git

Add to `~/.gitconfig`:

```yaml
[core]
  editor = nvim
[merge]
  tool = nvim
[mergetool "nvim"]
  cmd = nvim -c "DiffviewOpen"
```

## 📸 Screenshots

### Dashboard
![NairoVIM Dashboard](examples/screenshot_dashboard.png)

### Git Integration
![Embedded Lazygit](examples/screenshot_git-integration.png)

### AI Assistant
![AI Assistant](examples/screenshot_AI-assistant.png)

### LSP Support
![Hover Documentation](examples/screenshot_lsp_hoverdoc.png)
![Peek Definition](examples/screenshot_lsp_peek-definition.png)

## 🎨 Customization

### Change Theme

```bash
# In Neovim
:colorscheme <Tab>

# Available themes:
# - tokyonight-night (default dark)
# - tokyonight-day (light)
# - catppuccin
# - gruvbox
# - nightfox
```

Or use keybindings:
- `<leader>DD` - Dark theme (tokyonight-night)
- `<leader>LL` - Light theme (tokyonight-day)

### Manage Plugins

```bash
# Open plugin manager
:Lazy

# Common operations:
# - Update plugins: U
# - Install new: I
# - Clean unused: X
# - View logs: L

# Open LSP/tool manager
:Mason
```

### Disable Unwanted Plugins

Edit the plugin file (e.g., `lua/nairovim/plugins/plugin-name.lua`):

```lua
return {
  "plugin/name",
  enabled = false,  -- Add this line
}
```

## 🆘 Troubleshooting

### Quick Fixes

**Plugins not loading:**
```bash
:Lazy restore
:Lazy sync
```

**LSP not working:**
```bash
:LspInfo
:Mason  # Install language servers
```

**Icons not showing:**
```bash
# Install Nerd Font and configure terminal to use it
brew install --cask font-hack-nerd-font
```

**Slow startup:**
```bash
# Profile plugins
:Lazy profile

# Disable unused plugins (see Customization above)
```

> 📖 **Comprehensive troubleshooting guide**: See [TROUBLESHOOTING.md](doc/TROUBLESHOOTING.md)

## 📚 Documentation

- **[ARCHITECTURE.md](doc/ARCHITECTURE.md)** - Technical details, plugin ecosystem, complete keybindings
- **[TROUBLESHOOTING.md](doc/TROUBLESHOOTING.md)** - Detailed issue resolution guide
- **[FAQ.md](doc/FAQ.md)** - Frequently asked questions
- **[CONTRIBUTING.md](doc/CONTRIBUTING.md)** - Contribution guidelines

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](doc/CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

NairoVIM is built on the shoulders of giants. Special thanks to:

- The Neovim team for the amazing editor
- All plugin authors who make this configuration possible
- The open source community for continuous inspiration

---

```txt
.oPYo.                    8     o                         88 88 88
8    8                    8     8                         88 88 88
8      .oPYo. .oPYo. .oPYo8    o8P .oPYo.   .oPYo. .oPYo. 88 88 88
8   oo 8    8 8    8 8    8     8  8    8   8    8 8    8 88 88 88
8    8 8    8 8    8 8    8     8  8    8   8    8 8    8 `' `' `'
`YooP8 `YooP' `YooP' `YooP'     8  `YooP'   `YooP8 `YooP' 88 88 88
:....8 :.....::.....::.....:::::..::.....::::....8 :.....:.........
:::::8 :::::::::::::::::::::::::::::::::::::::ooP'.::::::::::::::::
:::::..:::::::::::::::::::::::::::::::::::::::...::::::::::::::::::
```

**Ready to transform your coding experience? [Get started now](#-quick-installation)!**
