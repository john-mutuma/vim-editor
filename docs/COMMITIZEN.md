# Commitizen Setup Guide

## Overview

This repository uses **Commitizen** to enforce [Conventional Commits](https://www.conventionalcommits.org/) format automatically.

## Installation

Commitizen is already installed in this repository. Dependencies are managed via npm:

```bash
npm install
```

## Usage

### Interactive Commit (Recommended)

Instead of `git commit`, use:

```bash
npm run commit
# or
npx cz
```

This launches an interactive prompt that guides you through creating a properly formatted commit:

1. **Select type**: feat, fix, docs, style, refactor, perf, test, chore
2. **Enter scope** (optional): Component/area affected (e.g., plugins, opencode, lsp)
3. **Write subject**: Short description (imperative mood, lowercase)
4. **Write body** (optional): Detailed explanation with bullet points
5. **Write footer** (optional): Breaking changes, issue references

### Manual Commit (Advanced)

You can still use `git commit` directly, but commit messages **must** follow conventional format:

```bash
git commit -m "feat(lsp): add rust-analyzer configuration"
```

**The commit-msg hook will validate and reject non-conforming messages.**

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style (formatting, no logic change)
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

**Simple commit:**
```bash
npm run commit
# Select: feat
# Scope: plugins
# Subject: add telescope-fzf-native for faster fuzzy finding
```

**Detailed commit:**
```bash
npm run commit
# Select: fix
# Scope: lsp
# Subject: resolve hover documentation not showing
# Body: 
# - Increase hover timeout from 100ms to 500ms
# - Add fallback to show signature help if hover fails
# - Update lspconfig with latest version
# Footer: Fixes #42
```

## Validation

Commit messages are validated automatically via:

1. **commitlint**: Checks message format against rules
2. **husky**: Runs commitlint on `commit-msg` Git hook
3. **Git hook**: Rejects commits that don't match format

### Validation Rules

- Type must be one of: feat, fix, docs, style, refactor, perf, test, chore
- Scope must be kebab-case (e.g., `nvim-tree`, not `nvimTree`)
- Subject must be sentence-case
- Subject cannot end with period
- Header max length: 100 characters

## Bypassing Validation (Not Recommended)

In rare cases where you need to bypass validation:

```bash
git commit --no-verify -m "emergency fix"
```

**Only use this for urgent hotfixes. All commits should follow conventional format.**

## Configuration Files

- **package.json**: Defines commitizen and commitlint dependencies
- **.commitlintrc.json**: Configures validation rules
- **.husky/commit-msg**: Git hook that runs commitlint

## Troubleshooting

### Hook not running

```bash
# Reinstall husky hooks
npx husky install
chmod +x .husky/commit-msg
```

### Commitizen prompt not showing

```bash
# Verify installation
npm list commitizen
npx cz --version

# Reinstall if needed
npm install
```

### Validation failing incorrectly

Check your message against rules:

```bash
# Test a commit message
echo "feat(test): add new feature" | npx commitlint
```

## Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Commitizen Documentation](https://github.com/commitizen/cz-cli)
- [Commitlint Documentation](https://commitlint.js.org/)
- [Repository Contributing Guide](CONTRIBUTING.md)
