# Project History

High-level overview of development tasks for AI agents.

---

## 2026-02-28: Sidekick Plugin Configuration & Keymap Refactoring
**Goal:** Add complete sidekick.nvim plugin configuration with clean keymap organization

Implemented full sidekick.nvim configuration with zellij backend, tool-specific overrides, and extracted all keymaps to dedicated customizations file following project conventions. Part of the broader OpenCode Ctrl+P fix initiative.

**Configuration Components:**

1. **Multiplexer Backend** (zellij):
   - Preferred over tmux to avoid colorscheme rendering issues
   - Enabled with `mux.backend = "zellij"`
   - Full multiplexer session support
   - **Windows Compatibility**: Disabled on Windows native (`enabled = vim.fn.has("win32") == 0`)
   - Zellij has no Windows native build, only Linux/macOS binaries
   - WSL users still get full zellij support

2. **Terminal Window Layout**:
   - Position: Right side of screen (`layout = "right"`)
   - Width: 45% of screen (`split.width = 0.45`)
   - Height: Full height auto-calculated (`split.height = 0`)
   - Matches OpenCode terminal dimensions for consistency

3. **Tool-Specific Overrides**:
   - **OpenCode**: Alt+P for sidekick prompt (frees Ctrl+P for OpenCode's command list)
   - **Copilot**: Ctrl+S for submit/send (custom keybinding for terminal interaction)

4. **Keymap Organization**:
   - Extracted all 10 keybindings to `customizations/keymaps/sidekick.lua`
   - Converted from lazy.nvim `keys` table to `nairovim.KeymapDef[]` format
   - Loaded via `common.map()` utility in plugin `config` function
   - Maintains consistency with other plugin keymaps (telescope, opencode, lazygit, etc.)

**Keybindings Included:**

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<tab>` | n | `nes_jump_or_apply()` | Next Edit Suggestion jump/apply |
| `<c-.>` | n,t,i,x | `toggle()` | Toggle sidekick CLI |
| `<leader>aa` | n | `toggle()` | Toggle sidekick CLI (mnemonic) |
| `<leader>as` | n | `select()` | Select CLI tool |
| `<leader>ad` | n | `close()` | Detach/close session |
| `<leader>at` | n,x | `send({ msg = "{this}" })` | Send current context |
| `<leader>af` | n | `send({ msg = "{file}" })` | Send entire file |
| `<leader>av` | x | `send({ msg = "{selection}" })` | Send visual selection |
| `<leader>ap` | n,x | `prompt()` | Select prompt |
| `<leader>ac` | n | `toggle({ name = "claude" })` | Toggle Claude directly |

**Implementation Pattern:**

```lua
-- Plugin file: nvim/lua/nairovim/plugins/ai/sidekick.lua
config = function(_, opts)
    require("sidekick").setup(opts)
    
    -- Load keymaps from customizations
    local mappings = require("nairovim.plugins.customizations.keymaps.sidekick").mappings
    local common_utils = require("nairovim.utils.common")
    common_utils.map(mappings)
end
```

**Files Structure:**

```
nvim/lua/nairovim/plugins/
├── ai/
│   └── sidekick.lua              # Plugin configuration + tool overrides
└── customizations/
    └── keymaps/
        └── sidekick.lua          # All keybindings (nairovim.KeymapDef[])
```

**Impact:** Clean separation of concerns, follows project conventions, maintainable keymap organization  
**Branch:** `feat/sidekick-ctrl-p-fix`  
**Files:** 2 new files (sidekick.lua, keymaps/sidekick.lua)  
**Line changes:** +152 lines total  
**Commits:** 4 commits (plugin config, lazy-lock update, Windows compatibility fix, install script fix)

---

## 2026-02-28: Sidekick OpenCode Ctrl+P Fix
**Goal:** Enable OpenCode's native Ctrl+P command list functionality when running in sidekick terminal

Applied official fix from upstream PR #176 to resolve keybinding conflict where sidekick's prompt picker was intercepting Ctrl+P before it could reach OpenCode's TUI. OpenCode v1.0.15+ uses Ctrl+P for its built-in command list menu.

**Root Cause:**

Sidekick's default terminal keybindings included `prompt = { "<c-p>", "prompt", mode = "t" }` which intercepted Ctrl+P in ALL terminal sessions. When OpenCode runs inside a sidekick terminal, this prevented OpenCode's native Ctrl+P functionality from working.

**Why Setting `prompt = false` Didn't Work:**

Initial attempts to set `opts.cli.win.keys.prompt = false` in user config were insufficient because:
1. Sidekick's tool-specific defaults have higher precedence in the merge order
2. The keybinding wasn't being created, but no alternative was configured
3. Result: Ctrl+P did nothing (neither sidekick nor OpenCode handled it)

**Solution Applied (PR #176):**

Modified user config to override Ctrl+P for OpenCode tool specifically using tool-specific configuration:

```lua
-- File: nvim/lua/nairovim/plugins/ai/sidekick.lua
tools = {
    opencode = {
        -- OpenCode uses <c-p> for its own command list functionality
        -- Override sidekick's default to use Alt+P instead
        keys = { prompt = { "<a-p>", "prompt" } },
    },
}
```

This follows the same pattern as the `crush` tool (which also needs Ctrl+P for native functionality).

**Changes Made:**

1. **Sidekick Config** (`nvim/lua/nairovim/plugins/ai/sidekick.lua` lines 18-22):
   - Added tool-specific OpenCode override: `keys = { prompt = { "<a-p>", "prompt" } }`
   - Frees Ctrl+P for OpenCode, moves sidekick prompt picker to Alt+P

2. **Zellij Config** (`~/.config/zellij/config.kdl`):
   - Commented out line 21: `bind "Ctrl p" { SwitchToMode "normal"; }` in pane mode
   - Commented out line 175: `bind "Ctrl p" { SwitchToMode "pane"; }` in shared bindings
   - Reason: Zellij was intercepting Ctrl+P before it could reach OpenCode terminal
   - User doesn't actively use Zellij pane mode, so removing this binding has no impact
   - Backup created at `~/.config/zellij/config.kdl.backup`

**Result:**

- ✅ Ctrl+P in OpenCode terminal → Opens OpenCode command list
- ✅ Alt+P in OpenCode terminal → Opens sidekick prompt/context picker
- ✅ Ctrl+P in other AI tools (Claude, Copilot) → Opens sidekick prompt picker (default behavior)
- ✅ Works with Zellij backend (no tmux colorscheme issues)
- ✅ Configuration will align with upstream when PR #176 merges

**Testing:**

```bash
# 1. Open OpenCode via sidekick
:lua require("sidekick.cli").toggle("opencode")

# 2. In terminal mode, press Ctrl+P
# Expected: OpenCode command list appears ✅

# 3. In terminal mode, press Alt+P
# Expected: Sidekick prompt picker appears ✅

# 4. Verify keybinding
:verbose map <c-p>
# In terminal mode: No sidekick mapping (passes through to OpenCode)
```

**Impact:** OpenCode's native Ctrl+P command list now works correctly in sidekick terminals  
**Reference:** [GitHub Issue #175](https://github.com/folke/sidekick.nvim/issues/175) | [PR #176](https://github.com/folke/sidekick.nvim/pull/176)  
**Files:** 2 files modified (sidekick.lua, zellij config.kdl)  
**Line changes:** +5 lines (sidekick.lua), 2 lines commented (zellij config.kdl)

---

## 2026-02-12: FZF Ctrl+R Command History Fix (WSL)
**Goal:** Fix `Ctrl+R` command history search not working in WSL with Vi mode enabled

Diagnosed and fixed FZF key binding issue in WSL where `Ctrl+R` command history search wasn't working due to plugin ordering bug and Vi mode overriding default keybindings. Works perfectly on macOS but failed silently in WSL.

**Root Cause:**

1. **Plugin Ordering Bug**:
   - Line 81: `plugins=(git)` - FZF plugin NOT included before Oh-My-Zsh loads
   - Line 83: `source $ZSH/oh-my-zsh.sh` - Oh-My-Zsh loads without FZF
   - Lines 121-123: `plugins=(fzf)` - Second plugins array defined AFTER Oh-My-Zsh loaded (has no effect)

2. **Version-Incompatible Manual Config**:
   - Lines 128-135: Manual FZF sourcing logic that fails silently on WSL
   - Checks for `~/.fzf.zsh` (doesn't exist in WSL) ❌
   - Tries `fzf --zsh` (requires v0.48.0+, WSL has v0.44.1 Debian package) ❌
   - Result: No key bindings loaded at all

3. **Vi Mode Override**:
   - `set -o vi` enables Vi mode which uses different keymap (viins/vicmd vs emacs)
   - FZF key-bindings must be sourced AFTER Vi mode is set
   - Explicit `bindkey -M viins` needed to ensure Ctrl+R works in Vi insert mode

**Why macOS Works But WSL Doesn't:**
- **macOS**: Has `~/.fzf.zsh` from Homebrew installation OR newer FZF version
- **WSL**: No `~/.fzf.zsh`, FZF 0.44.1 (Debian), `fzf --zsh` not supported

**Solution:**

1. **Fixed Plugin Loading** (Line 81):
   ```zsh
   # Before: plugins=(git)
   # After:  plugins=(git fzf)
   ```

2. **Commented Out Incorrect FZF_BASE** (Line 113):
   ```zsh
   # export FZF_BASE="$HOME/.fzf"  # Let Oh-My-Zsh auto-detect
   ```

3. **Removed Duplicate Plugins Array** (Lines 121-123):
   - Deleted second `plugins=(fzf)` that had no effect

4. **Replaced Manual Config with Explicit Binding** (Lines 125-132):
   ```zsh
   set -o vi
   
   if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
     source /usr/share/doc/fzf/examples/key-bindings.zsh
     # Explicitly bind after Vi mode
     bindkey -M viins '^R' fzf-history-widget
     bindkey -M vicmd '^R' fzf-history-widget
   fi
   ```

5. **Kept Custom FZF Options** (Lines 136-137):
   ```zsh
   export FZF_DEFAULT_OPS="--extended"
   export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
   ```

**FZF Installation Details (WSL):**
- Installed: `/usr/bin/fzf` (version 0.44.1 debian)
- Key bindings: `/usr/share/doc/fzf/examples/key-bindings.zsh`
- Completion: `/usr/share/doc/fzf/examples/completion.zsh`
- Oh-My-Zsh plugin: `~/.oh-my-zsh/plugins/fzf/fzf.plugin.zsh`

**Testing Instructions:**

1. Open new terminal or run: `exec zsh`
2. Run some commands to populate history: `ls`, `pwd`, `echo test`
3. Press `Ctrl+R` - should open FZF command history search
4. Type to filter history, press Enter to execute command
5. Also test: `Ctrl+T` (file search), `Alt+C` (directory navigation)

**Verification Commands:**
```bash
# Check if widget function is defined
typeset -f fzf-history-widget | head -3

# Check Vi insert mode binding
bindkey -M viins | grep "^\^R"

# Should show: "^R" fzf-history-widget
```

**Impact:** FZF command history search now works consistently across macOS and WSL with Vi mode enabled  
**Files:** `~/.zshrc` (modified, backup created)  
**Line changes:** +9 lines added/modified, ~10 lines removed

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
