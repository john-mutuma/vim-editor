# OpenCode Cache Management Guide

Quick reference for managing OpenCode cache in large repositories and monorepos.

## Cache Locations

| Directory | Purpose | Typical Size |
|-----------|---------|--------------|
| `~/.local/share/opencode/snapshot/` | Git repository snapshots | 1-3GB per repo |
| `~/.local/share/opencode/storage/` | Conversation history, session diffs | 500MB-2GB |
| `~/.local/share/opencode/opencode.db` | SQLite database (metadata) | 100-500MB |
| `~/.cache/opencode/` | Models cache, binaries | 100-200MB |
| `~/.config/opencode/` | Configuration files | < 10MB |

## Quick Commands

### Check Cache Size

```bash
# Total size
du -sh ~/.local/share/opencode/

# Breakdown by type
du -sh ~/.local/share/opencode/snapshot     # Repository snapshots
du -sh ~/.local/share/opencode/storage      # Conversation data
du -sh ~/.local/share/opencode/opencode.db* # Database
```

### Identify Repository Snapshots

```bash
# List all cached repositories
for dir in ~/.local/share/opencode/snapshot/*/; do
  if [ -f "$dir/config" ]; then
    echo "=== $(basename $dir) ==="
    du -sh "$dir"
    grep worktree "$dir/config" | awk '{print "  Repository: " $3}'
    echo ""
  fi
done
```

### Clear Specific Repository Cache

```bash
# 1. Stop OpenCode in Neovim first
:lua require("opencode").stop()

# 2. Find your repository's hash
ls -lah ~/.local/share/opencode/snapshot/
cat ~/.local/share/opencode/snapshot/HASH/config  # Check worktree path

# 3. Remove the snapshot
rm -rf ~/.local/share/opencode/snapshot/HASH
```

### Clear All Cache (Nuclear Option)

```bash
# CAUTION: Loses all conversation history

# Stop OpenCode first
:lua require("opencode").stop()

# Clear everything
rm -rf ~/.local/share/opencode/snapshot/*
rm -rf ~/.local/share/opencode/storage/*
rm ~/.local/share/opencode/opencode.db*
```

### Clear Large Session Diffs Only

```bash
# Remove session diffs over 100MB (preserves smaller conversations)
find ~/.local/share/opencode/storage/session_diff/ -type f -size +100M -delete

# Remove session diffs over 50MB
find ~/.local/share/opencode/storage/session_diff/ -type f -size +50M -delete
```

## Prevention: `.opencodeignore`

Create this file in your repository root to prevent indexing large/unnecessary files:

### Minimal Template

```gitignore
# Documentation
**/docs/**
**/documentation/**

# Dependencies
**/node_modules/**
**/dist/**
**/build/**

# Generated files
**/*.generated.*
**/generated/**
```

### Comprehensive Template

See `.opencodeignore.template` in the vim-editor repository for a full template covering:
- Documentation directories
- Build outputs
- Generated files
- Large assets
- Test fixtures
- Lock files

## Automated Maintenance Script

Create `~/bin/opencode-cleanup.sh`:

```bash
#!/bin/bash
# OpenCode Cache Cleanup Script

echo "OpenCode Cache Cleanup"
echo "====================="
echo ""

# Show current sizes
echo "Current cache sizes:"
du -sh ~/.local/share/opencode/snapshot 2>/dev/null
du -sh ~/.local/share/opencode/storage 2>/dev/null
du -sh ~/.local/share/opencode/opencode.db* 2>/dev/null
echo ""

# Ask what to clean
echo "What would you like to clean?"
echo "1) Clear all snapshots (preserves conversations)"
echo "2) Clear large session diffs (>100MB)"
echo "3) Clear everything (NUCLEAR - loses all history)"
echo "4) Show repository snapshots"
echo "5) Cancel"
echo ""
read -p "Choose option (1-5): " choice

case $choice in
  1)
    echo "Clearing all snapshots..."
    rm -rf ~/.local/share/opencode/snapshot/*
    echo "✓ Snapshots cleared"
    ;;
  2)
    echo "Clearing large session diffs (>100MB)..."
    find ~/.local/share/opencode/storage/session_diff/ -type f -size +100M -delete
    echo "✓ Large session diffs cleared"
    ;;
  3)
    read -p "Are you sure? This will delete ALL cache including conversations (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
      rm -rf ~/.local/share/opencode/snapshot/*
      rm -rf ~/.local/share/opencode/storage/*
      rm ~/.local/share/opencode/opencode.db*
      echo "✓ All cache cleared"
    else
      echo "Cancelled"
    fi
    ;;
  4)
    echo "Repository snapshots:"
    echo ""
    for dir in ~/.local/share/opencode/snapshot/*/; do
      if [ -f "$dir/config" ]; then
        echo "=== $(basename $dir) ==="
        du -sh "$dir"
        grep worktree "$dir/config"
        echo ""
      fi
    done
    ;;
  5)
    echo "Cancelled"
    ;;
  *)
    echo "Invalid option"
    ;;
esac

# Show final sizes
echo ""
echo "Final cache sizes:"
du -sh ~/.local/share/opencode/ 2>/dev/null
```

Make it executable:
```bash
chmod +x ~/bin/opencode-cleanup.sh
```

Run monthly or when cache grows over 3GB.

## Performance Benchmarks

### Healthy State
- OpenCode startup: < 2 seconds
- First query response: < 5 seconds
- Cache size: < 500MB per repository
- Snapshot size: < 100MB per repository

### Problem Indicators
- OpenCode startup: > 10 seconds
- First query response: > 30 seconds
- Cache size: > 3GB total
- Individual snapshot: > 1GB
- Session diff files: > 100MB each

## Troubleshooting

### Cache not clearing
- Make sure OpenCode is stopped first: `:lua require("opencode").stop()`
- Check file permissions: `ls -la ~/.local/share/opencode/`
- Use `sudo` if permission denied (not recommended - check ownership instead)

### Performance still slow after clearing cache
1. Add `.opencodeignore` to repository root
2. Remove large directories from git sparse-checkout
3. Check if multiple repositories are cached (clear all snapshots)
4. Verify cache size is actually reduced: `du -sh ~/.local/share/opencode/`

### `.opencodeignore` not working
- File must be in repository root (same directory as `.git/`)
- File must be named exactly `.opencodeignore` (with leading dot)
- Patterns use gitignore syntax (glob patterns)
- Clear cache after creating `.opencodeignore` to force re-index

## Related Documentation

- [Main Troubleshooting Guide](./TROUBLESHOOTING.md#opencode-slow-in-large-repositoriesmonorepos)
- [OpenCode Documentation](https://opencode.ai/docs)
- [`.opencodeignore` Template](../.opencodeignore.template)

## When to Clean Cache

### Monthly Maintenance
- Check cache size: `du -sh ~/.local/share/opencode/`
- If > 3GB, run cleanup script

### After Major Changes
- Adding large directories to sparse-checkout
- Switching between multiple large repositories
- After working on documentation-heavy projects

### Performance Degradation
- OpenCode becomes noticeably slower
- Disk space running low
- System feels sluggish when OpenCode is active

## Best Practices

1. **Use `.opencodeignore` proactively** - Add it before working in large repos
2. **Monitor cache size** - Check monthly or when performance degrades
3. **Be selective with sparse-checkout** - Don't add massive doc directories
4. **Clear old snapshots** - Remove repositories you're no longer working on
5. **Periodic maintenance** - Run cleanup script every 1-2 months
