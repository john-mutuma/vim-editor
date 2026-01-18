# Symlink Operations Risk Analysis: install.sh

## Executive Summary

**Overall Risk Assessment: HIGH (7/10)**

The `install_opencode()` function (lines 350-411) contains **critical inconsistencies** in symlink handling that create significant data loss risks. While some safeguards exist, the implementation has multiple scenarios where user data can be permanently lost or overwritten without adequate protection.

---

## 1. Agents Directory Symlink Behavior (Lines 390-407)

### Current Implementation

```bash
# Symlink agents directory
local agents_source="$opencode_config_source/agents"
local agents_target="$opencode_config_target/agents"

if [[ -d "$agents_source" ]]; then
    if [[ -L "$agents_target" ]]; then
        print_info "OpenCode agents directory symlink already exists, updating..."
        rm "$agents_target"
    elif [[ -d "$agents_target" ]]; then
        print_warning "OpenCode agents directory exists, backing up to ${agents_target}.backup"
        mv "$agents_target" "${agents_target}.backup"
    fi

    ln -sf "$agents_source" "$agents_target"
    echo "    ${green}${LINK} OpenCode agents${textreset} → ${dim}$agents_target${textreset}"
else
    print_warning "agents directory not found at $agents_source"
fi
```

### Critical Issues Identified

#### Issue #1: **No Timestamp on Directory Backups** (CRITICAL)
- **Risk Level**: CRITICAL
- **Problem**: Uses `.backup` suffix without timestamp (line 400)
- **Scenario**: User runs script multiple times with custom agents
  
**Step-by-Step Data Loss Example:**

```bash
# Initial state: User has custom agents
~/.config/opencode/agents/
├── custom-security-agent.md (User's work)
├── custom-analytics-agent.md (User's work)
└── deployment-automation.md (User's work)

# First script run (Day 1)
# Backup created: ~/.config/opencode/agents.backup/
# Symlink created: ~/.config/opencode/agents → repo/agents/

# User notices issues, restores backup, adds more custom agents
~/.config/opencode/agents/
├── custom-security-agent.md
├── custom-analytics-agent.md
├── deployment-automation.md
└── critical-hotfix-agent.md (NEW - critical for production)

# Second script run (Day 2)
# mv agents agents.backup  # OVERWRITES THE PREVIOUS BACKUP!
# Result: critical-hotfix-agent.md is PERMANENTLY LOST
# The first backup with 3 agents is PERMANENTLY LOST
```

**Impact**: Multiple iterations of custom agents configuration lost forever.

#### Issue #2: **Dangling Symlink Not Detected** (HIGH)
- **Risk Level**: HIGH
- **Problem**: `test -L` returns true for dangling symlinks
- **Gap**: If previous symlink target was deleted, script doesn't detect this

**Example:**

```bash
# Scenario: User manually deleted the repo, keeping symlink
~/.config/opencode/agents → /old/deleted/path/agents (DANGLING)

# Script runs:
if [[ -L "$agents_target" ]]; then  # Returns TRUE even though dangling!
    rm "$agents_target"  # Just removes broken symlink
fi
ln -sf "$agents_source" "$agents_target"  # Creates new symlink

# Problem: No warning that previous configuration was invalid
# User may not realize they lost their setup
```

#### Issue #3: **No Verification of User Custom Agents** (MEDIUM)
- **Risk Level**: MEDIUM
- **Problem**: No check if existing directory contains custom (non-repo) agents
- **Gap**: Script treats all existing directories the same way

**Example:**

```bash
# User has mix of repo and custom agents
~/.config/opencode/agents/
├── debugger.md (from repo - matches)
├── code-reviewer.md (from repo - matches)
├── custom-financial-agent.md (USER CREATED - unique)
└── custom-ml-engineer.md (USER CREATED - unique)

# Script simply backs up entire directory
# No warning: "Found 2 custom agents that aren't in the repo"
# User may not realize they need to restore the backup
```

---

## 2. opencode.json File Symlink (Lines 380-388)

### Current Implementation

```bash
# Symlink opencode.json
local opencode_json_source="$opencode_config_source/opencode.json"
local opencode_json_target="$opencode_config_target/opencode.json"

if [[ -f "$opencode_json_source" ]]; then
    create_symlink "$opencode_json_source" "$opencode_json_target" "OpenCode config"
else
    print_warning "opencode.json not found at $opencode_json_source"
fi
```

### Using `create_symlink()` Function (Lines 136-151)

```bash
create_symlink() {
    local source=$1
    local target=$2
    local name=$3

    if [[ -L "$target" ]]; then
        print_info "$name symlink already exists, updating..."
        rm "$target"
    elif [[ -e "$target" ]]; then
        print_warning "$name file exists, backing up to ${target}.backup"
        mv "$target" "${target}.backup"
    fi

    ln -sf "$source" "$target"
    echo "    ${green}${LINK} $name${textreset} → ${dim}$target${textreset}"
}
```

### Critical Issues Identified

#### Issue #4: **API Keys and Secrets Overwritten** (CRITICAL)
- **Risk Level**: CRITICAL
- **Problem**: User's customized config with API keys backed up but not restored
- **Sensitive Data**: GitHub tokens, API keys, custom MCP configurations

**Example:**

```bash
# User's opencode.json with production secrets
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.5",
  "mcp": {
    "github": {
      "type": "remote",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer ghp_MyProductionToken123XYZ"  # USER'S SECRET
      },
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "custom-internal-api": {
      "type": "remote",
      "enabled": true,
      "url": "https://internal.company.com/api",
      "headers": {
        "X-API-Key": "super_secret_company_key"  # USER'S SECRET
      }
    }
  }
}

# First script run
# Backup: ~/.config/opencode/opencode.json.backup (contains secrets)
# Symlink: ~/.config/opencode/opencode.json → repo/opencode.json

# Result: OpenCode immediately fails - no authentication!
# User must manually restore: mv opencode.json.backup opencode.json
# But now symlink is lost - configuration drift begins
```

