#Requires -Version 5.1

<#
.SYNOPSIS
    NairoVIM Installation Script for Windows

.DESCRIPTION
    Enhanced installation script for NairoVIM on Windows. Installs Neovim,
    Windows Terminal, Oh My Posh, CLI tools, and configures your complete
    development environment using Scoop package manager.

.NOTES
    Version:        1.0.0
    Author:         NairoVIM Team
    Requires:       PowerShell 5.1+, Windows 10/11
#>

# ======================================================================
# ERROR HANDLING & CONFIGURATION
# ======================================================================

$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# ======================================================================
# COLOR DEFINITIONS & STYLING
# ======================================================================

$Script:Colors = @{
    Reset   = "`e[0m"
    Red     = "`e[31m"
    Green   = "`e[32m"
    Yellow  = "`e[33m"
    Blue    = "`e[34m"
    Magenta = "`e[35m"
    Cyan    = "`e[36m"
    Bold    = "`e[1m"
    Dim     = "`e[2m"
}

# Enhanced symbols with Unicode support
$Script:Symbols = @{
    CheckMark  = "✓"
    CrossMark  = "✗"
    ArrowRight = "→"
    Star       = "★"
    Gear       = "⚙"
    Rocket     = "🚀"
    Package    = "📦"
    Link       = "🔗"
    Sparkles   = "✨"
    Hourglass  = "⏳"
    Warning    = "⚠"
    Info       = "ℹ"
}

# ======================================================================
# UTILITY FUNCTIONS
# ======================================================================

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "Reset"
    )
    Write-Host "$($Colors[$Color])$Message$($Colors.Reset)"
}

function Print-Header {
    param([string]$Title)
    
    Write-Host ""
    Write-ColorOutput "╔══════════════════════════════════════════════════════════════════════════════════════╗" -Color "Cyan"
    Write-ColorOutput "║  $Title" -Color "Magenta"
    Write-ColorOutput "╚══════════════════════════════════════════════════════════════════════════════════════╝" -Color "Cyan"
    Write-Host ""
}

function Print-Section {
    param([string]$Title)
    
    Write-Host ""
    Write-ColorOutput "▓▓▓ $Title ▓▓▓" -Color "Blue"
    Write-Host ""
}

function Print-Step {
    param(
        [string]$Message,
        [string]$Detail = ""
    )
    
    $output = "$($Symbols.Hourglass) $($Colors.Bold)$Message$($Colors.Reset)"
    if ($Detail) {
        $output += " $($Colors.Dim)$Detail$($Colors.Reset)"
    }
    Write-Host $output
}

function Print-Success {
    param([string]$Message)
    Write-ColorOutput "$($Symbols.CheckMark) Done - $Message" -Color "Green"
}

function Print-Error {
    param([string]$Message)
    Write-ColorOutput "$($Symbols.CrossMark) Error - $Message" -Color "Red"
}

function Print-Warning {
    param([string]$Message)
    Write-ColorOutput "$($Symbols.Warning) Warning - $Message" -Color "Yellow"
}

function Print-Info {
    param([string]$Message)
    Write-ColorOutput "$($Symbols.Info) Info - $Message" -Color "Blue"
}

function Test-Command {
    param([string]$CommandName)
    
    $null -ne (Get-Command $CommandName -ErrorAction SilentlyContinue)
}

