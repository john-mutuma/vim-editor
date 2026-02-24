# Contributing to NairoVIM

Thank you for considering contributing to NairoVIM! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Plugin Guidelines](#plugin-guidelines)
- [Testing](#testing)
- [Questions?](#questions)
- [Recognition](#recognition)

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, trolling, or discriminatory language
- Personal attacks or political arguments
- Publishing others' private information
- Any conduct inappropriate in a professional setting

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- Neovim 0.9.0 or higher
- Git installed and configured
- Basic knowledge of Lua programming
- Familiarity with Neovim configuration
- Understanding of the plugin system (lazy.nvim)

### Areas for Contribution

We welcome contributions in these areas:

- **Bug Fixes**: Resolve issues and improve stability
- **New Features**: Add useful functionality
- **Documentation**: Improve README, add tutorials, fix typos
- **Plugin Integrations**: Add new plugin configurations
- **Performance**: Optimize startup time and runtime performance
- **Testing**: Write tests and improve test coverage
- **Themes**: Contribute color schemes and UI improvements

## Development Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/your-username/nairovim.git
cd nairovim
```

### 2. Create a Branch

```bash
# Create a feature branch
git checkout -b feature/your-feature-name

# Or a bugfix branch
git checkout -b fix/issue-description
```

### 3. Make Your Changes

```bash
# Make changes to the codebase
# Test your changes thoroughly
nvim  # Test in Neovim
```

### 4. Test Your Changes

```bash
# Run checkhealth
:checkhealth

# Test plugin loading
:Lazy

# Check for errors
:messages

# Profile performance if relevant
:Lazy profile
```

## How to Contribute

### Reporting Bugs

When reporting bugs, include:

- **Description**: Clear description of the issue
- **Steps to Reproduce**: Detailed steps to reproduce the bug
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Environment**:
  - Neovim version (`:version`)
  - OS and version
  - Terminal emulator
  - Output of `:checkhealth`
- **Screenshots**: If applicable
- **Error Messages**: Full error messages from `:messages`

**Bug Report Template:**

```markdown
## Bug Description
[Clear description]

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Neovim version:
- OS:
- Terminal:
- Shell:

## Additional Context
[Screenshots, error messages, etc.]
```

### Suggesting Enhancements

When suggesting features, include:

- **Use Case**: Why is this feature needed?
- **Proposed Solution**: How should it work?
- **Alternatives**: Other ways to achieve the goal
- **Examples**: Examples from other projects
- **Impact**: Who benefits from this feature?

### Asking Questions

- Check [FAQ](README.md#-faq) first
- Search existing issues
- Use GitHub Discussions for questions
- Be specific and provide context

## Coding Standards

### Lua Style Guide

**File Structure:**

```lua
-- Plugin configuration file structure
-- File: lua/nairovim/plugins/example.lua

return {
  "author/plugin-name",
  -- Lazy loading configuration
  event = "VeryLazy",  -- or cmd, ft, keys

  -- Dependencies
  dependencies = {
    "required/plugin",
  },

  -- Configuration
  config = function()
    require("plugin-name").setup({
      -- Plugin options
      option = value,
    })
  end,
}
```

**Naming Conventions:**

- **Files**: Use kebab-case: `my-plugin.lua`
- **Variables**: Use snake_case: `my_variable`
- **Functions**: Use snake_case: `my_function()`
- **Constants**: Use UPPER_SNAKE_CASE: `MY_CONSTANT`

**Code Style:**

```lua
-- Good: Descriptive variable names
local user_config = require("nairovim.config")
local is_enabled = true

-- Bad: Unclear abbreviations
local uc = require("nairovim.config")
local ie = true

-- Good: Clear function documentation
--- Sets up the plugin with given options
--- @param opts table Configuration options
--- @return boolean Success status
local function setup_plugin(opts)
  -- Implementation
end

-- Good: Proper spacing and indentation
local config = {
  enabled = true,
  option1 = "value1",
  nested = {
    option2 = "value2",
  },
}

-- Good: Use local variables
local M = {}

function M.my_function()
  -- Implementation
end

return M
```

**Comments:**

```lua
-- Single line comment for brief explanations

--- Documentation comment for functions
--- Uses LuaLS annotation format
--- @param arg1 string Description of arg1
--- @return table Description of return value

--[[ Multi-line comment
     for longer explanations
     or temporary code disabling ]]
```

### Plugin Configuration Guidelines

**1. Lazy Loading:**

Always configure lazy loading to maintain performance:

```lua
return {
  "plugin/name",
  -- Load on specific events
  event = "BufReadPre",  -- Before reading buffer
  -- Or load on commands
  cmd = { "PluginCommand1", "PluginCommand2" },
  -- Or load for filetypes
  ft = { "javascript", "typescript" },
  -- Or load on keybindings
  keys = {
    { "<leader>x", "<cmd>Command<cr>", desc = "Description" },
  },
}
```

**2. Dependencies:**

Declare dependencies explicitly:

```lua
return {
  "main/plugin",
  dependencies = {
    "required/dependency1",
    {
      "required/dependency2",
      config = function()
        -- Dependency config
      end,
    },
  },
}
```

**3. Keybindings:**

Place plugin keybindings in `customizations/keymaps/`:

```lua
-- File: lua/nairovim/plugins/customizations/keymaps/plugin-name.lua
local keymap = require("nairovim.utils.common").keymap

return function()
  keymap("n", "<leader>x", "<cmd>Command<cr>", {
    desc = "Clear description of what this does",
  })
end
```

**4. Customizations:**

Place highlights in `customizations/highlights/`:

```lua
-- File: lua/nairovim/plugins/customizations/highlights/plugin-name.lua
local highlight = require("nairovim.utils.common").highlight

return function()
  highlight("HighlightGroup", {
    fg = "#color",
    bg = "#color",
  })
end
```

### Directory Structure

```
nvim/lua/nairovim/
├── core/                  # Core Neovim settings
│   ├── init.lua          # Initialization
│   ├── options.lua       # Vim options
│   └── keymaps.lua       # Core keybindings
├── plugins/               # Plugin configurations
│   ├── ai/               # AI-related plugins
│   ├── dap/              # Debugging plugins
│   ├── lsp/              # LSP configurations
│   ├── mcp/              # MCP plugins
│   ├── customizations/   # Plugin customizations
│   │   ├── highlights/   # Highlight customizations
│   │   └── keymaps/      # Keymap customizations
│   └── *.lua            # Individual plugins
├── types/                 # Type definitions
├── utils/                 # Utility functions
└── lazy.lua              # Plugin manager setup
```

**Adding a New Plugin:**

1. Create file: `lua/nairovim/plugins/category/plugin-name.lua`
2. Add keybindings: `lua/nairovim/plugins/customizations/keymaps/plugin-name.lua`
3. Add highlights: `lua/nairovim/plugins/customizations/highlights/plugin-name.lua`
4. Update README: Add to Plugin Ecosystem section
5. Test thoroughly

## Commit Guidelines

### Automated Commits with Commitizen

This repository uses **Commitizen** for automated commit message formatting. See [COMMITIZEN.md](COMMITIZEN.md) for complete setup and usage guide.

**Quick Start:**
```bash
npm run commit  # Interactive commit prompt (recommended)
```

### Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**

```bash
feat(lsp): add rust-analyzer configuration

- Add rust-analyzer to Mason setup
- Configure inlay hints for Rust files
- Add Rust-specific keybindings

Closes #123

fix(telescope): resolve file picker crash on large repos

- Limit initial file count to 10000
- Add debounce to search input
- Improve error handling

Fixes #456

docs(readme): update installation instructions

- Add troubleshooting section
- Update plugin list
- Fix broken links

refactor(utils): extract common window utilities

- Create reusable backdrop function
- Simplify window management code
- Remove code duplication
```

### Commit Best Practices

- **Atomic Commits**: One logical change per commit
- **Descriptive Messages**: Explain why, not just what
- **Present Tense**: Use "add" not "added"
- **Imperative Mood**: "fix bug" not "fixes bug"
- **Reference Issues**: Use "Closes #123" or "Fixes #456"

## Pull Request Process

### Before Submitting

1. **Test thoroughly**:

   ```bash
   nvim  # Test in Neovim
   :checkhealth  # Check for issues
   :Lazy profile  # Check performance impact
   ```

2. **Update documentation**:
   - Update README if adding features
   - Update AGENTS.md with development history
   - Add inline code comments
   - Update plugin list if relevant

3. **Follow coding standards**:
   - Use consistent naming
   - Add proper lazy loading
   - Include type annotations
   - Add descriptive comments

4. **Clean commit history**:
   - Squash fixup commits
   - Write clear commit messages
   - Rebase on latest main/develop

### Submitting a Pull Request

1. **Push to your fork**:

   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request** on GitHub:
   - Use a clear, descriptive title
   - Fill out the PR template
   - Link related issues
   - Add screenshots if UI changes
   - Request review from maintainers

**PR Title Format:**

```
<type>: <clear description>

Examples:
feat: add support for Ruby LSP
fix: resolve telescope crash on startup
docs: improve keybinding documentation
```

**PR Description Template:**

```markdown
## Description
[Clear description of changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- [ ] Tested in Neovim
- [ ] Ran :checkhealth
- [ ] Checked performance impact
- [ ] Updated documentation

## Screenshots
[If applicable]

## Related Issues
Closes #123
Related to #456

## Additional Context
[Any other relevant information]
```

### Review Process

1. **Automated Checks**: CI runs automatically
2. **Code Review**: Maintainers review code
3. **Feedback**: Address review comments
4. **Approval**: After approval, PR is merged
5. **Cleanup**: Delete feature branch after merge

### After Merge

- Your changes are included in the next release
- You'll be added to contributors list
- Thank you for contributing!

## Plugin Guidelines

### Evaluating New Plugins

Before adding a plugin, consider:

**Quality Criteria:**

- ✅ **Active Maintenance**: Recently updated, active maintainer
- ✅ **Documentation**: Well-documented with examples
- ✅ **Performance**: Minimal impact on startup time
- ✅ **Dependencies**: Minimal, well-maintained dependencies
- ✅ **Compatibility**: Works with Neovim 0.9+
- ✅ **Community**: Good user base, active issues/PRs

**Integration Criteria:**

- ✅ **Unique Value**: Adds functionality not already present
- ✅ **Lazy Loading**: Can be lazy-loaded appropriately
- ✅ **Configuration**: Reasonable default configuration
- ✅ **No Conflicts**: Doesn't conflict with existing plugins
- ✅ **Fits Architecture**: Aligns with NairoVIM structure

### Plugin Configuration Template

```lua
-- File: lua/nairovim/plugins/category/new-plugin.lua

return {
  "author/plugin-name",

  -- Lazy loading (choose appropriate trigger)
  event = "VeryLazy",
  -- cmd = "PluginCommand",
  -- ft = "filetype",
  -- keys = "<leader>x",

  -- Dependencies (if any)
  dependencies = {
    "required/plugin",
  },

  -- Build step (if needed)
  build = "make",
  -- build = "npm install",

  -- Configuration
  config = function()
    require("plugin-name").setup({
      -- Plugin options with comments
      option1 = value1,  -- Description
      option2 = value2,  -- Description

      -- Nested options
      nested = {
        option3 = value3,
      },
    })

    -- Load custom keymaps
    local keymaps = require("nairovim.plugins.customizations.keymaps.plugin-name")
    if keymaps then
      keymaps()
    end

    -- Load custom highlights
    local highlights = require("nairovim.plugins.customizations.highlights.plugin-name")
    if highlights then
      highlights()
    end
  end,
}
```

## Testing

### Manual Testing

1. **Fresh Install Test**:

   ```bash
   # Backup existing config
   mv ~/.config/nvim ~/.config/nvim.backup

   # Test fresh install
   ./install.sh

   # Test your changes
   nvim
   ```

2. **Plugin Loading**:

   ```bash
   # Check plugin status
   :Lazy

   # Check for errors
   :messages

   # Check health
   :checkhealth
   ```

3. **Performance Test**:

   ```bash
   # Measure startup time
   nvim --startuptime startup.log +qa
   tail -20 startup.log

   # Profile plugins
   :Lazy profile
   ```

4. **Feature Testing**:
   - Test new functionality thoroughly
   - Test edge cases
   - Test with different file types
   - Test keybindings
   - Test with different terminals

### Testing Checklist

- [ ] Fresh install works
- [ ] Plugins load correctly
- [ ] No error messages
- [ ] Keybindings work as expected
- [ ] LSP functionality intact
- [ ] Git integration works
- [ ] AI features work (if applicable)
- [ ] Performance is acceptable
- [ ] Documentation is updated
- [ ] No breaking changes (or documented)

## Questions?

- **Documentation**: Check [README](README.md) and [FAQ](README.md#-faq)
- **Issues**: Search existing [issues](https://github.com/yourusername/nairovim/issues)
- **Discussions**: Use [GitHub Discussions](https://github.com/yourusername/nairovim/discussions)
- **Contact**: Reach out to maintainers

## Recognition

Contributors are recognized in:

- GitHub contributors list
- Release notes
- Community shoutouts

Thank you for contributing to NairoVIM and making it better for everyone!