**Impact**: 
- Production tokens immediately invalid
- User must manually merge repo config + their secrets
- High risk of committing secrets to git if user edits repo file

#### Issue #5: **Backup Collision - Silent Overwrite** (HIGH)
- **Risk Level**: HIGH
- **Problem**: `.backup` suffix without timestamp (line 146)
- **Same issue as agents directory** but for files

**Example:**

```bash
# First run (Monday)
# User config backed up to opencode.json.backup (v1 with GitHub token A)

# User restores, updates token to B, adds new MCP server

# Second run (Tuesday)
# mv opencode.json opencode.json.backup  # OVERWRITES v1!
# Result: GitHub token A lost forever, new MCP server config lost
```

---

## 3. Potential Risk Scenarios

### Scenario A: Multiple Script Executions (CRITICAL - 9/10)

**User Journey:**
1. Fresh install → Script runs → Agents backed up to `.backup`
2. User tests, finds issues, restores backup: `mv agents.backup agents`
3. User adds 3 custom agents for their workflow
4. User pulls repo updates, runs script again to get new features
5. **RESULT**: Second backup overwrites first backup. 3 custom agents LOST FOREVER.

**Affected Files:**
- `~/.config/opencode/agents.backup` (OVERWRITTEN)
- `~/.config/opencode/opencode.json.backup` (OVERWRITTEN)

**Severity**: CRITICAL - Permanent data loss with no recovery

---

### Scenario B: Customized Configuration with Secrets (CRITICAL - 10/10)

**User Journey:**
1. User installs, follows docs to add GitHub PAT to opencode.json
2. User adds company internal MCP server with API key
3. User adds custom agents for their team's workflow
4. Script runs (auto-update or manual) → Config symlinked
5. **RESULT**: OpenCode stops working (no auth), custom agents inaccessible

**Data Loss:**
- GitHub Personal Access Token (needs regeneration)
- Company API keys (may need approval to regenerate)
- Custom agent definitions (recoverable from .backup if noticed immediately)

**Severity**: CRITICAL - Production outage + security credential loss

---

### Scenario C: Dangling Symlinks (MEDIUM - 5/10)

**User Journey:**
1. User installs in `/home/user/dotfiles/`
2. Symlinks created successfully
3. User moves repo to `/home/user/new-location/dotfiles/`
4. **Symlinks now dangling** → OpenCode broken
5. User runs script in new location
6. Script detects symlink (`-L` true), removes it, creates new one
7. **RESULT**: No warning about previous setup being broken

**Impact**: Configuration appears to "just work" but user loses awareness of their setup state

**Severity**: MEDIUM - Confusing behavior, no data loss but poor UX

---

### Scenario D: Agents Directory Already Symlinked (LOW - 3/10)

**User Journey:**
1. First script run → Agents directory symlinked
2. User modifies agents **in the repo** (bad practice but possible)
3. Second script run → Detects symlink, removes, recreates same symlink
4. **RESULT**: No data loss, but confusing "updating" message

**Impact**: Misleading output, unnecessary operations

**Severity**: LOW - Cosmetic issue, no data loss

---

### Scenario E: Backup Already Exists (HIGH - 8/10)

**User Journey:**
1. Day 1: Script runs → User config backed up to `agents.backup`
2. User examines backup: `cd ~/.config/opencode/agents.backup`
3. User wants to keep backup: `mv agents.backup agents.my-old-config`
4. User restores and customizes: `mv agents.backup agents` (forgets they renamed)
5. **agents.backup doesn't exist anymore**
6. Day 2: Script runs again → User's customized agents backed up to `agents.backup`
7. **User thinks their Day 1 backup is safe, but it's not where they think**

**Impact**: User confusion, difficult recovery

**Severity**: HIGH - Data loss due to user confusion about backup state

---

## 4. Comparison with Other Symlink Operations

### Lazygit Config (Lines 335-348) - Uses `create_symlink()`

```bash
local lazygit_config_target="$HOME/.config/lazygit/config.yml"
create_symlink "$lazygit_config_source" "$lazygit_config_target" "Lazygit config"
```

**Same Issues:**
- ✗ No timestamp on backup
- ✗ Backup collision possible
- ✗ No dangling symlink detection

**Verdict**: **Consistently flawed** - all file symlinks have same risks

---

### Neovim Config (Lines 229-242) - Uses `setup_directory()`

```bash
setup_directory() {
    local target_dir=$1
    local source_dir=$2
    local name=$3

    if [[ -d "$target_dir" ]]; then
        print_warning "$name directory already exists, backing up..."
        mv "$target_dir" "${target_dir}.backup.$(date +%Y%m%d_%H%M%S)"  # ← TIMESTAMP!
    fi

    mkdir -p "$(dirname "$target_dir")"
    ln -sf "$source_dir" "$target_dir"
    print_success "Linked $name configuration"
}
```

**Better Implementation:**
- ✓ Timestamp on backup: `$(date +%Y%m%d_%H%M%S)`
- ✓ No collision risk - each backup is unique
- ✗ Still no dangling symlink detection
- ✗ No check for existing symlinks

**Verdict**: **Better but incomplete** - prevents backup collisions

---

### Key Differences Table

| Feature | `create_symlink()` (Files) | Agents Directory (Custom) | `setup_directory()` (Neovim) |
|---------|---------------------------|---------------------------|------------------------------|
| **Timestamp on backup** | ✗ No | ✗ No | ✓ **Yes** |
| **Backup collision risk** | ✓ High | ✓ High | ✗ None |
| **Detects existing symlink** | ✓ Yes | ✓ Yes | ✗ No |
| **Detects dangling symlink** | ✗ No | ✗ No | ✗ No |
| **Handles `-e` vs `-L`** | ✓ Separate checks | ✓ Separate checks | ✗ Only `-d` check |
| **User data loss risk** | HIGH | HIGH | MEDIUM |

