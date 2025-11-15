----------------------------------------------------------------------
-- Lesson 2: Text Editing Fundamentals
----------------------------------------------------------------------
-- Learn essential text editing operations in Neovim
----------------------------------------------------------------------

return {
    id = "02_editing",
    title = "Text Editing Fundamentals",
    description = "Master insert mode, text manipulation, and file saving",
    difficulty = "beginner",
    duration = "5 min",

    steps = {
        {
            id = "insert_mode",
            title = "Understanding Insert Mode",
            type = "info",
            content = [[
Welcome to Lesson 2: Text Editing!

Neovim has different "modes" for different tasks. So far, you've been in NORMAL mode, which is for navigation and commands.

To edit text, you need to enter INSERT mode. Here are the main ways:

• i - Insert before cursor
• a - Insert after cursor (append)
• o - Insert on new line below
• O - Insert on new line above
• I - Insert at beginning of line
• A - Insert at end of line

🧠 Mnemonics:
   • i = "insert" (most basic)
   • a = "append" (after cursor)
   • o = "open" new line below (lowercase = down)
   • O = "Open" new line above (uppercase = up)
   • I/A = Shift means "go to extreme" (beginning/end of line)

The most common one is 'i' for insert.

Once in insert mode, you'll see "-- INSERT --" at the bottom of the screen, and you can type normally.

Press [Space] to continue.]],
            hint = "Different insert commands place your cursor in different positions",
        },

        {
            id = "exit_insert",
            title = "Exiting Insert Mode",
            type = "info",
            content = [[
To exit insert mode and return to normal mode, you have two options:

• Esc - Traditional way (requires reaching for Escape key)
• jk - NairoVIM shortcut (much faster!)

🧠 Mnemonic: jk = "just kidding" (I'm done typing)
   Your fingers are already on home row for j and k!
   Think: "I'm jumping back to normal mode"

In NairoVIM, typing 'jk' quickly in insert mode will exit to normal mode. This is much more ergonomic than reaching for Escape.

Try this:
1. Press 'i' to enter insert mode
2. Type some text
3. Type 'jk' quickly to exit back to normal mode

The 'jk' combination is one of NairoVIM's quality-of-life improvements that makes editing much faster!

Press [Space] when you're ready to continue.]],
            hint = "jk = 'just kidding' (I'm done editing!)",
        },

        {
            id = "undo_redo",
            title = "Undo and Redo",
            type = "info",
            content = [[
Making mistakes is part of editing. Fortunately, Neovim has powerful undo/redo:

• u - Undo last change
• Ctrl+r - Redo (undo the undo)

🧠 Mnemonics:
   • u = "undo" (simple!)
   • Ctrl+r = "redo" or "restore" change
   Think: u goes backward, Ctrl+r goes forward

You can press 'u' multiple times to undo several changes, and Neovim keeps a complete undo history - even across sessions!

Try it:
1. Press 'i' to enter insert mode
2. Type something
3. Press 'jk' to exit insert mode  
4. Press 'u' to undo your typing
5. Press Ctrl+r to redo it

Press [Space] to continue.]],
            hint = "u for undo, Ctrl+r for redo - practice makes perfect!",
        },

        {
            id = "visual_mode",
            title = "Visual Mode (Selecting Text)",
            type = "info",
            content = [[
To select text in Neovim, you use VISUAL mode:

• v - Visual mode (character-wise selection)
• V - Visual line mode (select entire lines)
• Ctrl+v - Visual block mode (rectangular selection)

🧠 Mnemonics:
   • v = "visual" (lowercase = character selection)
   • V = "Visual" (uppercase = select whole lines)
   • Ctrl+v = extra powerful = block/rectangular selection

Once in visual mode:
• Use h/j/k/l to expand selection
• Press y to yank (copy)
• Press d to delete (cut)
• Press c to change (delete and enter insert mode)
• Press Esc or jk to exit visual mode

🧠 Action mnemonics:
   • y = "yank" (vim's word for copy)
   • d = "delete" (cut)
   • c = "change" (delete then insert)

Visual mode is incredibly powerful for working with text blocks.

Try selecting some text:
1. Press 'v' to enter visual mode
2. Move with j/k to select lines
3. Press 'y' to copy (yank)
4. Move somewhere else  
5. Press 'p' to paste

Press [Space] to continue.]],
            hint = "v for visual, V for visual line - then use movements to select",
        },

        {
            id = "saving_files",
            title = "Saving Files",
            type = "info",
            content = [[
In NairoVIM, saving files is easy:

• <leader>ww - Save current file (leader is comma ',')
• <leader>w<CR> - Alternative save command

🧠 Mnemonic: ,ww = "Write Write" (save the file!)
   Double tap makes it fast and hard to mistype

So you can press: , then w then w (three quick presses)

The traditional Vim way is ':w<CR>' but NairoVIM's shortcuts are faster.

To quit:
• <leader>qq - Quit all windows (with confirmation if unsaved)
• <leader>QQ - Force quit all (no save)

🧠 Mnemonic: ,qq = "Quit Quit" (double tap to exit)
   Uppercase QQ = more forceful = no save

Summary with mnemonics:

✓ i/a/o - Insert, Append, Open line
✓ jk - "Just Kidding" (exit insert)
✓ u / Ctrl+r - Undo / Redo
✓ v / V - visual (char), Visual (line)
✓ ,ww - Write Write (save)
✓ ,qq - Quit Quit (exit)

You now know the core editing operations! Press [Space] to complete this lesson.]],
            hint = "Pattern: Double taps (ww, qq) are for common file operations",
        },
    },
}
