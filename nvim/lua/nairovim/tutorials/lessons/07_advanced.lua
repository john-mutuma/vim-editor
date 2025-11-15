----------------------------------------------------------------------
-- Lesson 7: Power User Tips & Advanced Features
----------------------------------------------------------------------
-- Master advanced NairoVIM features and customization
----------------------------------------------------------------------

return {
    id = "07_advanced",
    title = "Power User Tips & Advanced Features",
    description = "Unlock NairoVIM's full potential with advanced techniques and customization",
    difficulty = "advanced",
    duration = "8 min",

    steps = {
        {
            id = "advanced_intro",
            title = "Welcome to Advanced Features!",
            type = "info",
            content = [[
Welcome to Lesson 7: Power User Tips!

You've mastered the fundamentals. Now let's explore advanced features that will make you unstoppable:

• Window management - Split and organize your workspace
• Theme customization - Personalize your environment
• Plugin management - Keep your tools updated
• LSP configuration - Add more languages
• Performance optimization - Keep NairoVIM lightning fast
• Custom keybindings - Make it truly yours

These features separate casual users from power users!

By the end of this lesson, you'll:
✓ Navigate multiple files efficiently
✓ Customize NairoVIM to your preferences
✓ Manage plugins and LSP servers
✓ Know pro tips and tricks
✓ Have a personalized workflow

Ready to level up? Let's dive in!

Press [Space] to continue.]],
            hint = "Advanced features = professional efficiency",
        },

        {
            id = "window_management",
            title = "Window Management & Splits",
            type = "info",
            content = [[
Work with multiple files simultaneously using window splits!

Key commands:
• <leader>F (,F) - Maximize/restore current window
• Ctrl+w s - Split window horizontally
• Ctrl+w v - Split window vertically
• Ctrl+w w - Cycle between windows
• Ctrl+w c - Close current window
• Ctrl+w = - Equalize window sizes

🧠 Mnemonics:
   • ,F = "Focus" or "Fullscreen" (maximize window)
   • Ctrl+w = "Window" command prefix
   • s = "Split" horizontal, v = "Vertical" split
   • w = "Window" cycle, c = "Close", = = "Equalize"

Window navigation:
• Ctrl+w h/j/k/l - Move to left/down/up/right window

Practical workflow:
1. Open a file
2. Press Ctrl+w v for vertical split
3. Open another file (Ctrl+s f)
4. Press ,F to maximize one
5. Press ,F again to restore split

Use cases:
• Component + test side by side
• Implementation + documentation
• Compare two files
• Multi-file refactoring

Pro tip: Use Telescope (Ctrl+s f) in split to open files without closing current view!

Press [Space] to continue.]],
            hint = "Splits = see multiple files at once",
        },

        {
            id = "theme_customization",
            title = "Theme & Appearance",
            type = "info",
            content = [[
Make NairoVIM look exactly how you want!

Built-in themes:
• tokyonight-night (default dark)
• tokyonight-day (light mode)
• catppuccin (pastel colors)
• gruvbox (retro)
• nightfox (blue tones)

Theme commands:
• <leader>DD (,DD) - Switch to dark theme
• <leader>LL (,LL) - Switch to light theme
• :colorscheme <Tab> - Browse all themes

🧠 Mnemonics:
   • ,DD = "Dark Dark" (double D = dark mode)
   • ,LL = "Light Light" (double L = light mode)
   Visual: D looks dark/heavy, L looks light/airy!

Try different themes:
1. Press ':colorscheme ' (with space)
2. Press Tab to see options
3. Use Tab to cycle through
4. Press Enter to apply

Customization tips:
• Dark themes: Better for long sessions
• Light themes: Better in bright environments
• TokyoNight: Best contrast
• Catppuccin: Easy on eyes

Theme persistence:
NairoVIM remembers your choice between sessions!

Press [Space] to continue.]],
            hint = "Find a theme that makes you happy to code",
        },

        {
            id = "plugin_management",
            title = "Managing Plugins",
            type = "info",
            content = [[
Keep your tools up to date with Lazy plugin manager!

Key command:
• :Lazy - Open plugin manager

Lazy interface:
• Shows all installed plugins
• Visual status (loaded, lazy-loaded)
• Update notifications
• Plugin descriptions

Common operations:
• U - Update all plugins
• S - Sync (install/clean/update)
• X - Clean unused plugins
• L - View logs
• P - Profile startup time
• C - Check for issues

Update workflow:
1. Type ':Lazy'
2. Press 'U' to update all
3. Wait for downloads
4. Press 'q' to close
5. Restart Neovim

When to update:
• Weekly for stability
• When you see update notifications
• Before reporting issues
• After NairoVIM version updates

Press [Space] to continue.]],
            hint = "Keep plugins updated = fewer bugs",
        },

        {
            id = "lsp_mason",
            title = "Adding Language Servers (Mason)",
            type = "info",
            content = [[
Add LSP support for more programming languages!

Key command:
• :Mason - Open LSP/tool installer

Mason interface shows:
• All available language servers
• Currently installed servers
• Linters, formatters, debuggers

Installing a language server:
1. Type ':Mason'
2. Navigate with j/k
3. Press 'i' on a server to install
4. Press 'X' to uninstall
5. Press 'U' to update
6. Press 'q' to close

Popular language servers:
• typescript-language-server (TS/JS)
• pyright (Python)
• rust-analyzer (Rust)
• gopls (Go)
• lua-language-server (Lua)
• clangd (C/C++)

After installation:
• Close Mason
• Open a file in that language
• LSP activates automatically!
• Use gd, gR, K, etc.

Press [Space] to continue.]],
            hint = "Mason = add language support in seconds",
        },

        {
            id = "performance_tips",
            title = "Performance Optimization",
            type = "info",
            content = [[
Keep NairoVIM fast with these performance tips!

Check startup time:
• :Lazy profile - See plugin load times
• Identify slow plugins
• Disable unused ones

Common optimizations:
1. Disable unused plugins (edit config)
2. Use lazy loading (already configured!)
3. Limit LSP to project files
4. Clear old swap files
5. Reduce undo history if needed

Signs of performance issues:
• Slow typing response
• Laggy cursor movement
• Delayed completions
• High CPU usage

Quick fixes:
• Restart Neovim regularly
• Close unused buffers
• Use :Lazy profile to find culprits
• Disable heavy plugins temporarily

NairoVIM is already optimized:
✓ Lazy-loaded plugins (~40-120ms startup)
✓ Efficient LSP configuration
✓ Smart caching
✓ Optimized themes

Typical startup: < 120ms (very fast!)

Press [Space] to continue.]],
            hint = "Keep it fast - your productivity depends on it",
        },

        {
            id = "pro_tips",
            title = "Pro Tips & Hidden Gems",
            type = "info",
            content = [[
Secret weapons that power users know:

1. Jump List Navigation
   • Ctrl+o - Jump back (older position)
   • Ctrl+i - Jump forward (newer position)
   🧠 o="older", i="in" (forward) - time travel through code!

2. Quick File Switching
   • Ctrl+6 - Toggle between last two files
   🧠 6 key is Shift+^ which means "alternate file"

3. Visual Block Mode
   • Ctrl+v - Select rectangular blocks
   🧠 v=Visual, Ctrl+v=super Visual (blocks!)

4. Global Marks
   • mA - Set global mark A
   • 'A - Jump to mark A (even other files!)
   🧠 Uppercase marks = global (cross-file)

5. Command History
   • q: - Open command history
   🧠 q with : = query command history

6. Macro Recording
   • qa - Start recording to register 'a'
   • q - Stop recording
   • @a - Replay macro
   🧠 q=record, @=execute (@ means "at" this register)

Press [Space] to continue.]],
            hint = "Master these for 10x productivity boost",
        },

        {
            id = "advanced_summary",
            title = "Power User Status Achieved!",
            type = "info",
            content = [[
🎉 Congratulations! You've completed all NairoVIM tutorials!

You've mastered:
✓ Lesson 1: File navigation basics
✓ Lesson 2: Text editing fundamentals
✓ Lesson 3: Search & find operations
✓ Lesson 4: LSP & code intelligence
✓ Lesson 5: AI-assisted coding
✓ Lesson 6: Git workflow integration
✓ Lesson 7: Power user tips

You now have skills to:
• Navigate codebases instantly (LSP + Telescope)
• Code with AI assistance (OpenCode)
• Manage Git like a pro (Lazygit + Gitsigns)
• Customize your environment (themes, plugins)
• Work at professional velocity

🧠 MASTER MNEMONIC PATTERNS:
   • Ctrl+s = Search (f=Files, s=Strings, r=Recent, b=Buffers)
   • g commands = Go/navigation (gd=Definition, gR=References)
   • ,o commands = Opencode AI (ot=Toggle, oa=Ask, oe=Explain)
   • ,h commands = Hunk/Git operations (hp=Preview, hs=Stage, hb=Blame)
   • [ and ] = Previous/Next navigation
   • K = Knowledge (hover docs)
   • ,ca = Code Actions, ,rn = ReName, ,G = Git

The complete toolkit with mnemonics:
• Search: Ctrl+s f (Files), Ctrl+s s (Strings), Ctrl+s r (Recent)
• LSP: gd (Go Definition), gR (Get References), K (Knowledge)
• AI: ,ot (Opencode Toggle), ,oa (Ask), ,oe (Explain)
• Git: ,G (Git UI), ,hp (Hunk Preview), ,hs (Hunk Stage)
• Power: ,F (Focus/maximize), ,ww (Write Write), ,qq (Quit Quit)

You're not just using Neovim - you're mastering it!

Keep practicing, explore more, and build amazing things.

Welcome to the NairoVIM power user club! 🚀

Press [Space] to complete all tutorials!]],
            hint = "You're now equipped for professional development!",
        },
    },
}