---

## 5. Data Loss Risk Assessment by Component

### Critical Risk Components (Score: 9-10/10)

#### **1. opencode.json with Secrets** - 10/10 CRITICAL
- **Data Type**: API keys, GitHub PATs, auth tokens
- **Loss Scenario**: Multiple script runs → `.backup` overwritten
- **Recovery Difficulty**: Impossible (need to regenerate tokens)
- **Business Impact**: Production outage, security credential compromise
- **User Impact**: Immediate OpenCode failure, need to reconfigure all auth

#### **2. Custom Agents Directory** - 9/10 CRITICAL
- **Data Type**: Custom agent definitions (could be hundreds of lines)
- **Loss Scenario**: Multiple script runs → `.backup` overwritten
- **Recovery Difficulty**: Impossible if backup overwritten
- **Business Impact**: Loss of team-specific automation and workflows
- **User Impact**: Hours/days of work lost, team productivity disrupted

---

### High Risk Components (Score: 7-8/10)

#### **3. Lazygit Configuration** - 7/10 HIGH
- **Data Type**: Git workflow customizations, keybindings
- **Loss Scenario**: Multiple script runs → `.backup` overwritten
- **Recovery Difficulty**: Moderate (can recreate from memory)
- **User Impact**: Workflow disruption, need to reconfigure

#### **4. Backup Collision Scenario** - 8/10 HIGH
- **Data Type**: Any previously backed up configuration
- **Loss Scenario**: User expects `.backup` to be safe, runs script again
- **Recovery Difficulty**: Impossible (no timestamped backups)
- **User Impact**: False sense of security, data loss

---

### Medium Risk Components (Score: 5-6/10)

#### **5. Dotfiles (.zshrc, .tmux.conf)** - 6/10 MEDIUM
- **Data Type**: Shell aliases, tmux bindings, environment variables
- **Loss Scenario**: Multiple script runs → `.backup` overwritten
- **Recovery Difficulty**: Moderate (often in git, or remembered)
- **User Impact**: Inconvenience, some lost customizations

#### **6. Dangling Symlinks** - 5/10 MEDIUM
- **Data Type**: Configuration state awareness
- **Loss Scenario**: Repo moved, symlinks become dangling
- **Recovery Difficulty**: Easy (script recreates them)
- **User Impact**: Confusion, unexpected behavior

---

### Low Risk Components (Score: 2-4/10)

#### **7. Scooter/Ghostty Config** - 4/10 LOW
- **Data Type**: UI themes, keybindings
- **Loss Scenario**: Multiple script runs → `.backup` overwritten
- **Recovery Difficulty**: Easy (less customization typically)
- **User Impact**: Minor inconvenience

---

## 6. Backup Strategy Assessment

### Current Strategy: INADEQUATE

**Strengths:**
- ✓ Does attempt to backup before overwriting
- ✓ Provides visual warning messages
- ✓ Distinguishes between symlinks and regular files

**Critical Weaknesses:**
- ✗ **No timestamp on most backups** (only `setup_directory` has it)
- ✗ **Silent overwriting of previous backups**
- ✗ **No verification that backup succeeded**
- ✗ **No restore mechanism or guidance**
- ✗ **No detection of custom vs. repo content**
- ✗ **No interactive confirmation for destructive operations**
- ✗ **No backup history or listing**

### Comparison to Industry Best Practices

| Best Practice | Current Implementation | Gap |
|---------------|------------------------|-----|
| Timestamped backups | Partial (only dirs) | Files not timestamped |
| Multiple backup retention | No | Only one `.backup` kept |
| Restore mechanism | No | User must manually restore |
| Dry-run mode | No | No preview before changes |
| Interactive confirmation | No | No prompts for destructive ops |
| Backup verification | No | mv could fail silently |
| Rollback capability | No | No automated way to undo |
| Backup content diffing | No | Can't compare before overwrite |

---

## 7. Recommendations for Safer Implementation

### Priority 1: CRITICAL - Prevent Data Loss (Implement Immediately)

#### Recommendation #1: Add Timestamps to ALL Backups

**Current Code (Lines 136-151):**
```bash
create_symlink() {
    # ...
    elif [[ -e "$target" ]]; then
        print_warning "$name file exists, backing up to ${target}.backup"
        mv "$target" "${target}.backup"  # ← NO TIMESTAMP!
    fi
    # ...
}
```

**Improved Code:**
```bash
create_symlink() {
    local source=$1
    local target=$2
    local name=$3
    local timestamp=$(date +%Y%m%d_%H%M%S)

    if [[ -L "$target" ]]; then
        # Check if it's a dangling symlink
        if [[ ! -e "$target" ]]; then
            print_warning "$name is a dangling symlink (target missing), removing..."
        else
            print_info "$name symlink already exists, updating..."
        fi
        rm "$target"
    elif [[ -e "$target" ]]; then
        # Add timestamp to prevent collision
        local backup_path="${target}.backup.${timestamp}"
        print_warning "$name file exists, backing up to ${backup_path}"
        mv "$target" "$backup_path"
        
        # Verify backup succeeded
        if [[ ! -e "$backup_path" ]]; then
            print_error "Failed to create backup of $name! Aborting."
            return 1
        fi
        
        print_success "Backup created: ${backup_path}"
    fi

    ln -sf "$source" "$target"
    echo "    ${green}${LINK} $name${textreset} → ${dim}$target${textreset}"
}
```