function Test-AdminPrivileges {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function New-Symlink {
    param(
        [string]$Source,
        [string]$Target,
        [string]$Name
    )
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    # Check if target is a symlink
    if (Test-Path $Target -PathType Any) {
        $item = Get-Item $Target -Force
        
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            # It's a symlink
            if (-not (Test-Path $Target)) {
                Print-Warning "$Name is a dangling symlink (target missing), removing..."
            } else {
                Print-Info "$Name symlink already exists, updating..."
            }
            Remove-Item $Target -Force
        } elseif ($item.PSIsContainer) {
            # It's a directory
            $backupPath = "${Target}.backup.${timestamp}"
            Print-Warning "$Name directory exists, backing up to $backupPath"
            Move-Item $Target $backupPath -Force
            Print-Success "Backup created: $backupPath"
        } else {
            # It's a regular file
            $backupPath = "${Target}.backup.${timestamp}"
            Print-Warning "$Name file exists, backing up to $backupPath"
            Move-Item $Target $backupPath -Force
            Print-Success "Backup created: $backupPath"
        }
    }
    
    # Create parent directory if it doesn't exist
    $parentDir = Split-Path $Target -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    
    # Create symlink
    try {
        New-Item -ItemType SymbolicLink -Path $Target -Value $Source -Force | Out-Null
        Write-Host "    $($Colors.Green)$($Symbols.Link) $Name$($Colors.Reset) $($Colors.Dim)→ $Target$($Colors.Reset)"
    } catch {
        Print-Error "Failed to create symlink for $Name. You may need to enable Developer Mode in Windows Settings."
        throw
    }
}

function Test-Secrets {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        return $false
    }
    
    $content = Get-Content $FilePath -Raw
    return $content -match "bearer|api[_-]key|token|password|secret"
}

function Get-CustomAgents {
    param(
        [string]$UserAgentsDir,
        [string]$RepoAgentsDir
    )
    
    if (-not (Test-Path $UserAgentsDir)) {
        return @()
    }
    
    $customAgents = @()
    $userAgents = Get-ChildItem -Path $UserAgentsDir -Filter "*.md" -File -ErrorAction SilentlyContinue
    
    foreach ($agent in $userAgents) {
        $repoAgent = Join-Path $RepoAgentsDir $agent.Name
        if (-not (Test-Path $repoAgent)) {
            $customAgents += $agent.Name
        }
    }
    
    return $customAgents
}

# ======================================================================
# PACKAGE MANAGER FUNCTIONS
# ======================================================================

function Install-Scoop {
    Print-Section "$($Symbols.Package) Installing Scoop Package Manager"
    
    if (Test-Command "scoop") {
        Print-Info "Scoop is already installed, skipping..."
        return
    }
    
    Print-Step "Installing Scoop" "Modern package manager for Windows"
    
    try {
        # Set execution policy for current user
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        
        # Install Scoop
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
        
        Print-Success "Scoop installed successfully!"
        
        # Add essential buckets
        Print-Step "Adding Scoop buckets" "extras, nerd-fonts"
        scoop bucket add extras 2>$null
        scoop bucket add nerd-fonts 2>$null
        
        Print-Success "Scoop buckets added"
    } catch {
        Print-Error "Failed to install Scoop: $_"
        Write-Host ""
        Write-ColorOutput "Please install Scoop manually:" -Color "Yellow"
        Write-Host "  irm get.scoop.sh | iex"
        exit 1
    }
}

function Install-WithScoop {
    param(
        [string]$Package,
        [string]$DisplayName = $Package
    )
    
    if (Test-Command $Package) {
        Print-Info "$DisplayName is already installed, skipping..."
        return
    }
    
    Print-Step "Installing $DisplayName" "via Scoop"
    
    try {
        scoop install $Package *>$null
        Print-Success "Installed $DisplayName"
    } catch {
        Print-Error "Failed to install $DisplayName"
        return
    }
}

# ======================================================================
# MAIN INSTALLATION FUNCTIONS
# ======================================================================

