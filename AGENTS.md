# Project History

High-level overview of development tasks for AI agents.

---

## 2026-02-12: OpenCode Process Cleanup on Exit
**Goal:** Automatically terminate OpenCode server processes when Neovim exits

Implemented robust dual-phase cleanup system for OpenCode server processes. Handles both graceful shutdown on Neovim exit and automatic cleanup of orphaned processes from crashed sessions.

**Implementation Evolution:**

1. **Initial Attempt (Commit `2cb01dc`):**
   - Used complex bash string with nested quotes and escaping
   - Failed due to bash variable escaping issues (`\$pid` evaluated incorrectly)
   - SIGTERM-only approach left some processes alive

2. **Final Implementation (Commit `ac49a43`):**
   - Pure Lua implementation eliminates bash escaping complexity
   - Two-phase cleanup strategy for comprehensive coverage
   - Dual kill approach: SIGTERM → 500ms delay → SIGKILL

**Dual Cleanup Strategy:**

1. **VimLeavePre Autocmd** (Exit Cleanup):
   - Finds all OpenCode processes for current `$NVIM` socket
   - Sends SIGTERM for graceful shutdown
   - After 500ms, sends SIGKILL to force-kill stragglers
   - Ensures clean exit even for stuck processes

2. **Startup Cleanup** (Orphan Removal):
   - Runs 2 seconds after Neovim starts (allows system to settle)
   - Checks each OpenCode process's parent Neovim PID
   - Kills processes whose parent Neovim is dead
   - Prevents accumulation of orphaned processes from crashes

**Process Identification:**
- Uses `$NVIM` environment variable (e.g., `/run/user/1000//nvim.88820.0`)
- Each Neovim instance has unique socket identifier
- OpenCode processes inherit `$NVIM` from parent
- Socket-based matching prevents cross-instance kills

**Why Bash Approach Failed:**
```lua
-- This failed due to $pid escaping issues:
local cmd = [[bash -c "for pid in $(pgrep ...); do kill -15 \$pid; done"]]
-- Problem: \$pid evaluated at wrong time, syntax errors
```

**Pure Lua Solution:**
```lua
local pids = vim.fn.systemlist("pgrep -f 'opencode --port'")
for _, pid in ipairs(pids) do
    vim.fn.system("kill -15 " .. pid)
    vim.defer_fn(function() vim.fn.system("kill -9 " .. pid) end, 500)
end
```

**Testing Results:**
- ✅ Orphaned process detection: Successfully identified parent PID from socket
- ✅ Dual kill strategy: SIGTERM followed by SIGKILL after 500ms
- ✅ Multi-instance safety: Preserves processes from other Neovim sessions
- ✅ Startup cleanup: Removes orphans 2 seconds after launch

**Technical Insight:**
Socket-based tracking (`$NVIM`) is superior to path-based (`cwd`) because:
- Path-based would kill ALL OpenCode sessions in a directory
- Socket-based only kills sessions from specific Neovim instance
- Example: Two Neovim instances in same directory → path-based kills both, socket-based differentiates

**Impact:** Comprehensive cleanup on exit + automatic orphan removal on startup  
**Commits:** `2cb01dc` (initial), `6873485` (docs), `ac49a43` (fix)  
**Files:** 1 file modified (opencode.lua)  
**Line changes:** +54 lines (final implementation)

---

## 2026-02-12: Remove MCPHub, Avante, and CopilotChat
**Goal:** Simplify AI tooling by consolidating to OpenCode as primary AI assistant

Removed redundant AI assistant plugins (mcphub, avante, copilot-chat) to streamline configuration and reduce maintenance overhead. OpenCode.nvim now serves as the primary AI coding assistant alongside GitHub Copilot for inline completions.

**Plugins Removed:**
- `mcphub.nvim` - Model Context Protocol hub (entire `mcp/` directory)
- `avante.nvim` - AI coding assistant with multi-provider support
- `CopilotChat.nvim` - GitHub Copilot chat interface

**Changes Made:**