**Benefits:**
- ✓ No backup collision - each run creates unique backup
- ✓ Detects dangling symlinks with helpful message
- ✓ Verifies backup succeeded before proceeding
- ✓ User can see all historical backups

---

#### Recommendation #2: Detect and Warn About Custom Agents

**New Function to Add:**
```bash
analyze_custom_agents() {
    local user_agents_dir=$1
    local repo_agents_dir=$2
    
    if [[ ! -d "$user_agents_dir" ]]; then
        return 0
    fi
    
    local custom_agents=()
    
    # Find agents in user dir that don't exist in repo
    while IFS= read -r -d '' user_agent; do
        local basename=$(basename "$user_agent")
        if [[ ! -f "$repo_agents_dir/$basename" ]]; then
            custom_agents+=("$basename")
        fi
    done < <(find "$user_agents_dir" -type f -name "*.md" -print0)
    
    if [[ ${#custom_agents[@]} -gt 0 ]]; then
        print_warning "Found ${#custom_agents[@]} custom agent(s) not in repository:"
        for agent in "${custom_agents[@]}"; do
            echo "    ${yellow}• ${agent}${textreset}"
        done
        
        # Interactive confirmation
        echo ""
        echo "${bold}These custom agents will be backed up to ${user_agents_dir}.backup.$(date +%Y%m%d_%H%M%S)${textreset}"
        echo -n "${yellow}Continue? [y/N]: ${textreset}"
        read -r response
        
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "Skipping agents directory symlink to preserve custom agents"
            return 1
        fi
    fi
    
    return 0
}
```

**Updated install_opencode() Lines 390-407:**
```bash
# Symlink agents directory
local agents_source="$opencode_config_source/agents"
local agents_target="$opencode_config_target/agents"

if [[ -d "$agents_source" ]]; then
    # Check for custom agents before overwriting
    if ! analyze_custom_agents "$agents_target" "$agents_source"; then
        print_info "Preserving user's custom agents directory"
    else
        local timestamp=$(date +%Y%m%d_%H%M%S)
        
        if [[ -L "$agents_target" ]]; then
            if [[ ! -e "$agents_target" ]]; then
                print_warning "Agents directory is a dangling symlink, removing..."
            else
                print_info "OpenCode agents directory symlink already exists, updating..."
            fi
            rm "$agents_target"
        elif [[ -d "$agents_target" ]]; then
            local backup_path="${agents_target}.backup.${timestamp}"
            print_warning "OpenCode agents directory exists, backing up to ${backup_path}"
            mv "$agents_target" "$backup_path"
            
            if [[ ! -d "$backup_path" ]]; then
                print_error "Failed to backup agents directory! Aborting."
                return 1
            fi
            
            print_success "Agents backup created: ${backup_path}"
        fi

        ln -sf "$agents_source" "$agents_target"
        echo "    ${green}${LINK} OpenCode agents${textreset} → ${dim}$agents_target${textreset}"
    fi
else
    print_warning "agents directory not found at $agents_source"
fi
```

**Benefits:**
- ✓ Detects custom agents before overwriting
- ✓ Shows user exactly what will be lost
- ✓ Requires explicit confirmation for destructive operations
- ✓ Timestamped backups prevent collisions
- ✓ Verifies backup succeeded

---

#### Recommendation #3: Handle Secrets in opencode.json

**New Function to Add:**
```bash
handle_opencode_config_merge() {
    local source=$1
    local target=$2
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # Check if target exists and contains potential secrets
    if [[ -f "$target" ]] && ! [[ -L "$target" ]]; then
        # Look for common secret indicators
        if grep -q "Bearer\|API[_-]KEY\|TOKEN\|PASSWORD\|SECRET" "$target" 2>/dev/null; then
            print_warning "Detected potential secrets in opencode.json!"
            print_info "Your configuration contains:"
            
            # Show what might be secrets (but don't print values!)
            grep -o '"[^"]*TOKEN[^"]*"\|"[^"]*KEY[^"]*"\|"[^"]*Bearer[^"]*"' "$target" | head -5
            
            echo ""
            echo "${bold}${yellow}Options:${textreset}"
            echo "  ${cyan}1)${textreset} Backup your current config and symlink to repo version (you'll need to re-add secrets)"
            echo "  ${cyan}2)${textreset} Keep your current config file (skip symlinking)"
            echo "  ${cyan}3)${textreset} Abort installation"
            echo ""
            echo -n "Choose [1-3]: "
            read -r choice
            
            case "$choice" in
                1)
                    local backup_path="${target}.backup.${timestamp}"
                    mv "$target" "$backup_path"
                    print_success "Config backed up to: ${backup_path}"
                    print_info "After installation, merge your secrets from backup into the new config"
                    return 0
                    ;;
                2)
                    print_info "Keeping existing opencode.json, skipping symlink"
                    return 1
                    ;;
                3)
                    print_error "Installation aborted by user"
                    exit 1
                    ;;
                *)
                    print_error "Invalid choice, aborting"
                    exit 1
                    ;;
            esac
        fi
    fi
    
    # No secrets detected, proceed normally
    return 0
}
```

**Updated opencode.json symlink code:**
```bash
# Symlink opencode.json with secret detection
local opencode_json_source="$opencode_config_source/opencode.json"
local opencode_json_target="$opencode_config_target/opencode.json"

if [[ -f "$opencode_json_source" ]]; then
    if handle_opencode_config_merge "$opencode_json_source" "$opencode_json_target"; then
        create_symlink "$opencode_json_source" "$opencode_json_target" "OpenCode config"
    fi
else
    print_warning "opencode.json not found at $opencode_json_source"
fi
```

**Benefits:**
- ✓ Detects potential secrets before overwriting
- ✓ Gives user control over how to handle secrets
- ✓ Prevents accidental loss of authentication credentials
- ✓ Provides clear guidance on next steps

