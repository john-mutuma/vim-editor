# NairoVIM

**A modern, AI-powered Neovim IDE configuration that transforms your terminal into a comprehensive development environment.**

Transform your coding experience with NairoVIM - a sophisticated Neovim configuration that combines the legendary efficiency of Vim with modern IDE features, AI assistance, and a beautifully integrated terminal workflow. Whether you're a seasoned developer or new to terminal-based editing, NairoVIM provides everything you need for productive development.

## ✨ Key Features

- 🤖 **AI-Powered Development** - Advanced AI ecosystem with Avante, GitHub Copilot, and MCP integration
- 🎨 **Beautiful UI** - Multiple themes with enhanced status bars and visual elements
- 🔍 **Advanced Search** - Telescope fuzzy finder with FZF and Ripgrep integration
- 📁 **Smart File Management** - Tree-style file explorer with git integration
- 🌳 **Language Intelligence** - LSP support for 20+ programming languages
- 🐛 **Integrated Debugging** - Debug Adapter Protocol with visual debugging
- 📊 **Git Workflow** - Embedded Lazygit with diff viewing and conflict resolution
- ⚡ **Performance Optimized** - Lazy-loaded plugins for fast startup
- 🛠️ **Extensible** - 70+ carefully selected plugins with modular architecture

## 📋 Prerequisites

Before installing NairoVIM, ensure you have these requirements:

### System Requirements