1. **Plugin Deletions:**
   - `nvim/lua/nairovim/plugins/mcp/mcphub.lua` - Deleted entire mcp directory
   - `nvim/lua/nairovim/plugins/ai/avante.lua` - Deleted plugin config
   - `nvim/lua/nairovim/plugins/ai/copilot-chat.lua` - Deleted plugin config
   - `nvim/lua/nairovim/plugins/customizations/highlights/avante.lua` - Deleted highlights
   - `nvim/lua/nairovim/plugins/customizations/keymaps/copilot-chat.lua` - Deleted keymaps

2. **Configuration Cleanup:**
   - `nvim/lua/nairovim/lazy.lua` - Removed mcp plugin import
   - `nvim/lua/nairovim/plugins/lualine.lua` - Removed MCP status component (58 lines), removed Avante/copilot-chat filetypes
   - `nvim/lua/nairovim/plugins/snacks.lua` - Removed MCPHub dashboard action, removed commented Avante/CopilotChat actions
   - `nvim/lua/nairovim/plugins/init.lua` - Removed Avante/mcphub/copilot-chat from render-markdown filetypes
   - `nvim/lua/nairovim/plugins/ai/opencode.lua` - Removed Avante/copilot-chat comment
   - `nvim/lua/nairovim/utils/workspace.lua` - Removed CopilotChat configuration section

3. **Documentation Updates:**
   - `docs/ARCHITECTURE.md` - Updated AI plugins count (4→2), removed mcp directory from tree, removed plugin table entries
   - `docs/FAQ.md` - Removed Avante provider switching question
   - `docs/TROUBLESHOOTING.md` - Removed CopilotChat from build tools section

**Rationale:**
- OpenCode provides comprehensive AI assistance with Claude Sonnet 4.5
- Multiple overlapping AI tools created configuration complexity
- GitHub Copilot handles inline completions effectively
- Reduced plugin count improves startup time and maintainability

**Impact:** Simplified AI tooling stack, reduced configuration complexity, faster startup  
**Branch:** `feat/remove-mcphub-avante`  
**Files:** 14 files (7 deleted, 7 modified)  
**Line changes:** ~400 lines removed

---

## 2026-02-07: WSL Clipboard Integration
**Goal:** Fix clipboard synchronization between WSL2 and Windows host

Resolved clipboard integration issues where text copied in Neovim or OpenCode terminal wasn't reaching Windows clipboard (and vice versa). Implemented comprehensive solution with automatic provider detection and fallback mechanisms.

**Root Cause:**
- Neovim in WSL2 had no clipboard provider configured for Windows integration
- OpenCode terminal uses OSC 52 escape sequences that weren't bridging to Windows clipboard
- WSLg X11/Wayland clipboard is isolated from Windows host clipboard
- No automatic translation between Linux clipboard tools and Windows clipboard

**Solution Components:**

1. **Neovim Clipboard Provider** (`nvim/lua/nairovim/core/options.lua`)
   - Auto-detects WSL environment (`vim.fn.has("wsl")`)
   - Prefers win32yank (faster, bidirectional) when available
   - Falls back to clip.exe + PowerShell for copy/paste
   - Handles both `+` and `*` registers
   - Automatic CRLF → LF conversion for Windows line endings

2. **win32yank Installation**
   - Downloaded and installed to `~/.local/bin/win32yank.exe`
   - Provides fast, reliable clipboard bridging
   - Supports proper newline handling (`--crlf`, `--lf` flags)

3. **Shell Integration** (`.bashrc` and `.zshrc`)
   - Added WSL-aware clipboard aliases: `pbcopy`, `pbpaste`
   - OpenCode-specific helpers: `copy`, `paste`, `xclip`, `xsel`
   - Exported `COPY_CMD` and `PASTE_CMD` environment variables
   - Conditional loading based on WSL detection

4. **Documentation** (`docs/TROUBLESHOOTING.md`)
   - New "WSL Clipboard Integration Issues" section
   - Troubleshooting steps for common clipboard problems
   - Installation verification procedures
   - OpenCode terminal workarounds
   - Updated Table of Contents

