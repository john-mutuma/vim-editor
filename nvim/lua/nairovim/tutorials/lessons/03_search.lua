----------------------------------------------------------------------
-- Lesson 3: Search & Find Operations
----------------------------------------------------------------------
-- Master searching files, text, and using find & replace
----------------------------------------------------------------------

return {
    id = "03_search",
    title = "Search & Find Operations",
    description = "Learn to search files, text content, and perform find & replace",
    difficulty = "beginner",
    duration = "7 min",

    steps = {
        {
            id = "telescope_intro",
            title = "Introduction to Telescope",
            type = "info",
            content = [[
Welcome to Lesson 3: Search & Find!

Telescope is NairoVIM's fuzzy finder - one of the most powerful tools you'll use daily. It helps you quickly find:

• Files in your project
• Text within files (live grep)
• Recently opened files
• Buffers (open files)
• Git branches, commits, and more

Telescope uses fuzzy matching, so you don't need to type the exact name. For example, typing "usmod" might find "user-model.ts".

In this lesson, we'll explore Telescope's core features.

Press [Space] to continue.]],
            hint = "Telescope is your Swiss Army knife for finding things",
        },

        {
            id = "find_files",
            title = "Finding Files",
            type = "info",
            content = [[
The most common search operation is finding files by name.

Key commands:
• <C-s>f (Ctrl+s, then f) - Find files (git files)
• <C-F>f (Ctrl+F, then f) - Alternative with FZF

🧠 Mnemonic: Ctrl+s f = "Search Files"
   Remember the pattern: ALL Ctrl+s commands are searches!

Once the picker opens:
• Type to filter results (fuzzy matching)
• Ctrl+j / Ctrl+k - Navigate down/up
• Ctrl+n / Ctrl+p - Alternative navigation
• Enter - Open selected file
• Esc - Close picker

Try these patterns:
• Type "read" to find "README.md"
• Type "conf" to find config files
• Type "lsp" to find LSP-related files

The fuzzy matching is smart - you can skip letters and it still finds matches!

Press [Space] to continue.]],
            hint = "Ctrl+s f = Search Files (part of the Ctrl+s search family)",
        },

        {
            id = "grep_search",
            title = "Searching Text Content (Live Grep)",
            type = "info",
            content = [[
Finding files is great, but what about searching for specific text inside files?

That's where Live Grep comes in:

• <C-s>s (Ctrl+s, then s) - Search text across entire project

🧠 Mnemonic: Ctrl+s s = "Search String" or "Search Source"
   Double 's' for searching text (like grep)
   Pattern: Ctrl+s f (Files), Ctrl+s s (Strings), Ctrl+s r (Recent)

• Uses ripgrep (extremely fast)
• Searches all files in your project

Example searches:
• Search "function" to find all function definitions
• Search "TODO" to find all todo comments
• Search "import React" to find React imports

The results show:
• Filename
• Line number
• The actual text with your search term highlighted

Press Enter on any result to jump directly to that location in the file!

This is incredibly powerful for code exploration and refactoring.

Press [Space] to continue.]],
            hint = "Ctrl+s s = Search Strings (double s for text search)",
        },

        {
            id = "recent_files",
            title = "Recent Files",
            type = "info",
            content = [[
Working on the same files repeatedly? Use the recent files picker:

• <C-s>r (Ctrl+s, then r) - Show recently opened files

🧠 Mnemonic: Ctrl+s r = "Search Recent"
   Completes the pattern! f=Files, s=Strings, r=Recent, b=Buffers
   All start with Ctrl+s for search!

• Files are sorted by how recently you used them
• Much faster than navigating the file tree

This is perfect for:
• Returning to files you just edited
• Quick context switching
• Reviewing your work session

Combined with Telescope's fuzzy finding, you can type part of any recent filename to filter the list.

Pro tip: Most developers use only 5-10 files intensively during a work session. The recent files picker makes switching between them instant!

Press [Space] to continue.]],
            hint = "Ctrl+s r = Search Recent (part of the Ctrl+s family)",
        },

        {
            id = "find_replace",
            title = "Find & Replace (Scooter)",
            type = "info",
            content = [[
NairoVIM includes a powerful find & replace tool called Scooter.

• <leader>s (,s) - Open Scooter find/replace

🧠 Mnemonic: ,s = "Substitute" or "Search & replace"
   Single 's' with leader = interactive replace tool

• Interactive search and replace across files
• Preview changes before applying
• Supports regex patterns

How to use:
1. Press ,s to open Scooter
2. Enter your search term
3. Enter your replacement term
4. Review the matches
5. Apply changes selectively or to all files

This is much safer than global find/replace because you can:
• See all matches in context
• Choose which to replace
• Preview before committing

Press [Space] to continue.]],
            hint = ",s = Substitute (search and replace with preview)",
        },

        {
            id = "summary",
            title = "Search Mastery Complete!",
            type = "info",
            content = [[
Congratulations! You've learned the essential search operations:

✓ <C-s>f - Search Files (by name)
✓ <C-s>s - Search Strings (text content)
✓ <C-s>r - Search Recent (recently opened)
✓ <C-s>b - Search Buffers (open files)
✓ <leader>s - Substitute (find & replace)

🧠 Master Pattern: Ctrl+s = Search menu!
   f=Files, s=Strings, r=Recent, b=Buffers
   All your searches start with Ctrl+s!

Bonus tip: Clear search highlights
• <leader><CR> (,Enter) - Clear search highlights

These search tools will save you hours of manual navigation. Use them constantly!

Quick workflow example:
1. <C-s>s to search for a function
2. Jump to the file
3. <C-s>f to find related files
4. <C-s>r to return to recent files
5. <leader>s to refactor names across files

You're now equipped with professional-level search skills!

Press [Space] to complete this lesson and see what's next.]],
            hint = "Master these shortcuts and you'll fly through codebases!",
        },
    },
}
