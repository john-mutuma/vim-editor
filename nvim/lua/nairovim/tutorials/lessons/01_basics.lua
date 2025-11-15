----------------------------------------------------------------------
-- Lesson 1: File Navigation Basics
----------------------------------------------------------------------
-- Learn fundamental file navigation and buffer management
----------------------------------------------------------------------

return {
    id = "01_basics",
    title = "File Navigation Basics",
    description = "Master file exploration and basic navigation in NairoVIM",
    difficulty = "beginner",
    duration = "5 min",

    steps = {
        {
            id = "welcome",
            title = "Welcome to NairoVIM!",
            type = "info",
            content = [[
Welcome to the NairoVIM Interactive Tutorial!

In this first lesson, you'll learn the essential skills for navigating files and projects. We'll cover:

• Opening the file explorer
• Finding files with Telescope
• Switching between buffers
• Basic vim movements

Throughout this tutorial, you'll practice these skills hands-on. Each step will guide you through a specific action, and you'll advance automatically once you complete it.

Ready? Let's get started!

Press [Space] or [n] to continue to the next step.]],
            hint = nil,
        },

        {
            id = "file_explorer",
            title = "Open the File Explorer",
            type = "action",
            content = [[
Let's start by opening the file explorer. NairoVIM uses NvimTree as the file browser.

Key command:
• Ctrl+n - Toggle file explorer

🧠 Mnemonic: Ctrl+n = "Navigator" or "Nvim tree"

---

The file explorer will appear on the left side of your screen, showing your project's 
directory structure. 

You can navigate it with j/k (down/up) and press Enter to open files.

Try it now: Press <C-n> (Ctrl+n)]],
            hint = "Ctrl+n = Navigator (think: file Navigator)",
        },

        {
            id = "basic_navigation",
            title = "Basic Vim Movements",
            type = "info",
            content = [[
Great! You've opened the file explorer. 

Notice how you can use these keys to move around:

Movement keys:
• j - Move down
• k - Move up  
• h - Move left (or collapse folder)
• l - Move right (or expand folder)

🧠 Mnemonic: h/j/k/l mirrors your keyboard layout!
   Look at your keyboard: h is leftmost, l is rightmost
   j looks like a down arrow (↓), k points up

---

These movement keys work everywhere in Neovim, not just in the file explorer. 

They're fundamental to vim navigation.

File explorer actions:
• Enter - Open file or expand/collapse directory
• Ctrl+n - Close the file explorer

Try navigating up and down with j and k, then press <C-n> to close the explorer 
and continue.]],
            hint = "Use j/k to move, then Ctrl+n to close the explorer",
        },

        {
            id = "telescope_find",
            title = "Find Files with Telescope",
            type = "action",
            content = [[
Now let's learn a faster way to find files: Telescope!

Telescope is a powerful fuzzy finder. Instead of browsing through folders, you can 
type part of a filename and instantly find it.

Key command:
• Ctrl+s f - Find files

🧠 Mnemonic: Ctrl+s = "Search" menu, then:
   • f = "Files"
   • Pattern: All searches start with Ctrl+s!

---

How to use:
• Type to filter files
• Use Ctrl+j/Ctrl+k (or arrow keys) to navigate results  
• Press Enter to open a file
• Press Esc to cancel

Try it now: Press <C-s>f (Ctrl+s, then f)]],
            hint = "Ctrl+s f = Search Files (easy to remember!)",
        },

        {
            id = "buffer_switch",
            title = "Switch Between Buffers",
            type = "info",
            content = [[
Excellent! In Neovim, when you open multiple files, they're stored as "buffers."

Key command:
• Ctrl+s b - Switch buffers

🧠 Mnemonic: Same pattern! Ctrl+s b = "Search Buffers"
   Notice: Ctrl+s f (Files), Ctrl+s b (Buffers), Ctrl+s s (String search)
   The Ctrl+s prefix means "I want to search for something!"

---

How to use:
• Use j/k or Ctrl+j/Ctrl+k to navigate
• Press Enter to switch to a buffer

Let's try this in the next lesson when you have multiple files open.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

LESSON COMPLETE! Here's what you learned:

✓ <C-n> - Navigator (file tree)

✓ j/k/h/l - Keyboard layout (hjkl in a row)

✓ <C-s>f - Search Files

✓ <C-s>b - Search Buffers

Press [Space] to complete this lesson!]],
            hint = "Pattern recognition: Ctrl+s = Search! (f=Files, b=Buffers)",
        },
    },
}