function Install-BuildTools {
    Print-Section "$($Symbols.Gear) Installing Build Tools"
    
    Print-Info "Installing C compiler toolchain for Neovim plugin compilation..."
    Print-Info "This enables: telescope-fzf-native, nvim-treesitter, CopilotChat"
    
    # Install MinGW (provides gcc, g++, make)
    Install-WithScoop -Package "mingw" -DisplayName "MinGW (GCC compiler)"
    
    # Install CMake (build system)
    Install-WithScoop -Package "cmake" -DisplayName "CMake"
    
    # Verify installations
    Print-Step "Verifying build tools installation"
    
    $buildToolsReady = $true
    
    if (Test-Command "gcc") {
        try {
            $gccOutput = gcc --version 2>&1 | Select-Object -First 1
            $gccVersion = if ($gccOutput -match '(\d+\.\d+\.\d+)') { $matches[1] } else { "unknown" }
            Print-Success "GCC compiler ready (v$gccVersion)"
        } catch {
            Print-Success "GCC compiler ready"
        }
    } else {
        Print-Warning "GCC not found in PATH"
        $buildToolsReady = $false
    }
    
    if (Test-Command "make") {
        Print-Success "GNU Make ready"
    } else {
        Print-Warning "Make not found in PATH"
        $buildToolsReady = $false
    }
    
    if (Test-Command "cmake") {
        try {
            $cmakeOutput = cmake --version 2>&1 | Select-Object -First 1
            $cmakeVersion = if ($cmakeOutput -match '(\d+\.\d+\.\d+)') { $matches[1] } else { "unknown" }
            Print-Success "CMake ready (v$cmakeVersion)"
        } catch {
            Print-Success "CMake ready"
        }
    } else {
        Print-Warning "CMake not found in PATH"
        $buildToolsReady = $false
    }
    
    if ($buildToolsReady) {
        Print-Success "Build tools configured successfully"
    } else {
        Print-Warning "Some build tools may require terminal restart to be available"
        Print-Info "Close and reopen your terminal, then run: .\install.ps1"
    }
    
    Write-Host ""
    Print-Success "Build tools installation complete!"
}

function Install-Dotfiles {
    Print-Section "$($Symbols.Link) Linking Dotfiles"
    
    $scriptPath = $PSScriptRoot
    
    # Link .ripgreprc
    if (Test-Path "$scriptPath\.ripgreprc") {
        $ripgrepTarget = Join-Path $env:USERPROFILE ".ripgreprc"
        New-Symlink -Source "$scriptPath\.ripgreprc" -Target $ripgrepTarget -Name ".ripgreprc"
        
        # Set environment variable
        [Environment]::SetEnvironmentVariable("RIPGREP_CONFIG_PATH", $ripgrepTarget, "User")
        Print-Info "RIPGREP_CONFIG_PATH environment variable set"
    } else {
        Print-Warning ".ripgreprc not found in $scriptPath"
    }
    
    # Link scooter config
    $scooterConfigSource = Join-Path $scriptPath "scooter.config.toml"
    if (Test-Path $scooterConfigSource) {
        $scooterConfigTarget = Join-Path $env:APPDATA "scooter\config.toml"
        New-Symlink -Source $scooterConfigSource -Target $scooterConfigTarget -Name "Scooter config"
    } else {
        Print-Warning "scooter.config.toml not found in $scriptPath"
    }
    
    # Create/Update PowerShell profile
    Print-Step "Setting up PowerShell profile" "$PROFILE"
    
    if (-not (Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
        Print-Success "Created PowerShell profile"
    }
    
    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    
    # Add RIPGREP_CONFIG_PATH if not present
    if ($profileContent -notmatch "RIPGREP_CONFIG_PATH") {
        Add-Content $PROFILE "`n# NairoVIM Configuration`n`$env:RIPGREP_CONFIG_PATH = '$ripgrepTarget'"
        Print-Info "Added RIPGREP_CONFIG_PATH to PowerShell profile"
    }
    
    Write-Host ""
    Print-Success "All dotfiles linked successfully!"
}

function Install-Neovim {
    Print-Section "$($Symbols.Rocket) Installing Neovim"
    
    Install-WithScoop -Package "neovim" -DisplayName "Neovim"
    
    Print-Step "Setting up Neovim configuration" "$env:LOCALAPPDATA\nvim"
    
    $nvimConfigSource = Join-Path $PSScriptRoot "nvim"
    $nvimConfigTarget = Join-Path $env:LOCALAPPDATA "nvim"
    
    if (-not (Test-Path $nvimConfigSource)) {
        Print-Error "Neovim configuration source not found at $nvimConfigSource"
        return
    }
    
    # Create symlink for nvim config
    if (Test-Path $nvimConfigTarget) {
        $item = Get-Item $nvimConfigTarget -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Print-Info "Neovim config symlink already exists, updating..."
            Remove-Item $nvimConfigTarget -Force
        } else {
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $backupPath = "${nvimConfigTarget}.backup.${timestamp}"
            Print-Warning "Neovim config exists, backing up to $backupPath"
            Move-Item $nvimConfigTarget $backupPath -Force
        }
    }
    
    New-Item -ItemType SymbolicLink -Path $nvimConfigTarget -Value $nvimConfigSource -Force | Out-Null
    Print-Success "Linked Neovim configuration"
    
    Write-Host ""
    Print-Success "Neovim installation and configuration complete!"
}

