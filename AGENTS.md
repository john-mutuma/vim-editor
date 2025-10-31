# Project History

Brief, concise history of AI-assisted development tasks.

---

## 2025-10-31: Documentation Restructuring & Organization

**Commits:** `94b7db4`, `e33cabf` | `continous-development` branch

Major documentation overhaul to improve user experience and maintainability.

### Problem
- README had become extremely technical and lengthy (~1500 lines)
- Mixed user-facing content with deep technical details
- Difficult for new users to quickly understand and get started
- Troubleshooting and FAQ content scattered throughout
- Not professional or user-friendly

### Solution
Restructured documentation into specialized files with clear separation of concerns:

**README.md** (~400 lines) - User-facing:
- Quick installation guide
- Essential features overview
- Basic setup and workflows
- Most common keybindings (20-30)
- OpenCode AI setup (primary recommendation)
- Links to detailed docs

**ARCHITECTURE.md** (~600 lines) - Technical reference:
- Complete directory structure
- Design principles & configuration flow
- Performance benchmarks & optimization
- Full plugin ecosystem (70+ plugins, 11 categories)
- Complete keybinding reference (70+ mappings)
- AI tools comparison & setup details
- Security considerations
- Extension guides for developers

**TROUBLESHOOTING.md** (~550 lines) - Issue resolution:
- Installation problems & solutions
- Plugin loading issues
- LSP troubleshooting
- AI tools debugging
- Git integration fixes
- UI/performance/terminal problems
- Emergency recovery procedures

**FAQ.md** (~300 lines) - Common questions:
- Installation & setup (6 Q&As)
- Configuration & customization (6 Q&As)
- Plugins & features (5 Q&As)
- AI tools (6 Q&As)
- Performance (3 Q&As)
- Keybindings (5 Q&As)
- Troubleshooting references
- General questions (10 Q&As)

**CONTRIBUTING.md** (updated references):
- Updated FAQ references
- Added links to all new documentation
- Maintained contribution guidelines

### Changes Made
- ✅ Created streamlined README.md (user-focused)
- ✅ Created doc/ARCHITECTURE.md (technical deep-dive)
- ✅ Created doc/TROUBLESHOOTING.md (problem-solving)
- ✅ Created doc/FAQ.md (common questions)
- ✅ Created doc/CONTRIBUTING.md (contribution guidelines)
- ✅ Moved all documentation files to doc/ directory
- ✅ Updated all cross-references to doc/ paths
- ✅ Positioned OpenCode as primary AI recommendation

### Key Design Decisions
1. **User-first README**: Fast installation, immediate productivity
2. **Separate technical details**: Developers can dive deep without overwhelming new users
3. **Searchable troubleshooting**: Organized by category for quick reference
4. **FAQ for common questions**: Reduces repeated issues and questions
5. **Organized doc/ directory**: All documentation files in one location
6. **Cross-referenced navigation**: Easy to find related information
7. **OpenCode priority**: Clear primary recommendation over alternatives

### Files Modified/Created
- `README.md` (complete rewrite, ~400 lines, updated doc/ references)
- `doc/ARCHITECTURE.md` (new, 664 lines)
- `doc/TROUBLESHOOTING.md` (new, 922 lines)
- `doc/FAQ.md` (new, 479 lines)
- `doc/CONTRIBUTING.md` (new, 670 lines)
- `AGENTS.md` (updated with this entry)

### Impact
- **Better user experience**: New users can get started in minutes
- **Professional documentation**: Clean, organized, scannable
- **Easier maintenance**: Changes go in the right place
- **Better discoverability**: Cross-references help users find answers
- **Reduced support burden**: Comprehensive FAQ and troubleshooting

---

## 2025-11-01: README Documentation Enhancement

**Commit f8a118b** | `continous-development` branch

- Added comprehensive keybinding reference section with 70+ mappings organized into 8 categories
- Added plugin ecosystem section documenting all 70+ plugins across 11 functional categories
- Removed duplicate "Essential Shortcuts" section (51 lines of duplication)
- Removed nvim-ide references from keybinding tables (plugin no longer in config)
- Organized AI tools (Avante, Copilot, OpenCode) with detailed usage examples
- Improved navigation with mode, description, and plugin attribution for all keybindings

**Categories Added:**
- File & Search Navigation (11 keybindings)
- LSP & Code Intelligence (16 keybindings)
- AI Assistant - OpenCode (14 keybindings)
- AI Assistant - Copilot (1 keybinding)
- Git Integration (16 keybindings)
- Search & Replace (2 keybindings)
- UI & Window Management (8 keybindings)
- Editing & Text Manipulation (6 core + plugin features)

**Plugin Categories Documented:**
AI (4), LSP (9), Debugging (3), Git (3), Search (5), UI (12), Editing (8), Markdown (2), Utilities (10+), Plugin Management (1)

**Files:** `README.md` (+235, -53 lines)

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
