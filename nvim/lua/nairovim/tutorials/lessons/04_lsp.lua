----------------------------------------------------------------------
-- Lesson 4: LSP & Code Intelligence
----------------------------------------------------------------------
-- Master Language Server Protocol features for professional coding
----------------------------------------------------------------------

return {
    id = "04_lsp",
    title = "LSP & Code Intelligence",
    description = "Learn to use Language Server Protocol for intelligent code navigation and refactoring",
    difficulty = "intermediate",
    duration = "10 min",

    steps = {
        {
            id = "lsp_intro",
            title = "Introduction to LSP",
            type = "info",
            content = [[
Welcome to Lesson 4: LSP & Code Intelligence!

LSP (Language Server Protocol) is what makes NairoVIM feel like a full IDE. 

It provides:

• Go to definition - Jump to where functions/variables are defined
• Find references - See everywhere a symbol is used
• Hover documentation - View function signatures and docs
• Code actions - Quick fixes and refactorings
• Rename symbols - Safely rename across your entire project
• Diagnostics - Real-time error and warning detection

LSP works with 20+ languages including TypeScript, Python, Rust, Go, Java, and more.

Think of LSP as having an expert assistant who knows your entire codebase!

Press [Space] to continue.]],
            hint = "LSP transforms Neovim into a true IDE",
        },

        {
            id = "go_to_definition",
            title = "Go to Definition",
            type = "info",
            content = [[
The most-used LSP feature: jumping to where code is defined.

Key commands:
• gd - Go to definition
• gD - Go to declaration
• gi - Go to implementation

🧠 Mnemonics: The "g" commands are all "Go" or "Goto"
   • gd = "Go Definition" (most common)
   • gD = "Go Declaration" (uppercase = higher level)
   • gi = "Go Implementation" (where it's actually coded)
   Pattern: g + letter = navigation commands!

---

How it works:
1. Position your cursor on any function, variable, or class
2. Press 'gd' (just type g then d)
3. NairoVIM instantly jumps to the definition
4. Press Ctrl+o to jump back to where you were

This works across files, across folders, even in node_modules!

Example workflow:
- See a function call you don't understand?
- Press 'gd' to see how it's implemented
- Press Ctrl+o to return to your code

This is 10x faster than manually searching for definitions.

Press [Space] to continue.]],
            hint = "gd is your teleportation key - use it constantly!",
        },

        {
            id = "find_references",
            title = "Find All References",
            type = "info",
            content = [[
Want to see everywhere a function or variable is used? 

Use Find References!

Key command:
• gR - Find all references (opens in Telescope)

🧠 Mnemonic: gR = "Go References" or "Get References"
   Uppercase R = important/powerful (shows ALL usages)
   Continues the "g" pattern: gd, gR, gi all start with g!

---

This shows you:
• Every file that uses this symbol
• The exact line numbers
• Preview of the code context

Perfect for:
• Understanding how a function is used
• Finding all call sites before refactoring
• Tracking down where variables are modified
• Code review and impact analysis

Workflow:
1. Place cursor on any symbol (function, variable, class)
2. Press 'gR' (g then Shift+r)
3. See all usages in Telescope picker
4. Navigate with j/k, press Enter to jump to any usage

Pro tip: Use this before renaming anything to understand the impact!

Press [Space] to continue.]],
            hint = "gR shows the big picture of where code is used",
        },

        {
            id = "hover_docs",
            title = "Hover Documentation",
            type = "info",
            content = [[
Need quick info about a function? 

Hover documentation shows you!

Key command:
• K - Show hover documentation (that's Shift+k)

🧠 Mnemonic: K = "Knowledge" about the code
   Single uppercase letter = super important and easy to remember
   Think: "What do I need to Know about this?"

---

This displays:
• Function signatures (parameters and return types)
• Parameter descriptions
• Type information
• Usage examples
• Links to full documentation

Two ways to use it:
1. Press 'K' once to open the hover window
2. Press 'K' again to jump into the window and scroll
3. Press 'q' to close it

Pro workflow:
- Not sure what parameters a function takes? Press 'K'
- Want to know a variable's type? Press 'K'
- Need a quick reminder of an API? Press 'K'

This saves countless trips to documentation websites!

Press [Space] to continue.]],
            hint = "K is your instant documentation lookup",
        },

        {
            id = "code_actions",
            title = "Code Actions & Quick Fixes",
            type = "info",
            content = [[
See a squiggly line under your code? 

LSP has quick fixes!

Key command:
• ,ca - Show code actions

🧠 Mnemonic: ,ca = "Code Actions" (exact match!)
   When you see errors, think "I need code actions to fix this"

---

Code actions provide:
• Quick fixes for errors
• Import missing modules automatically
• Extract functions/variables
• Add missing type annotations
• Implement interface methods
• Generate boilerplate code

How to use:
1. Position cursor on a diagnostic (error/warning)
2. Press ',ca' (comma, then c, then a)
3. See available actions in a menu
4. Select one with j/k, press Enter

Example situations:
- Red squiggly? Press ,ca for fixes
- Missing import? Press ,ca to auto-import
- Want to extract code? Press ,ca for refactorings

This is like having an AI pair programmer suggesting fixes!

Press [Space] to continue.]],
            hint = "Code actions = instant fixes for common problems",
        },

        {
            id = "rename_symbol",
            title = "Rename Symbols Safely",
            type = "info",
            content = [[
Need to rename a variable, function, or class? 

LSP handles it across your entire project!

Key command:
• ,rn - Rename symbol

🧠 Mnemonic: ,rn = "ReName" (perfect match!)
   Think: "I want to rename this everywhere"

---

What it does:
• Finds ALL occurrences (not just text matches)
• Renames across all files
• Preserves code structure
• Updates imports/exports
• Semantic-aware (won't rename unrelated text)

Safe rename workflow:
1. Press 'gR' to see all references (optional check)
2. Press ',rn' to start rename
3. Type the new name
4. Press Enter
5. All occurrences updated instantly!

Example:
- Renaming 'oldFunctionName' to 'newFunctionName'
- LSP updates all 47 call sites across 12 files
- Even updates JSDoc comments and imports
- All in 1 second!

This is infinitely safer than find & replace!

Press [Space] to continue.]],
            hint = "Rename with confidence - LSP knows your whole codebase",
        },

        {
            id = "diagnostics",
            title = "Navigate Diagnostics (Errors & Warnings)",
            type = "info",
            content = [[
LSP shows errors and warnings in real-time. 

Navigate them efficiently!

Key commands:
• ]e - Jump to next diagnostic
• [e - Jump to previous diagnostic
• ,ca - Quick fix current diagnostic

🧠 Mnemonics:
   • ]e = "next error" (] looks like forward arrow >)
   • [e = "previous error" ([ looks like back arrow <)
   Pattern: [ and ] are always for navigation (prev/next)

---

Visual indicators:
• Red squiggles - Errors
• Yellow squiggles - Warnings
• Blue squiggles - Information
• Gutter signs - Severity indicators

Efficient debugging workflow:
1. Save file (,ww) to trigger LSP check
2. Press ']e' to jump to first error
3. Press 'K' to see error details
4. Press ',ca' to see quick fixes
5. Fix it, then ']e' to next error
6. Repeat until clean!

This catches bugs as you type, not when you compile!

Press [Space] to continue.]],
            hint = "Navigate diagnostics like a pro with ]e and [e",
        },

        {
            id = "lsp_summary",
            title = "LSP Mastery Complete!",
            type = "info",
            content = [[
Congratulations! You now know the essential LSP workflows:

✓ gd - Go Definition

✓ gR - Get References

✓ K - Knowledge (hover docs)

✓ ,ca - Code Actions

✓ ,rn - ReName

✓ ]e / [e - Next/Previous Error

🧠 Master Patterns:
   • All "g" commands = Go/navigation (gd, gR, gi)
   • Single capital K = Knowledge about code
   • Bracket navigation: ]e next, [e previous
   • Leader commands are words: ca=Code Actions, rn=ReName

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Pro tips:
• Use 'gd' constantly - it's faster than searching
• Check 'gR' before major refactors
• Press 'K' when you're unsure about code
• Trust ',rn' for renames (it's smarter than find/replace)
• Fix errors as you go with ']e' and ',ca'

Power user combo:
1. gd to understand code
2. gR to see impact
3. ,rn to refactor safely
4. ,ca to fix issues
5. ]e to verify no errors

You're now coding at IDE-level efficiency in the terminal!

Press [Space] to complete this lesson!]],
            hint = "LSP = your secret weapon for professional development",
        },
    },
}