- **macOS or Linux** (Windows WSL supported)
- **Homebrew** - Package manager for macOS/Linux ([install here](https://brew.sh/))
- **Git** - Version control system
- **Terminal with 256-color support** - iTerm2, Terminal.app, or equivalent

### Optional but Recommended

- **Nerd Font** - For proper icon display ([download here](https://www.nerdfonts.com/))
- **Node.js** - For additional LSP servers and tools
- **Python 3** - For certain Neovim plugins

## 🚀 Installation

### Quick Installation

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

### Manual Installation Steps

If you prefer manual installation or encounter issues:

<details>
<summary>Click to expand manual installation steps</summary>

1. **Install Homebrew** (if not already installed):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install core dependencies**:

   ```bash
   brew install neovim tmux fzf ripgrep bat
   ```

3. **Set up configuration files**:

   ```bash
   # Link dotfiles
   ln -sf "$(pwd)/.vimrc" "$HOME/.vimrc"
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

### Common Workflows

#### **Starting a Development Session**

```bash
# Start tmux session
tmux

# Open Neovim
nvim

# Find and open a file
<C-S>f

# Search for text across project
<C-S>s
```

#### **Git Workflow**

```bash
# Open git interface
<leader>G

# Stage changes, commit, and push directly in Lazygit
# Use vim-style navigation: j/k to move, space to stage
```

#### **AI-Assisted Coding**

```bash

# Use Avante AI for advanced assistance
:AvanteAsk

# Ask questions like:
# "Explain this function"
# "Optimize this code"
# "Write unit tests for this"
# "Generate PR description" (Avante slash command)

```

## ⌨️ Complete Keybinding Reference

A comprehensive guide to all custom keybindings in NairoVIM. The leader key is `,` by default.

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

## 📚 Plugin Ecosystem

NairoVIM includes 70+ carefully selected plugins organized into functional categories. All plugins are lazy-loaded for optimal performance.

### 🤖 AI & Code Assistance (4 plugins)

| Plugin | Description | Key Features |
|--------|-------------|--------------|
| **avante.nvim** | Advanced AI coding assistant | Context-aware suggestions, slash commands, multi-provider support (Claude, GPT, Copilot) |
| **copilot.lua** | GitHub Copilot integration | Real-time code completion, AI-powered suggestions |
| **CopilotChat.nvim** | Copilot chat interface | Interactive AI conversations, code explanations |
| **opencode.nvim** | AI terminal assistant | Terminal-based AI interaction, session management |

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

## 🛠️ Post-Installation Setup

### Font Configuration

1. **Install a Nerd Font** (recommended: Hack Nerd Font):

   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-hack-nerd-font
   ```

2. **Configure your terminal** to use the Nerd Font for proper icon display

### Git Configuration

Add these settings to your `~/.gitconfig` for optimal git integration:

```yaml
[core]
  editor = nvim
[merge]
  tool = nvim
[mergetool "nvim"]
  cmd = nvim -c "DiffviewOpen"
[mergetool]
  prompt = false
```

## 🤖 AI Assistance Setup

NairoVIM features a powerful AI ecosystem with three integrated systems:

### Avante AI - Advanced Code Assistant

**Avante** is an AI-powered coding assistant that provides context-aware suggestions and code generation.

**Key Features:**

- **Context-Aware**: Automatically includes project context and MCP server information
- **Multiple Providers**: Supports Claude Sonnet, GitHub Copilot, and other AI models
- **Slash Commands**: Custom commands like `/pr_description` for generating PR descriptions
- **Code Editing**: Direct code modification with AI suggestions
- **File Integration**: Automatically includes relevant project files (like .github directory)

**Usage:**

```bash
# Ask Avante for assistance
:AvanteAsk

# Open interactive chat
:AvanteChat

# Edit selected code with AI
:AvanteEdit

# Use slash commands in chat
/pr_description  # Generate PR title and description
```

### GitHub Copilot - Code Completion

**Setup:**

1. **Authenticate with GitHub**:

   ```bash
   # In Neovim
   :Copilot auth
   ```

2. **Check status**:

   ```bash
   :Copilot status
   ```

**Usage:**

- Real-time code suggestions as you type
- Chat interface with `<leader>cp`
- Context-aware completions

### MCPHub - Model Context Protocol Integration

**MCPHub** enables integration with external tools and services through the Model Context Protocol.

**Key Features:**

- **Tool Integration**: Connect to external APIs, databases, and services
- **Context Sharing**: Share workspace context with AI assistants
- **Extensible**: Add custom MCP servers for specialized workflows
- **Avante Integration**: Seamlessly works with Avante for enhanced capabilities

**Available MCP Servers:**

- **Neovim**: Direct editor integration and file operations
- **Fetch**: Web content retrieval and processing
- **Additional servers**: Can be added based on your workflow needs

**Usage:**

```bash
# Explore and manage MCP servers
:MCPHub

# MCPHub integrates automatically with Avante
# No manual setup required - works behind the scenes
# Provides additional context and capabilities to AI assistants
```

### Language Server Setup

1. **Open Mason** (LSP manager):

   ```bash
   # In Neovim
   :Mason
   ```

2. **Install language servers** for your preferred languages:
   - TypeScript: `typescript-language-server`
   - Python: `pyright`
   - Rust: `rust-analyzer`
   - Go: `gopls`
   - And many more...

## 🎨 Customization

### Theme Selection

Choose from multiple beautiful themes:

```bash
# In Neovim
:colorscheme <Tab><Tab>

# Available themes:
# - catppuccin (default)
# - gruvbox
# - tokyonight
# - dracula
# - monokai
```

### Plugin Management

```bash
# Install/update plugins
:Lazy

# Mason (LSP/tools)
:Mason

# Check plugin status
:Lazy health
```

## 📱 Screenshots

### Dashboard

![NairoVIM Dashboard](examples/screenshot_dashboard.png)
*Homepage dashboard*

### Git Integration

![Embedded Lazygit](examples/screenshot_git-integration.png)
*Seamless git workflow with embedded Lazygit*

### AI Assistant

![GitHub Copilot Chat](examples/screenshot_AI-assistant.png)
*AI-powered coding assistance with Avante AI - GitHub Copilot*

![MCP Hub](examples/screenshot_mcp-hub.png)
*MCP hub to manage your active MCP servers*

### LSP support

![hoverdocs](examples/screenshot_lsp_hoverdoc.png)
*LSP hoverdocs*

![peek-definition](examples/screenshot_lsp_peek-definition.png)
*LSP hoverdocs*

## 🔧 Advanced Configuration

### Working with Language Servers

- **Install LSP servers**: `:Mason` → Browse and install
- **Configure formatters**: `:NullLsInstall` for current filetype
- **Debug adapters**: `:DapInstall` for debugging support

### Tmux Enhancements

- **Plugin management**: `prefix + I` to install plugins
- **Session management**: `prefix + S` to synchronize panes
- **Smart navigation**: `prefix + h/j/k/l` for vim-style pane navigation

### Terminal Optimization

Set up italic text support in iTerm2:

```bash
# Follow instructions at:
# https://weibeld.net/terminals-and-shells/italics.html
```

## 🆘 Troubleshooting

### Common Issues

**Plugins not loading:**

```bash
# In Neovim
:Lazy restore
:Lazy sync
```

**LSP not working:**

```bash
# Check LSP status
:LspInfo

# Install language server
:Mason
```

**Git integration issues:**

```bash
# Verify git configuration
git config --list

# Check Lazygit installation
lazygit --version
```

**Font icons not displaying:**

- Ensure Nerd Font is installed and selected in terminal
- Verify terminal supports Unicode

## 🤝 Contributing

We welcome contributions! Please see our [contributing guidelines](CONTRIBUTING.md) for details.

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

**Ready to transform your coding experience? [Get started now](#-installation)!**