**Verified Functionality:**
- ✅ Neovim copy (`yy`) → Windows paste (Ctrl+V)
- ✅ Windows copy (Ctrl+C) → Neovim paste (`p`)
- ✅ Shell commands: `echo text | clip.exe`
- ✅ win32yank: bidirectional clipboard with proper line endings
- ✅ Automatic provider detection and fallback

**Known Limitations:**
- OpenCode terminal text selection (OSC 52) still requires manual clipboard commands
- Terminal selection "copied to clipboard" message doesn't bridge to Windows
- Workaround: Use `pbcopy`/`clip.exe` piping instead of mouse selection

**Impact:** Full clipboard integration between WSL2 and Windows, enabling seamless workflow across environments  
**Branch:** `fix/wsl-clipboard-integration`  
**Files:** 4 files modified (options.lua, .bashrc, .zshrc, TROUBLESHOOTING.md)  
**Line changes:** +145 lines total

---

## 2025-02-02: OpenCode Windows MCP Configuration Fix
**Goal:** Fix OpenCode global configuration loading on Windows

Discovered and fixed critical issue where OpenCode was not loading global configuration (including MCP servers) on Windows. OpenCode follows XDG Base Directory specification and looks for config at `%USERPROFILE%\.config\opencode`, but the install.ps1 script was incorrectly creating symlinks at `%APPDATA%\opencode`.

**Root Cause:**
- OpenCode uses XDG paths: `~/.config/opencode/opencode.json`
- install.ps1 was using Windows AppData: `%APPDATA%\opencode`
- Result: Global config (model, MCPs, agents) was not loading outside project directories

**Solution:**
- Updated install.ps1 to use correct XDG path: `%USERPROFILE%\.config\opencode`
- Set OPENCODE_CONFIG_DIR environment variable to config directory
- Migrated existing config from AppData to .config location
- Verified MCP servers load correctly in any directory

**Verified MCP Loading:**
- ✅ context7 (remote) - Connected
- ✅ time (local/uvx) - Connected
- ✅ chrome-devtools (local/npx) - Connected
- ✅ playwright (local/npx) - Connected
- ⚠️ github (remote) - Needs GITHUB_PERSONAL_ACCESS_TOKEN env var

**Impact:** OpenCode global configuration now loads correctly on Windows, enabling MCP servers system-wide  
**Files:** install.ps1 (modified), existing config migrated  
**Line changes:** ~5 lines modified in install.ps1

---

## 2025-11-15: Interactive Tutorial System
**Goal:** Create comprehensive guided learning experience for new users

Built complete 7-lesson interactive tutorial system (`:Tutorial` command) covering all essential NairoVIM features. Each lesson includes hands-on practice, mnemonic memory aids, and progressive skill building. Enhanced readability with strategic paragraph breaks, visual separators, and simplified command notation.

**Tutorial Structure:**
- Lesson 1: Basic Navigation (5min) - Movement, saving, modes
- Lesson 2: Efficient Editing (8min) - Text objects, operators, clipboard
- Lesson 3: Search & Navigation (8min) - File/string search, fuzzy finding
- Lesson 4: LSP Features (10min) - Code intelligence, definitions, diagnostics
- Lesson 5: AI Assistant (7min) - OpenCode integration, chat, explanations
- Lesson 6: Git Integration (7min) - Staging, diffing, blame, LazyGit
- Lesson 7: Advanced Tools (5min) - Splits, themes, dashboard, recap

**Features:**
- 41 mnemonic sections with memory aids for 60+ keybindings
- Consistent formatting with `---` and `━━━` visual separators
- Self-paced progression with space bar navigation
- Master pattern summary reinforcing learning retention
- Reset progress feature (`R` key) with confirmation dialog for fresh starts
- ~2,500 lines of instructional content across 50 minutes

**Impact:** Zero-to-productive onboarding path, eliminates learning curve friction  
**Branch:** `user/johnmutuma/tutorial-mvp`  
**Files:** 9 files (init.lua, 7 lessons, utils/tutorial.lua)  
**Commits:** 11 commits (mnemonic enhancements + paragraph formatting + reset progress)

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
