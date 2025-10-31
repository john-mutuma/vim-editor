# Project History

Brief, concise history of AI-assisted development tasks.

---

## 2025-10-31: Environment Enhancements & Configuration Improvements

**PR #65** | `continous-development` → `develop`

- Migrated lazygit from standalone plugin to Snacks built-in integration
- Enabled additional Snacks features: bufdelete, notifier, statuscolumn
- Made install.sh colors theme-adaptive (ANSI colors for light/dark terminals)
- Added Ghostty terminal configuration with TokyoNight theme and tmux-like keybindings
- Added OpenCode AI assistant configuration with Claude Sonnet 4.5
- Configured nvim as default editor for SSH sessions
- Integrated bun runtime with completions and PATH setup
- Enhanced OpenCode terminal with fixed width (85) and markdown rendering
- Updated 15 plugins including avante, opencode, snacks, and lualine
- Relocated scooter and ghostty config symlinks to install_dotfiles function

**Files:** `install.sh`, `.zshrc`, `ghostty_config`, `opencode.json`,
`snacks.lua`, `init.lua`, `keymaps/lazygit.lua`, `opencode.lua`,
`avante.lua`, `lualine.lua`, `scooter.lua`, `scooter.config.toml`,
`lazy-lock.json`, removed `lazygit.lua` and `highlights/lazygit.lua`

---

## 2025-10-07: Backdrop Utility & Scooter Terminal

**PR #64** | `continous-development` → `develop`

- Created reusable `create_backdrop()` in `windows.lua`
- Refactored `with_win_backdrop()` (eliminated ~35 lines duplication)
- Integrated backdrop with scooter terminal (on_open/on_close lifecycle)
- Config updates: scooter winblend=12, width=175; lazygit scale 0.85→0.8

**Files:** `windows.lua`, `scooter.lua`, `lazygit.lua`, `scooter.config.toml`

---