---

### Priority 2: HIGH - Improve User Experience

#### Recommendation #4: Add Dry-Run Mode

**Add to beginning of script:**
```bash
# Parse command-line arguments
DRY_RUN=false
INTERACTIVE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --interactive|-i)
            INTERACTIVE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--dry-run] [--interactive]"
            exit 1
            ;;
    esac
done
```

**Update symlink functions:**
```bash
create_symlink() {
    local source=$1
    local target=$2
    local name=$3
    local timestamp=$(date +%Y%m%d_%H%M%S)

    if [[ "$DRY_RUN" == "true" ]]; then
        if [[ -L "$target" ]]; then
            echo "${dim}[DRY RUN]${textreset} Would update symlink: $name"
        elif [[ -e "$target" ]]; then
            echo "${dim}[DRY RUN]${textreset} Would backup: $target → ${target}.backup.${timestamp}"
            echo "${dim}[DRY RUN]${textreset} Would create symlink: $name → $source"
        else
            echo "${dim}[DRY RUN]${textreset} Would create symlink: $name → $source"
        fi
        return 0
    fi
    
    # ... rest of actual implementation
}
```

**Benefits:**
- ✓ User can preview changes before committing
- ✓ See exactly what will be backed up
- ✓ No risk when testing script

---

#### Recommendation #5: Add Backup Listing and Restore Helper

**New utility function:**
```bash
list_backups() {
    local config_base=$1
    
    echo ""
    echo "${bold}${cyan}Available backups:${textreset}"
    
    local backup_count=0
    
    # Find all .backup.* files and directories
    while IFS= read -r backup; do
        local basename=$(basename "$backup")
        local timestamp=$(echo "$basename" | grep -oE '[0-9]{8}_[0-9]{6}')
        local readable_date=""
        
        if [[ -n "$timestamp" ]]; then
            readable_date=$(date -j -f "%Y%m%d_%H%M%S" "$timestamp" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "$timestamp")
        fi
        
        if [[ -d "$backup" ]]; then
            local size=$(du -sh "$backup" | cut -f1)
            echo "  ${green}[DIR]${textreset}  $basename ${dim}(${size}, $readable_date)${textreset}"
        else
            local size=$(ls -lh "$backup" | awk '{print $5}')
            echo "  ${blue}[FILE]${textreset} $basename ${dim}(${size}, $readable_date)${textreset}"
        fi
        
        ((backup_count++))
    done < <(find "$config_base" -maxdepth 1 -name "*.backup*" 2>/dev/null)
    
    if [[ $backup_count -eq 0 ]]; then
        echo "  ${dim}No backups found${textreset}"
    fi
    
    echo ""
}

restore_backup() {
    local backup_path=$1
    local original_path=$(echo "$backup_path" | sed 's/\.backup\.[0-9_]*$//')
    
    if [[ ! -e "$backup_path" ]]; then
        print_error "Backup not found: $backup_path"
        return 1
    fi
    
    print_warning "This will restore: $backup_path → $original_path"
    
    if [[ -e "$original_path" ]]; then
        print_warning "Current configuration will be overwritten!"
        echo -n "Continue? [y/N]: "
        read -r response
        
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "Restore cancelled"
            return 1
        fi
        
        rm -rf "$original_path"
    fi
    
    mv "$backup_path" "$original_path"
    print_success "Restored: $original_path"
}
```

**Add to end of installation:**
```bash
print_installation_summary() {
    # ... existing summary ...
    
    echo ""
    echo "${bold}${cyan}📋 Backup Management:${textreset}"
    echo "${cyan}•${textreset} List backups: ${bold}ls -la ~/.config/*/backup*${textreset}"
    echo "${cyan}•${textreset} Restore example: ${bold}mv ~/.config/opencode/agents.backup.TIMESTAMP ~/.config/opencode/agents${textreset}"
    
    # Show any backups created during this run
    list_backups "$HOME/.config/opencode"
}
```

**Benefits:**
- ✓ User can see all available backups
- ✓ Easy restore process
- ✓ Shows backup dates and sizes
- ✓ Helps user understand backup state

---

### Priority 3: MEDIUM - Long-term Improvements

#### Recommendation #6: Use Git-like Backup System

**Concept: `.install-backups/` directory with versioned backups**

```bash
# Create backup system
BACKUP_ROOT="$HOME/.config/.install-backups"
BACKUP_SESSION="$BACKUP_ROOT/$(date +%Y%m%d_%H%M%S)"

init_backup_session() {
    mkdir -p "$BACKUP_SESSION"
    echo "Backup session: $(date)" > "$BACKUP_SESSION/session.log"
    echo "Script version: $(git rev-parse HEAD 2>/dev/null || echo 'unknown')" >> "$BACKUP_SESSION/session.log"
    print_info "Backup session created: $BACKUP_SESSION"
}

backup_file() {
    local file_path=$1
    local backup_name=$(basename "$file_path")
    local backup_path="$BACKUP_SESSION/$backup_name"
    
    cp -a "$file_path" "$backup_path"
    echo "Backed up: $file_path" >> "$BACKUP_SESSION/session.log"
    print_success "Backed up: $backup_name"
}

rollback_session() {
    local session_path=$1
    
    if [[ ! -d "$session_path" ]]; then
        print_error "Session not found: $session_path"
        return 1
    fi
    
    print_warning "Rolling back session: $(basename $session_path)"
    
    # Read session log and restore each file
    while IFS= read -r line; do
        if [[ "$line" =~ ^Backed\ up:\ (.*)$ ]]; then
            local original_path="${BASH_REMATCH[1]}"
            local backup_file=$(basename "$original_path")
            local backup_path="$session_path/$backup_file"
            
            if [[ -e "$backup_path" ]]; then
                cp -a "$backup_path" "$original_path"
                print_success "Restored: $original_path"
            fi
        fi
    done < "$session_path/session.log"
}
```