function Install-WindowsTerminal {
    Print-Section "$($Symbols.Gear) Installing Windows Terminal"
    
    # Check if Windows Terminal is already installed
    $wtInstalled = $false
    
    # Check via winget
    if (Test-Command "winget") {
        $result = winget list --id Microsoft.WindowsTerminal 2>$null
        if ($result -match "Microsoft.WindowsTerminal") {
            $wtInstalled = $true
        }
    }
    
    # Check via Scoop
    if (-not $wtInstalled) {
        $scoopApps = scoop list 2>$null
        if ($scoopApps -match "windows-terminal") {
            $wtInstalled = $true
        }
    }
    
    if ($wtInstalled) {
        Print-Info "Windows Terminal is already installed, skipping..."
    } else {
        Print-Step "Installing Windows Terminal" "via Scoop"
        
        try {
            scoop install windows-terminal *>$null
            Print-Success "Windows Terminal installed successfully!"
        } catch {
            Print-Warning "Failed to install via Scoop, trying winget..."
            
            if (Test-Command "winget") {
                winget install --id Microsoft.WindowsTerminal -e --silent
                Print-Success "Windows Terminal installed via winget!"
            } else {
                Print-Error "Failed to install Windows Terminal. Please install manually from Microsoft Store."
            }
        }
    }
    
    # Link Windows Terminal settings
    Print-Step "Setting up Windows Terminal configuration" "settings.json"
    
    $wtSettingsSource = Join-Path $PSScriptRoot "windows-terminal-settings.json"
    
    # Find Windows Terminal settings path
    $wtPackages = Get-ChildItem "$env:LOCALAPPDATA\Packages" -Directory -Filter "Microsoft.WindowsTerminal*" -ErrorAction SilentlyContinue
    
    if ($wtPackages) {
        $wtSettingsDir = Join-Path $wtPackages[0].FullName "LocalState"
        $wtSettingsTarget = Join-Path $wtSettingsDir "settings.json"
        
        if (Test-Path $wtSettingsSource) {
            New-Symlink -Source $wtSettingsSource -Target $wtSettingsTarget -Name "Windows Terminal settings"
            Print-Success "Windows Terminal configuration linked!"
        } else {
            Print-Warning "windows-terminal-settings.json not found at $wtSettingsSource"
            Print-Info "You can configure Windows Terminal manually via Settings (Ctrl+,)"
        }
    } else {
        Print-Warning "Windows Terminal settings directory not found. Launch Windows Terminal once to create it."
    }
    
    Write-Host ""
    Print-Success "Windows Terminal setup complete!"
}

