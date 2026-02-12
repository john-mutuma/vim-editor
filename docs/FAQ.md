# Frequently Asked Questions

Common questions and answers about NairoVIM installation, configuration, and usage.

## Table of Contents

- [Installation & Setup](#installation--setup)
- [Configuration & Customization](#configuration--customization)
- [Plugins & Features](#plugins--features)
- [AI Tools](#ai-tools)
- [Performance](#performance)
- [Keybindings](#keybindings)
- [Troubleshooting](#troubleshooting)
- [General Questions](#general-questions)
- [Still Have Questions?](#still-have-questions)

---

## Installation & Setup

### Q: What operating systems are supported?

**A:** NairoVIM officially supports:
- macOS (primary platform)
- Linux distributions
- Windows via WSL (Windows Subsystem for Linux)

### Q: Do I need to uninstall my current Neovim configuration?

**A:** No, the installation script automatically creates backups of existing configurations with timestamps (e.g., `.config/nvim.backup.2025-10-31`). You can restore your old config anytime or keep both by switching symlinks.

### Q: What's the minimum Neovim version required?

**A:** Neovim 0.9.0 or higher is required. The installation script automatically installs the latest stable version via Homebrew. Check your version with `nvim --version`.

### Q: Should I use Ghostty or tmux?

**A:** **Ghostty is now the recommended terminal** for NairoVIM. It provides native split and tab management with better performance and modern GPU rendering. tmux is considered a legacy option, primarily useful for:
- Remote SSH sessions requiring session persistence
- Workflows that depend heavily on tmux plugins
- Transitioning from existing tmux workflows

For local development, Ghostty offers superior performance and a more integrated experience.

### Q: How do I use Ghostty splits and tabs?

**A:** NairoVIM configures Ghostty with familiar tmux-like keybindings:

**Splits:**
- `Ctrl+b` then `-` - Horizontal split
- `Ctrl+b` then `\` - Vertical split
- `Ctrl+b` then `h/j/k/l` - Navigate splits
- `Ctrl+b` then `z` - Toggle zoom

**Tabs:**
- `Ctrl+b` then `c` - New tab
- `Ctrl+b` then `n/p` - Next/previous tab
- `Ctrl+b` then `x` - Close tab

These are pre-configured in the included `ghostty_config` file.

### Q: How long does the installation take?

**A:** Complete installation typically takes 5-15 minutes depending on your internet connection and whether you need to install Homebrew. The script handles everything automatically.

### Q: What if I don't have Homebrew installed?

**A:** The installation script will detect if Homebrew is missing and provide instructions to install it first. Alternatively, you can install Homebrew manually from [brew.sh](https://brew.sh/).

---

## Configuration & Customization

### Q: How do I change the leader key?

**A:** Edit `nvim/lua/nairovim/core/options.lua` and change:

```lua
vim.g.mapleader = ","  -- Change to your preferred key
```

Common alternatives: `\` (default Vim), `<Space>`, `;`

### Q: How do I switch between light and dark themes?

**A:** Use the built-in keybindings:
- `<leader>DD` - Switch to dark theme (tokyonight-night)
- `<leader>LL` - Switch to light theme (tokyonight-day)

Or manually: `:colorscheme tokyonight-day`

### Q: Can I use my own colorscheme?

**A:** Yes! Either:
1. Add your theme plugin to `lua/nairovim/plugins/`
2. Set it in your config: `:colorscheme your-theme`
3. Or edit the theme utility in `lua/nairovim/utils/theme.lua`

### Q: How do I disable plugins I don't use?

**A:** Edit the plugin file (e.g., `lua/nairovim/plugins/plugin-name.lua`) and add:

```lua
return {
  "plugin/name",
  enabled = false,  -- Disable this plugin
}
```

Then restart Neovim or run `:Lazy sync`.

### Q: Where are my Neovim configurations stored?

**A:** All configurations are in `~/.config/nvim/` which is symlinked to the cloned repository's `nvim/` directory. This allows easy updates via Git while keeping your setup organized.

### Q: How do I update NairoVIM?

**A:**
```bash
cd /path/to/nairovim
git pull
nvim
:Lazy sync
```

The `lazy-lock.json` file ensures consistent plugin versions across updates.

---

## Plugins & Features

### Q: How many plugins does NairoVIM include?

**A:** NairoVIM includes 70+ carefully selected plugins organized into 11 functional categories. However, thanks to lazy loading, only 10-20 plugins load on startup, keeping performance optimal.

### Q: What's the difference between Telescope and FZF?

**A:** Both are fuzzy finders:
- **Telescope**: Lua-based, feature-rich, better UI, slightly slower on huge repos
- **FZF**: Binary-based, extremely fast, minimal UI, better for large codebases

NairoVIM includes both. Use `<C-S>` prefix for Telescope, `<C-F>` for FZF.

### Q: Can I use NairoVIM for [language]?

**A:** NairoVIM supports 20+ languages via LSP. Check if your language has a language server:
1. Open Neovim
2. Run `:Mason`
3. Search for your language (e.g., "python", "rust", "go")
4. Press `i` to install the language server

### Q: How do I add a new language server?

**A:**
1. `:Mason` to open the Mason interface
2. Search for your language server (e.g., `typescript-language-server`)
3. Navigate to it and press `i` to install
4. Restart Neovim

Mason automatically configures the LSP for supported languages.

### Q: What file formats does the tree explorer support?

**A:** NvimTree supports all file types and provides special icons for 200+ file extensions. It also integrates with Git to show file status (modified, staged, untracked, etc.).

---

## AI Tools

### Q: Which AI tool should I use?

**A:**

| Use Case | Recommended Tool |
|----------|-----------------|
| General coding assistance | **OpenCode** |
| Real-time code completion | **GitHub Copilot** |
| Multi-provider comparison | **Avante AI** |
| Privacy-focused (local only) | None - use LSP features |

**Default recommendation: OpenCode** - Best balance of features, cost, and user experience.

### Q: How much does OpenCode cost?

**A:** OpenCode uses Claude Sonnet 4.5 via Anthropic API:
- ~$3 per million input tokens
- ~$15 per million output tokens
- Average query: $0.01 - $0.05
- Typical daily usage: $0.50 - $2.00

More cost-effective than Copilot ($10/month) for light-to-moderate usage.

### Q: Can I use OpenCode without an API key?

**A:** No, OpenCode requires an Anthropic API key to function. You can get one from [console.anthropic.com](https://console.anthropic.com/). However, you can still use all other NairoVIM features without AI tools.

### Q: Is my code sent to external servers when using AI tools?

**A:** 
- **OpenCode**: Sends code to Anthropic (Claude) - review their privacy policy
- **Avante**: Sends to configured provider (Anthropic, OpenAI, etc.)
- **GitHub Copilot**: Sends to GitHub/Microsoft servers
- **LSP features**: All local - no external communication

If working with sensitive code, use only LSP-based features (code completion, navigation, diagnostics).

### Q: Can I use multiple AI providers at once?

**A:** Yes! NairoVIM includes:
- OpenCode (Anthropic)
- GitHub Copilot

You can have both configured and switch between them as needed.

---

## Performance

### Q: Why does Neovim start slowly after installation?

**A:** First launch is typically slower due to:
1. Lazy.nvim installing/compiling plugins
2. Treesitter downloading and compiling parsers
3. LSP servers initializing

Subsequent launches should be 40-120ms. If still slow, check `:Lazy profile`.

### Q: How can I make Neovim start faster?

**A:**
1. Disable unused plugins (see customization above)
2. Check startup time: `nvim --startuptime startup.log`
3. Profile plugins: `:Lazy profile`
4. Remove unused language servers in `:Mason`

### Q: Is NairoVIM suitable for large codebases?

**A:** Yes! NairoVIM is optimized for large projects:
- Lazy loading minimizes memory usage
- Ripgrep provides fast project-wide searches
- Git file search (`<C-S>f`) respects `.gitignore`
- LSP servers run in separate processes
- Treesitter uses incremental parsing

Successfully tested on repositories with 100k+ files.

### Q: Does NairoVIM work well over SSH?

**A:** Yes, NairoVIM is terminal-based and works perfectly over SSH. All features work remotely except:
- Clipboard integration (requires SSH X11 forwarding or clipboard tool)
- System notifications (will display in Neovim instead)

---

## Keybindings

### Q: Why isn't `<C-S>` working in my terminal?

**A:** Some terminals intercept `Ctrl-S` for flow control. Solutions:

```bash
# Add to ~/.zshrc or ~/.bashrc
stty -ixon  # Disable flow control

# Or use alternative keybindings with <C-F> prefix (FZF)
```

### Q: How do I see all available keybindings?

**A:** Multiple ways:
1. Press `<leader>` and wait - which-key will show options
2. Run `:WhichKey` to see all keybindings
3. Check [ARCHITECTURE.md - Keybinding Reference](ARCHITECTURE.md#complete-keybinding-reference)
4. Run `:map` to list all mappings

### Q: Can I use my own keybindings?

**A:** Yes! Add them to `lua/nairovim/core/keymaps.lua`:

```lua
local map = vim.keymap.set

-- Your custom keybindings
map("n", "<leader>x", ":YourCommand<CR>", { desc = "Description" })
```

### Q: What does `jk` do?

**A:** `jk` is a quick escape from insert mode to normal mode. It's a popular Vim pattern that's faster than reaching for `<Esc>`. If you don't like it, disable it in `core/keymaps.lua`.

### Q: How do I remap Telescope keybindings?

**A:** Edit `lua/nairovim/plugins/customizations/keymaps/telescope.lua` and modify the keybinding definitions. Restart Neovim for changes to take effect.

---

## Troubleshooting

### Q: I see broken icons and glyphs - how do I fix them?

**A:**
1. Install a Nerd Font: `brew install --cask font-hack-nerd-font`
2. Configure your terminal to use the Nerd Font
3. Restart your terminal
4. Verify with: `echo "\ue0b0"`  (should show a triangle)

### Q: LSP isn't working for my language - what should I do?

**A:**
1. Check if LSP is running: `:LspInfo`
2. Install language server: `:Mason` then `i` to install
3. Check LSP logs: `:LspLog`
4. Restart LSP: `:LspRestart`

See [TROUBLESHOOTING.md - LSP Issues](TROUBLESHOOTING.md#lsp-issues) for detailed steps.

### Q: Plugins won't load after update - how to fix?

**A:**
```bash
# In Neovim
:Lazy restore  # Restore from lockfile
:Lazy sync     # Re-sync all plugins
:Lazy clean    # Remove unused plugins

# If still broken, clear cache
rm -rf ~/.local/share/nvim
nvim  # Will reinstall everything
```

### Q: OpenCode terminal won't open - what's wrong?

**A:** Check:
1. API key is set: `echo $ANTHROPIC_API_KEY`
2. OpenCode is installed: `which opencode`
3. Check logs: `:messages`

See [TROUBLESHOOTING.md - AI Tools](TROUBLESHOOTING.md#ai-tools-issues) for more details.

### Q: Git integration (Lazygit) shows errors - how to fix?

**A:**
1. Ensure Lazygit is installed: `which lazygit`
2. Update Lazygit: `brew upgrade lazygit`
3. Check Git config: `git config --list`

Lazygit requires Git 2.0+ and proper Git configuration.

### Q: How do I completely reset NairoVIM?

**A:**
```bash
# Remove all Neovim data
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Restore from backup (if needed)
rm ~/.config/nvim
mv ~/.config/nvim.backup.TIMESTAMP ~/.config/nvim

# Or reinstall from scratch
cd nairovim
./install.sh
```

---

## General Questions

### Q: Is NairoVIM suitable for beginners?

**A:** NairoVIM is best suited for developers who:
- Have basic Vim/Neovim knowledge
- Are comfortable with terminal environments
- Want a comprehensive IDE-like experience

**For complete beginners**, consider:
1. Start with `vimtutor` (built into Vim)
2. Learn basic Vim motions first
3. Then explore NairoVIM's features gradually

### Q: Can I use NairoVIM alongside VSCode?

**A:** Yes! Many developers use both:
- NairoVIM for terminal-based work, SSH sessions, quick edits
- VSCode for visual debugging, complex refactoring, GUI tools

You can even use the [VSCode Neovim extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) for Vim motions in VSCode.

### Q: How is NairoVIM different from other Neovim distributions?

**A:** NairoVIM focuses on:
- **AI-first development** - Built-in OpenCode, Avante, Copilot
- **Terminal workflow** - Native Ghostty splits/tabs + lazygit + scooter integration
- **Modular architecture** - Easy to understand and customize
- **Performance** - Aggressive lazy loading, ~40-120ms startup
- **Complete documentation** - Extensive guides for all features

### Q: Can I contribute to NairoVIM?

**A:** Absolutely! We welcome contributions:
- Bug fixes and improvements
- New plugin integrations
- Documentation enhancements
- Theme additions
- Performance optimizations

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Q: Does NairoVIM support remote development?

**A:** Yes! NairoVIM works great for remote development:
- Over SSH (full functionality)
- Inside Docker containers
- On remote servers
- Via Ghostty splits/tabs (or tmux for remote sessions)

All features work remotely since it's terminal-based.

### Q: How do I get help or report issues?

**A:**
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) first
2. Search existing issues on GitHub
3. Open a new issue with:
   - Neovim version (`:version`)
   - OS and terminal info
   - Steps to reproduce
   - Relevant logs (`:messages`, `:LspLog`)

### Q: What's the learning curve like?

**A:** Learning curve breakdown:
- **Day 1-3**: Basic navigation, file management, essential keybindings
- **Week 1**: LSP features, git workflow, AI tools basics
- **Week 2-4**: Advanced features, customization, workflow optimization
- **Month 1+**: Muscle memory, expert-level productivity

Most users feel productive within the first week.

### Q: Can I use NairoVIM for non-programming tasks?

**A:** Yes! NairoVIM is excellent for:
- Markdown writing (with preview)
- Note-taking
- Configuration file editing
- Documentation writing
- Script automation
- Any text-based workflow

The Markdown rendering and zen-mode plugins make it great for writing.

### Q: Is there a community or Discord?

**A:** Currently, community support is primarily through:
- GitHub Issues (bug reports, questions)
- GitHub Discussions (general chat, ideas)
- Pull Requests (contributions)

Check the repository for links to community channels.

### Q: What's the difference between NairoVIM and LazyVim/AstroVim?

**A:**

| Feature | NairoVIM | LazyVim | AstroVim |
|---------|----------|---------|----------|
| **Focus** | AI-first dev workflow | Minimal core | Feature-complete distribution |
| **AI Tools** | OpenCode + Avante + Copilot | Limited | Limited |
| **Terminal Integration** | Deep (Ghostty, lazygit, scooter) | Basic | Basic |
| **Customization** | Modular Lua configs | LazyExtras system | AstroUI + overrides |
| **Learning Curve** | Moderate | Moderate | Steeper |
| **Startup Time** | ~40-120ms | ~30-80ms | ~50-150ms |

Choose based on your workflow preferences and priorities.

---

## Still Have Questions?

- 📖 Check [ARCHITECTURE.md](ARCHITECTURE.md) for technical details
- 🔧 See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for issue resolution
- 🤝 Read [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
- 📝 Review the [README.md](README.md) for installation and quick start

**Can't find your answer?** Open an issue on GitHub!

---

*Last updated: 2025-10-31*