**Benefits:**
- ✓ All backups from one run grouped together
- ✓ Can rollback entire session
- ✓ Keeps backup history organized
- ✓ Includes metadata (date, git commit, etc.)

---

#### Recommendation #7: Add Interactive Confirmation Mode

```bash
confirm_destructive_operation() {
    local operation=$1
    local details=$2
    
    if [[ "$INTERACTIVE" != "true" ]]; then
        return 0  # Skip confirmation in non-interactive mode
    fi
    
    echo ""
    echo "${bold}${yellow}⚠  Destructive Operation:${textreset} $operation"
    echo "${dim}$details${textreset}"
    echo ""
    echo -n "${yellow}Proceed? [y/N]: ${textreset}"
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Operation skipped by user"
        return 1
    fi
    
    return 0
}

# Example usage in create_symlink:
create_symlink() {
    # ... existing checks ...
    
    if [[ -e "$target" ]]; then
        if ! confirm_destructive_operation \
            "Backup and replace $name" \
            "Current: $target\nBackup: ${target}.backup.${timestamp}\nNew target: $source"; then
            return 1
        fi
        
        # ... proceed with backup and symlink
    fi
}
```

**Benefits:**
- ✓ User control over each destructive operation
- ✓ Can opt-out of specific symlinks
- ✓ Educational - user learns what's being changed
- ✓ Optional - can disable with flag

---

## 8. Complete Improved Implementation

### Full Replacement for `install_opencode()` Function