function Install-OhMyPosh {
    Print-Section "$($Symbols.Sparkles) Installing Oh My Posh"
    
    Install-WithScoop -Package "oh-my-posh" -DisplayName "Oh My Posh"
    
    # Install a Nerd Font
    Print-Step "Installing JetBrainsMono Nerd Font" "for proper icon display"
    
    try {
        scoop install JetBrainsMono-NF-Mono *>$null
        Print-Success "JetBrainsMono Nerd Font installed"
    } catch {
        Print-Warning "Failed to install Nerd Font. Install manually from https://www.nerdfonts.com/"
    }
    
    # Configure PowerShell profile with Oh My Posh
    Print-Step "Configuring PowerShell profile" "with Oh My Posh theme"
    
    if (-not (Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }
    
    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    
    if ($profileContent -notmatch "oh-my-posh init") {
        $ohMyPoshInit = @"

# Oh My Posh Configuration
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\tokyonight_storm.omp.json" | Invoke-Expression
"@
        Add-Content $PROFILE $ohMyPoshInit
        Print-Success "Oh My Posh configured in PowerShell profile"
    } else {
        Print-Info "Oh My Posh already configured in profile"
    }
    
    Write-Host ""
    Print-Success "Oh My Posh installation complete!"
}

function Install-CLITools {
    Print-Section "$($Symbols.Package) Installing CLI Tools"
    
    $tools = @(
        @{Package = "fzf"; Name = "FZF (Terminal fuzzy finder)"},
        @{Package = "ripgrep"; Name = "ripgrep (Fast search tool)"},
        @{Package = "bat"; Name = "bat (Enhanced cat with syntax highlighting)"},
        @{Package = "git"; Name = "Git (Version control)"},
        @{Package = "lazygit"; Name = "Lazygit (Git TUI)"},
        @{Package = "fd"; Name = "fd (Fast file finder)"}
    )
    
    foreach ($tool in $tools) {
        Install-WithScoop -Package $tool.Package -DisplayName $tool.Name
    }
    
    # Check for scooter (might not be available on Windows)
    Print-Step "Checking for scooter" "interactive search and replace"
    if (Test-Command "scooter") {
        Print-Info "Scooter is already installed"
    } else {
        try {
            scoop install scooter *>$null
            Print-Success "Installed scooter"
        } catch {
            Print-Warning "Scooter not available via Scoop. Skipping..."
        }
    }
    
    Write-Host ""
    Print-Success "All CLI tools installed successfully!"
}

function Install-UV {
    Print-Section "$($Symbols.Star) Installing UV/UVX"
    
    if (Test-Command "uv") {
        Print-Info "UV is already installed, skipping..."
        return
    }
    
    Print-Step "Installing UV/UVX" "for Python/MCP plugins"
    
    try {
        Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
        Print-Success "UV/UVX installed successfully!"
        Print-Info "UV/UVX is now available for MCP plugin management"
    } catch {
        Print-Error "Failed to install UV/UVX: $_"
        Print-Warning "You can install manually from: https://astral.sh/uv"
    }
}

function Install-Lazygit {
    Print-Section "$($Symbols.Gear) Installing and Configuring Lazygit"
    
    # Lazygit is already installed in Install-CLITools, just configure it
    Print-Step "Setting up Lazygit configuration" "$env:APPDATA\lazygit\config.yml"
    
    $lazygitConfigSource = Join-Path $PSScriptRoot "lazygit_config.yml"
    $lazygitConfigTarget = Join-Path $env:APPDATA "lazygit\config.yml"
    
    if (Test-Path $lazygitConfigSource) {
        New-Symlink -Source $lazygitConfigSource -Target $lazygitConfigTarget -Name "Lazygit config"
        
        # Set environment variable
        [Environment]::SetEnvironmentVariable("CONFIG_DIR", (Join-Path $env:APPDATA "lazygit"), "User")
        
        Print-Success "Lazygit configuration linked successfully!"
    } else {
        Print-Warning "Lazygit configuration file not found at $lazygitConfigSource"
    }
}

function Install-OpenCode {
    Print-Section "$($Symbols.Star) Installing and Configuring OpenCode"
    
    # Install OpenCode
    if (-not (Test-Command "opencode")) {
        Print-Step "Installing OpenCode" "AI-powered coding assistant"
        
        try {
            # Add anomalyco bucket
            scoop bucket add anomalyco https://github.com/anomalyco/scoop-bucket 2>$null
            scoop install opencode *>$null
            Print-Success "OpenCode installed successfully!"
        } catch {
            Print-Error "Failed to install OpenCode via Scoop"
            Print-Info "Visit https://opencode.ai for manual installation"
            return
        }
    } else {
        Print-Info "OpenCode is already installed, skipping..."
    }
    
    # Setup OpenCode configuration
    Print-Step "Setting up OpenCode configuration" "$env:APPDATA\opencode"
    
    $opencodeConfigSource = Join-Path $PSScriptRoot "opencode_global_config"
    $opencodeConfigTarget = Join-Path $env:APPDATA "opencode"
    
    if (-not (Test-Path $opencodeConfigSource)) {
        Print-Error "OpenCode configuration source not found at $opencodeConfigSource"
        return
    }
    
    # Create target directory
    if (-not (Test-Path $opencodeConfigTarget)) {
        New-Item -ItemType Directory -Path $opencodeConfigTarget -Force | Out-Null
    }
    
    # Initialize backup session
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupSession = Join-Path $opencodeConfigTarget ".backups\$timestamp"
    New-Item -ItemType Directory -Path $backupSession -Force | Out-Null
    "OpenCode configuration backup - $(Get-Date)" | Out-File "$backupSession\info.txt"
    
    # Handle opencode.json with secret detection
    $opencodeJsonSource = Join-Path $opencodeConfigSource "opencode.json"
    $opencodeJsonTarget = Join-Path $opencodeConfigTarget "opencode.json"
    
    if (Test-Path $opencodeJsonSource) {
        if ((Test-Path $opencodeJsonTarget) -and -not ((Get-Item $opencodeJsonTarget -Force).Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
            if (Test-Secrets $opencodeJsonTarget) {
                Print-Warning "Detected potential secrets/API keys in your opencode.json!"
                Write-Host ""
                Write-ColorOutput "Your configuration may contain sensitive data" -Color "Yellow"
                Write-Host ""
                Write-ColorOutput "Options:" -Color "Cyan"
                Write-Host "  1) Backup current config, symlink to repo (you'll need to re-add secrets)"
                Write-Host "  2) Keep your current file (recommended if you have custom secrets)"
                Write-Host "  3) Abort installation"
                Write-Host ""
                $choice = Read-Host "Choose [1-3] (default: 2)"
                if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "2" }
                
                switch ($choice) {
                    "1" {
                        $backupPath = Join-Path $backupSession "opencode.json"
                        Copy-Item $opencodeJsonTarget $backupPath -Force
                        Print-Success "Backed up to: $backupPath"
                        Remove-Item $opencodeJsonTarget -Force
                        New-Item -ItemType SymbolicLink -Path $opencodeJsonTarget -Value $opencodeJsonSource -Force | Out-Null
                        Print-Success "Symlinked opencode.json (restore secrets from backup)"
                        Write-Host "    $($Colors.Dim)To restore secrets: review $backupPath$($Colors.Reset)"
                    }
                    "2" {
                        Print-Info "Keeping your existing opencode.json (skipping symlink)"
                    }
                    "3" {
                        Print-Error "Installation aborted by user"
                        return
                    }
                    default {
                        Print-Error "Invalid choice, keeping existing file"
                    }
                }
            } else {
                New-Symlink -Source $opencodeJsonSource -Target $opencodeJsonTarget -Name "OpenCode config"
            }
        } else {
            New-Symlink -Source $opencodeJsonSource -Target $opencodeJsonTarget -Name "OpenCode config"
        }
    } else {
        Print-Warning "opencode.json not found at $opencodeJsonSource"
    }
    
    # Handle agents directory with custom agent detection
    $agentsSource = Join-Path $opencodeConfigSource "agents"
    $agentsTarget = Join-Path $opencodeConfigTarget "agents"
    
    if (Test-Path $agentsSource) {
        if ((Test-Path $agentsTarget) -and -not ((Get-Item $agentsTarget -Force).Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
            Print-Step "Analyzing existing agents directory" "checking for custom agents"
            
            $customAgents = Get-CustomAgents -UserAgentsDir $agentsTarget -RepoAgentsDir $agentsSource
            
            if ($customAgents.Count -gt 0) {
                Print-Warning "Found $($customAgents.Count) custom agent(s) not in repository:"
                foreach ($agent in $customAgents) {
                    Write-Host "    $($Colors.Yellow)• $agent$($Colors.Reset)"
                }
                Write-Host ""
                Write-ColorOutput "Options:" -Color "Cyan"
                Write-Host "  1) Backup and symlink (custom agents preserved in backup)"
                Write-Host "  2) Keep existing agents directory (recommended)"
                Write-Host ""
                $choice = Read-Host "Choose [1-2] (default: 2)"
                if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "2" }
                
                switch ($choice) {
                    "1" {
                        $backupPath = Join-Path $backupSession "agents"
                        Copy-Item $agentsTarget $backupPath -Recurse -Force
                        Print-Success "Backed up agents to: $backupPath"
                        Remove-Item $agentsTarget -Recurse -Force
                        New-Item -ItemType SymbolicLink -Path $agentsTarget -Value $agentsSource -Force | Out-Null
                        Write-Host "    $($Colors.Green)$($Symbols.Link) OpenCode agents$($Colors.Reset) $($Colors.Dim)→ $agentsTarget$($Colors.Reset)"
                        Print-Info "Your custom agents are in: $backupPath"
                    }
                    "2" {
                        Print-Info "Keeping your existing agents directory (skipping symlink)"
                    }
                    default {
                        Print-Error "Invalid choice, keeping existing directory"
                    }
                }
            } else {
                New-Symlink -Source $agentsSource -Target $agentsTarget -Name "OpenCode agents"
            }
        } else {
            New-Symlink -Source $agentsSource -Target $agentsTarget -Name "OpenCode agents"
        }
    } else {
        Print-Warning "agents directory not found at $agentsSource"
    }
    
    # Handle other configuration items (commands, etc.)
    Print-Step "Symlinking additional OpenCode configuration" "commands and other files"
    
    $items = Get-ChildItem $opencodeConfigSource -ErrorAction SilentlyContinue
    foreach ($item in $items) {
        $itemName = $item.Name
        $itemTarget = Join-Path $opencodeConfigTarget $itemName
        
        # Skip already processed items
        if ($itemName -eq "opencode.json" -or $itemName -eq "agents") {
            continue
        }
        
        if ($item.PSIsContainer) {
            New-Symlink -Source $item.FullName -Target $itemTarget -Name "OpenCode $itemName"
        } else {
            New-Symlink -Source $item.FullName -Target $itemTarget -Name "OpenCode $itemName"
        }
    }
    
    # Show backup session summary
    Write-Host ""
    $backupContents = Get-ChildItem $backupSession -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "info.txt" }
    if ($backupContents) {
        Print-Info "Backups created in: $backupSession"
        Write-Host "    $($Colors.Dim)To restore: copy backups from this directory to $opencodeConfigTarget$($Colors.Reset)"
    } else {
        Remove-Item $backupSession -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $opencodeConfigTarget ".backups") -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host ""
    Print-Success "OpenCode installation and configuration complete!"
}

