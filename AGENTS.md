# Project History

Brief, concise history of AI-assisted development tasks.

---

## 2025-10-27: Lazygit Migration to Snacks Plugin

**PR #65** | `continous-development` → `develop`

- Migrated lazygit from standalone plugin to Snacks built-in integration
- Enabled additional Snacks features: bufdelete, notifier, statuscolumn
- Removed redundant `lazygit.lua` and `highlights/lazygit.lua` files
- Updated plugin configurations for OpenCode, Avante, scooter, and lualine
- Updated plugin dependencies via lazy-lock.json

**Files:** `snacks.lua`, `init.lua`, `keymaps/lazygit.lua`,
`opencode.lua`, `avante.lua`, `lualine.lua`, `scooter.lua`,
`scooter.config.toml`, `lazy-lock.json`

---

## 2025-10-07: Backdrop Utility & Scooter Terminal

**PR #64** | `continous-development` → `develop`

- Created reusable `create_backdrop()` in `windows.lua`
- Refactored `with_win_backdrop()` (eliminated ~35 lines duplication)
- Integrated backdrop with scooter terminal (on_open/on_close lifecycle)
- Config updates: scooter winblend=12, width=175; lazygit scale 0.85→0.8

**Files:** `windows.lua`, `scooter.lua`, `lazygit.lua`, `scooter.config.toml`

---