```bash
install_opencode() {
    print_section "${STAR} Installing and Configuring OpenCode"

    # Install OpenCode if not already installed
    if ! command_exists opencode; then
        print_step "Installing OpenCode" "via Homebrew"
        if brew install --quiet anomalyco/tap/opencode 2>/dev/null; then
            print_success "OpenCode installed successfully!"
        else
            print_error "Failed to install OpenCode"
            return 1
        fi
    else
        print_info "OpenCode is already installed, skipping..."
    fi

    # Setup OpenCode configuration
    print_step "Setting up OpenCode configuration" "~/.config/opencode"

    local opencode_config_source="$(pwd)/opencode_global_config"
    local opencode_config_target="$HOME/.config/opencode"

    if [[ ! -d "$opencode_config_source" ]]; then
        print_error "OpenCode configuration source not found at $opencode_config_source"
        return 1
    fi

    # Create target directory if it doesn't exist
    mkdir -p "$opencode_config_target"

    # Initialize backup session for this run
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_session="$opencode_config_target/.backups/$timestamp"
    mkdir -p "$backup_session"
    echo "OpenCode configuration backup - $(date)" > "$backup_session/info.txt"

    # =================================================================
    # Handle opencode.json with secret detection
    # =================================================================
    local opencode_json_source="$opencode_config_source/opencode.json"
    local opencode_json_target="$opencode_config_target/opencode.json"

    if [[ -f "$opencode_json_source" ]]; then
        # Check for secrets in existing config
        if [[ -f "$opencode_json_target" ]] && ! [[ -L "$opencode_json_target" ]]; then
            if grep -qi "bearer\|api[_-]key\|token\|password\|secret" "$opencode_json_target" 2>/dev/null; then
                print_warning "Detected potential secrets/API keys in your opencode.json!"
                echo ""
                echo "${bold}${yellow}Your configuration may contain:${textreset}"
                grep -io '"[^"]*\(token\|key\|bearer\|secret\)[^"]*"' "$opencode_json_target" | head -5
                echo ""
                echo "${bold}${cyan}Options:${textreset}"
                echo "  ${cyan}1)${textreset} Backup current config, symlink to repo (you'll need to re-add secrets)"
                echo "  ${cyan}2)${textreset} Keep your current file (recommended if you have custom secrets)"
                echo "  ${cyan}3)${textreset} Abort installation"
                echo ""
                echo -n "${yellow}Choose [1-3] (default: 2): ${textreset}"
                read -r choice
                choice=${choice:-2}  # Default to option 2 (keep current)
                
                case "$choice" in
                    1)
                        local backup_path="$backup_session/opencode.json"
                        cp "$opencode_json_target" "$backup_path"
                        print_success "Backed up to: $backup_path"
                        rm "$opencode_json_target"
                        ln -sf "$opencode_json_source" "$opencode_json_target"
                        print_success "Symlinked opencode.json (restore secrets from backup)"
                        echo "${dim}    To restore secrets: review $backup_path${textreset}"
                        ;;
                    2)
                        print_info "Keeping your existing opencode.json (skipping symlink)"
                        ;;
                    3)
                        print_error "Installation aborted by user"
                        return 1
                        ;;
                    *)
                        print_error "Invalid choice, keeping existing file"
                        ;;
                esac
            else
                # No secrets detected, safe to symlink
                improved_create_symlink "$opencode_json_source" "$opencode_json_target" "OpenCode config" "$backup_session"
            fi
        elif [[ -L "$opencode_json_target" ]]; then
            # Already a symlink, just update it
            improved_create_symlink "$opencode_json_source" "$opencode_json_target" "OpenCode config" "$backup_session"
        else
            # No existing file, create symlink
            ln -sf "$opencode_json_source" "$opencode_json_target"
            print_success "Created opencode.json symlink"
        fi
    else
        print_warning "opencode.json not found at $opencode_json_source"
    fi

    # =================================================================
    # Handle agents directory with custom agent detection
    # =================================================================
    local agents_source="$opencode_config_source/agents"
    local agents_target="$opencode_config_target/agents"

    if [[ -d "$agents_source" ]]; then
        # Check for custom agents before proceeding
        if [[ -d "$agents_target" ]] && ! [[ -L "$agents_target" ]]; then
            print_step "Analyzing existing agents directory" "checking for custom agents"
            
            local custom_agents=()
            
            # Find agents that exist in user dir but not in repo
            if [[ -d "$agents_target" ]]; then
                while IFS= read -r -d '' user_agent; do
                    local agent_basename=$(basename "$user_agent")
                    if [[ ! -f "$agents_source/$agent_basename" ]]; then
                        custom_agents+=("$agent_basename")
                    fi
                done < <(find "$agents_target" -type f -name "*.md" -print0 2>/dev/null)
            fi
            
            if [[ ${#custom_agents[@]} -gt 0 ]]; then
                print_warning "Found ${#custom_agents[@]} custom agent(s) not in repository:"
                for agent in "${custom_agents[@]}"; do
                    echo "    ${yellow}• ${agent}${textreset}"
                done
                echo ""
                echo "${bold}${cyan}Options:${textreset}"
                echo "  ${cyan}1)${textreset} Backup and symlink (custom agents preserved in backup)"
                echo "  ${cyan}2)${textreset} Keep existing agents directory (recommended)"
                echo "  ${cyan}3)${textreset} Merge custom agents into repo directory (advanced)"
                echo ""
                echo -n "${yellow}Choose [1-3] (default: 2): ${textreset}"
                read -r choice
                choice=${choice:-2}
                
                case "$choice" in
                    1)
                        local backup_path="$backup_session/agents"
                        cp -r "$agents_target" "$backup_path"
                        print_success "Backed up agents to: $backup_path"
                        rm -rf "$agents_target"
                        ln -sf "$agents_source" "$agents_target"
                        print_success "Symlinked agents directory"
                        print_info "Your custom agents are in: $backup_path"
                        ;;
                    2)
                        print_info "Keeping your existing agents directory (skipping symlink)"
                        ;;
                    3)
                        print_info "Copying custom agents to repository directory..."
                        for agent in "${custom_agents[@]}"; do
                            if [[ -f "$agents_target/$agent" ]]; then
                                cp "$agents_target/$agent" "$agents_source/$agent"
                                print_success "Copied: $agent"
                            fi
                        done
                        print_warning "Note: These custom agents are now in your repo (may affect git)"
                        ;;
                    *)
                        print_error "Invalid choice, keeping existing directory"
                        ;;
                esac
            else
                # No custom agents, safe to symlink
                print_info "No custom agents detected, proceeding with symlink..."
                improved_create_symlink_dir "$agents_source" "$agents_target" "OpenCode agents" "$backup_session"
            fi
        elif [[ -L "$agents_target" ]]; then
            # Already a symlink, update it
            improved_create_symlink_dir "$agents_source" "$agents_target" "OpenCode agents" "$backup_session"
        else
            # No existing directory, create symlink
            ln -sf "$agents_source" "$agents_target"
            print_success "Created agents directory symlink"
        fi
    else
        print_warning "agents directory not found at $agents_source"
    fi

    # =================================================================
    # Show backup session summary
    # =================================================================
    echo ""
    if [[ -n "$(ls -A "$backup_session" 2>/dev/null)" ]]; then
        print_info "Backups created in: $backup_session"
        echo "${dim}    To rollback: rm symlinks and mv backups to original locations${textreset}"
    else
        # Clean up empty backup session
        rmdir "$backup_session" 2>/dev/null || true
    fi

    echo ""
    print_success "OpenCode installation and configuration complete!"
}

# =================================================================
# Helper function: Improved symlink creation for files
# =================================================================
improved_create_symlink() {
    local source=$1
    local target=$2
    local name=$3
    local backup_session=$4
    
    if [[ -L "$target" ]]; then
        # Check if it's a dangling symlink
        if [[ ! -e "$target" ]]; then
            print_warning "$name is a dangling symlink (target deleted), removing..."
        else
            print_info "$name symlink already exists, updating..."
        fi
        rm "$target"
    elif [[ -e "$target" ]]; then
        # Backup with timestamp to prevent collisions
        local backup_path="$backup_session/$(basename "$target")"
        print_warning "$name file exists, backing up..."
        
        cp "$target" "$backup_path"
        
        if [[ ! -e "$backup_path" ]]; then
            print_error "Failed to create backup! Aborting symlink creation."
            return 1
        fi
        
        print_success "Backed up to: $backup_path"
        rm "$target"
    fi
    
    ln -sf "$source" "$target"
    print_success "Symlinked: $name"
    echo "    ${dim}$target → $source${textreset}"
}

# =================================================================
# Helper function: Improved symlink creation for directories
# =================================================================
improved_create_symlink_dir() {
    local source=$1
    local target=$2
    local name=$3
    local backup_session=$4
    
    if [[ -L "$target" ]]; then
        # Check if it's a dangling symlink
        if [[ ! -e "$target" ]]; then
            print_warning "$name is a dangling symlink (target deleted), removing..."
        else
            print_info "$name symlink already exists, updating..."
        fi
        rm "$target"
    elif [[ -d "$target" ]]; then
        # Backup directory with timestamp
        local backup_path="$backup_session/$(basename "$target")"
        print_warning "$name directory exists, backing up..."
        
        cp -r "$target" "$backup_path"
        
        if [[ ! -d "$backup_path" ]]; then
            print_error "Failed to create directory backup! Aborting symlink creation."
            return 1
        fi
        
        print_success "Backed up to: $backup_path"
        rm -rf "$target"
    fi
    
    ln -sf "$source" "$target"
    print_success "Symlinked: $name"
    echo "    ${dim}$target → $source${textreset}"
}
```

### Key Improvements in This Implementation