function Print-InstallationSummary {
    Write-Host ""
    Write-ColorOutput "╔══════════════════════════════════════════════════════════════════════════════════════╗" -Color "Magenta"
    Write-ColorOutput "║  🎉 INSTALLATION COMPLETE! 🎉" -Color "Green"
    Write-ColorOutput "╚══════════════════════════════════════════════════════════════════════════════════════╝" -Color "Magenta"
    Write-Host ""
    Write-ColorOutput "📋 Installation Summary:" -Color "Cyan"
    Write-Host "$($Symbols.CheckMark) Build tools installed (MinGW, CMake)"
    Write-Host "$($Symbols.CheckMark) Dotfiles linked (.ripgreprc, scooter config)"
    Write-Host "$($Symbols.CheckMark) Neovim installed and configured"
    Write-Host "$($Symbols.CheckMark) Windows Terminal installed and configured"
    Write-Host "$($Symbols.CheckMark) Oh My Posh installed with TokyoNight theme"
    Write-Host "$($Symbols.CheckMark) CLI tools installed (fzf, ripgrep, bat, git, lazygit)"
    Write-Host "$($Symbols.CheckMark) UV/UVX installed for MCP plugins"
    Write-Host "$($Symbols.CheckMark) Lazygit installed and configured"
    Write-Host "$($Symbols.CheckMark) OpenCode installed and configured"
    Write-Host ""
    Write-ColorOutput "🚀 Next Steps:" -Color "Yellow"
    Write-Host "1. Restart your PowerShell session or run: . `$PROFILE"
    Write-Host "2. Launch Windows Terminal (search 'Windows Terminal' in Start Menu)"
    Write-Host "3. Run 'nvim' to start Neovim and let plugins install"
    Write-Host "4. In Neovim, run ':Tutorial' to start the interactive tutorial"
    Write-Host "5. Configure your language servers as needed"
    Write-Host ""
    Write-ColorOutput "💡 Useful Tips:" -Color "Blue"
    Write-Host "• Enable Developer Mode in Windows Settings for better symlink support"
    Write-Host "• Set Windows Terminal as your default terminal in Windows Settings"
    Write-Host "• Install PowerShell 7+ for better experience: scoop install pwsh"
    Write-Host ""
    Write-ColorOutput "🎊 Happy coding with NairoVIM on Windows! 🎊" -Color "Green"
    Write-Host ""
}

