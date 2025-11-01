# Project History

High-level overview of development tasks for AI agents.

---

## 2025-11-01: Plugin Cleanup
**Goal:** Eliminate redundant search/replace tools and consolidate terminal APIs

Removed grug-far plugin in favor of scooter for search/replace functionality. Refactored scooter to use Snacks.terminal API (replacing old toggleterm dependency). Updated Snacks dashboard to use `:FindReplace` command. Maintained backdrop functionality and all scooter keybindings.

**Impact:** Single search/replace tool, consistent terminal API across config  
**Files:** 4 files modified, -67 lines

---

## 2025-11-01: Documentation TOCs
**Goal:** Improve navigation in lengthy documentation files

Added comprehensive Table of Contents to all major documentation files. README.md received 34-line TOC covering all sections. Completed missing TOC entries in FAQ, TROUBLESHOOTING, CONTRIBUTING, and ARCHITECTURE docs.

**Impact:** One-click navigation to any section, better discoverability  
**Files:** 5 files modified, +39 lines

---

## 2025-10-31: Ghostty Terminal Priority
**Goal:** Modernize terminal strategy with GPU-accelerated terminal emulator

Strategic documentation update to position Ghostty as primary recommended terminal, relegating tmux to legacy/remote-only use cases. Updated prerequisites, installation guide, quick start workflows. Added Ghostty troubleshooting sections and comparison tables. Ghostty uses tmux-like keybindings (Ctrl+b prefix) for easy transition.

**Impact:** Simpler local dev setup, better performance, clear guidance  
**Files:** 4 files (README, ARCHITECTURE, FAQ, TROUBLESHOOTING), +314 lines

---

## 2025-10-31: Documentation Restructuring
**Goal:** Make documentation more accessible for new users

Split monolithic 1500-line README into specialized files with clear separation of concerns:
- README.md (~400 lines): User-facing quick start
- ARCHITECTURE.md (~600 lines): Technical deep-dive, 70+ plugins, 70+ keybindings
- TROUBLESHOOTING.md (~550 lines): Issue resolution by category
- FAQ.md (~300 lines): Common questions (40+ Q&As)
- CONTRIBUTING.md: Contribution guidelines

**Impact:** New users get started faster, easier maintenance, professional appearance  
**Files:** Created 5 new doc files, reorganized all documentation

---

## 2025-11-01: README Enhancement
**Goal:** Comprehensive reference for keybindings and plugin ecosystem

Added detailed keybinding reference with 70+ mappings across 8 categories (File/Search, LSP, AI tools, Git, UI, etc.). Documented all 70+ plugins organized into 11 functional categories. Removed duplicate "Essential Shortcuts" section and outdated nvim-ide references.

**Impact:** Complete plugin/keybinding reference in one place  
**Files:** README.md, +235, -53 lines

---

## 2025-10-31: Environment & Config
**Goal:** Modernize development environment and consolidate tools

Migrated lazygit from standalone plugin to Snacks built-in integration. Added Ghostty terminal config with TokyoNight theme and tmux-like keybindings. Added OpenCode AI assistant configuration with Claude Sonnet 4.5. Made install.sh colors theme-adaptive. Integrated bun runtime with completions. Updated 15 plugins including avante, opencode, snacks, lualine.

**Impact:** Cleaner plugin setup, modern terminal, AI assistant ready  
**Files:** 12 files modified, removed 2 plugin files

---

## 2025-10-07: Backdrop Utility
**Goal:** Create reusable backdrop utility to reduce code duplication

Created `create_backdrop()` function in windows.lua for reusable backdrop management. Refactored `with_win_backdrop()` eliminating ~35 lines of duplication. Integrated backdrop with scooter terminal using on_open/on_close lifecycle hooks. Updated scooter config (winblend=12, width=175).

**Impact:** DRY code, consistent backdrop behavior across features  
**Files:** windows.lua, scooter.lua, lazygit.lua, scooter.config.toml