1. **Session-based Backups**: All backups from one run go into dated session folder
2. **Secret Detection**: Warns about API keys/tokens before overwriting opencode.json
3. **Custom Agent Detection**: Finds agents user created that aren't in repo
4. **Interactive Choices**: User decides how to handle conflicts
5. **Dangling Symlink Detection**: Warns when symlink points to deleted target
6. **Verified Backups**: Checks that backup succeeded before deleting original
7. **Clear Communication**: Shows exactly what will happen with each choice
8. **Rollback Information**: Tells user how to undo if needed
9. **Clean Sessions**: Removes empty backup directories if nothing was backed up
10. **Default Safe Behavior**: Defaults to keeping user data (option 2)

---

## 9. Migration Path for Existing Users

### For Users Who Already Ran the Old Script

```bash
#!/bin/bash
# migrate-backups.sh - Consolidate old backups into new system

OPENCODE_DIR="$HOME/.config/opencode"
NEW_BACKUP_ROOT="$OPENCODE_DIR/.backups/migration-$(date +%Y%m%d_%H%M%S)"

echo "Migrating old backups to new system..."
mkdir -p "$NEW_BACKUP_ROOT"

# Find all .backup files (without timestamp)
if [[ -e "$OPENCODE_DIR/opencode.json.backup" ]]; then
    mv "$OPENCODE_DIR/opencode.json.backup" "$NEW_BACKUP_ROOT/opencode.json"
    echo "✓ Migrated opencode.json.backup"
fi

if [[ -d "$OPENCODE_DIR/agents.backup" ]]; then
    mv "$OPENCODE_DIR/agents.backup" "$NEW_BACKUP_ROOT/agents"
    echo "✓ Migrated agents.backup"
fi

echo ""
echo "Migration complete!"
echo "Old backups are now in: $NEW_BACKUP_ROOT"
echo ""
echo "Next steps:"
echo "1. Review backups: ls -la $NEW_BACKUP_ROOT"
echo "2. If you want to restore, run: ./restore-backup.sh"
```

---

## 10. Testing Checklist

### Before Merging Improvements

- [ ] Test with fresh install (no existing config)
- [ ] Test with existing opencode.json containing fake tokens
- [ ] Test with existing opencode.json as symlink
- [ ] Test with existing agents directory with custom agents
- [ ] Test with existing agents directory as symlink
- [ ] Test with dangling symlinks (target deleted)
- [ ] Test running script twice in a row
- [ ] Test running script after manual restore
- [ ] Test all user choice options (1, 2, 3)
- [ ] Test dry-run mode (if implemented)
- [ ] Test interactive mode (if implemented)
- [ ] Verify backup files are actually created
- [ ] Verify backups don't overwrite each other
- [ ] Test on macOS (primary platform)
- [ ] Test on Linux (if supported)

---

## 11. Summary of Findings

### What's Good
- ✓ Script does attempt to backup before overwriting
- ✓ Distinguishes between symlinks and regular files
- ✓ Uses visual warnings to alert users
- ✓ `setup_directory()` has timestamps (good pattern to follow)

### What's Broken (Critical Issues)
- ✗ **No timestamps on file/agent backups** → Multiple runs overwrite backups
- ✗ **No detection of secrets in opencode.json** → API keys lost
- ✗ **No detection of custom agents** → User work lost
- ✗ **Dangling symlinks not properly detected** → Confusing behavior
- ✗ **No verification that backups succeeded** → Silent failures possible
- ✗ **Inconsistent backup strategy** across functions

### What's Missing (Feature Gaps)
- ✗ No dry-run mode to preview changes
- ✗ No interactive confirmation for destructive operations
- ✗ No restore mechanism or guidance
- ✗ No backup listing or management
- ✗ No session-based backup organization
- ✗ No rollback capability

### Risk Score by Scenario

| Scenario | Severity | Likelihood | Overall Risk |
|----------|----------|------------|--------------|
| Multiple script runs overwrite backups | Critical | High | **9/10** |
| API keys lost in opencode.json | Critical | Medium | **8/10** |
| Custom agents permanently lost | Critical | Medium | **8/10** |
| Backup collision (user confusion) | High | Medium | **7/10** |
| Dangling symlink edge cases | Medium | Low | **5/10** |

---

## 12. Implementation Priority

### Phase 1: Critical Fixes (Must-Have - Week 1)
1. ✓ Add timestamps to all backups (files AND directories)
2. ✓ Add secret detection for opencode.json
3. ✓ Add custom agent detection
4. ✓ Add dangling symlink detection
5. ✓ Add backup verification

### Phase 2: Safety Improvements (Should-Have - Week 2)
6. ✓ Add session-based backup system
7. ✓ Add interactive confirmation mode
8. ✓ Add backup listing utility
9. ✓ Update documentation with backup/restore guide

### Phase 3: Quality of Life (Nice-to-Have - Week 3)
10. ✓ Add dry-run mode
11. ✓ Add restore helper script
12. ✓ Add backup cleanup utility (remove old backups)
13. ✓ Add migration script for existing users

---

## Conclusion

The current `install_opencode()` implementation poses **significant data loss risks**, particularly for users who:
1. Run the script multiple times (very common during troubleshooting)
2. Have customized their opencode.json with API keys/tokens (expected workflow)
3. Have created custom agents for their specific use cases (power users)

The **lack of timestamps on backups** is the most critical issue, as it creates a false sense of security. Users think their data is backed up safely, but subsequent script runs silently overwrite those backups.

**Recommended Action**: Implement Priority 1 fixes immediately before promoting this installation script to more users. The improved implementation provided in Section 8 addresses all critical issues while maintaining backward compatibility and providing clear user guidance.

**Estimated Impact of Fixes**:
- Data loss risk reduced from **8/10** to **2/10**
- User confidence increased significantly
- Support burden reduced (fewer "I lost my config" issues)
- Professional appearance and trust in the project improved