# ======================================================================
# MAIN EXECUTION
# ======================================================================

function Main {
    # Print welcome header
    Print-Header "🚀 NairoVIM Installation Script for Windows 🚀"
    
    Write-ColorOutput "Welcome to the NairoVIM installation script for Windows!" -Color "Cyan"
    Write-Host "$($Colors.Dim)This script will install and configure your complete development environment.$($Colors.Reset)"
    Write-Host ""
    
    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Print-Error "PowerShell 5.1 or later is required. Current version: $($PSVersionTable.PSVersion)"
        exit 1
    }
    
    # Check for admin privileges (warn but don't require)
    if (-not (Test-AdminPrivileges)) {
        Print-Warning "Not running as administrator. Some features may require elevation."
        Print-Info "Consider enabling Developer Mode in Windows Settings for better symlink support."
        Write-Host ""
    }
    
    # Check prerequisites
    Print-Step "Checking prerequisites" "Scoop package manager"
    
    # Start installation process
    Write-Host ""
    Write-ColorOutput "🔧 Starting installation process..." -Color "Cyan"
    
    # Execute installation steps
    Install-Scoop
    Install-BuildTools
    Install-Dotfiles
    Install-Neovim
    Install-WindowsTerminal
    Install-OhMyPosh
    Install-CLITools
    Install-UV
    Install-Lazygit
    Install-OpenCode
    
    # Print final summary
    Print-InstallationSummary
}

# ======================================================================
# ERROR HANDLING & CLEANUP
# ======================================================================

trap {
    Write-Host ""
    Print-Error "Installation interrupted or failed: $_"
    Write-ColorOutput "Please check the error messages above and try again." -Color "Yellow"
    Write-Host ""
    Write-ColorOutput "Need help? Check the documentation or open an issue on GitHub." -Color "Blue"
    exit 1
}

# ======================================================================
# SCRIPT ENTRY POINT
# ======================================================================

# Run main function
Main
