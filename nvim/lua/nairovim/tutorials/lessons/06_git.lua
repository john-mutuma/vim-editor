----------------------------------------------------------------------
-- Lesson 6: Git Workflow Integration
----------------------------------------------------------------------
-- Master version control without leaving Neovim
----------------------------------------------------------------------

return {
    id = "06_git",
    title = "Git Workflow Integration",
    description = "Learn efficient Git workflows with Lazygit and inline Git features",
    difficulty = "intermediate",
    duration = "8 min",

    steps = {
        {
            id = "git_intro",
            title = "Introduction to Git in NairoVIM",
            type = "info",
            content = [[
Welcome to Lesson 6: Git Workflow!

NairoVIM integrates Git deeply into your workflow with two powerful tools:

1. Lazygit - Full-featured Git UI
   • Stage, commit, push, pull
   • Branch management
   • Conflict resolution
   • Interactive rebase
   • Beautiful diff views

2. Gitsigns - Inline Git features
   • See changes in gutter
   • Stage individual hunks
   • Preview changes
   • Navigate modifications
   • Blame annotations

Why this matters:
• No context switching to terminal
• Visual feedback while coding
• Faster Git operations
• Better understanding of changes
• Professional version control workflows

Let's master Git without leaving your editor!

Press [Space] to continue.]],
            hint = "Git integration = seamless version control",
        },

        {
            id = "lazygit_basics",
            title = "Opening Lazygit",
            type = "info",
            content = [[
Lazygit is your full-featured Git interface inside Neovim.

Key command:
• ,G - Open Lazygit

🧠 Mnemonic: ,G = "Git" (capital G = important!)
   Think: "I need the Git interface"
   Uppercase G means this is THE main Git command

---

What you'll see:
• Status panel - Current changes
• Files panel - Modified files
• Branches panel - Local & remote branches
• Commits panel - Git history
• Stash panel - Stashed changes

Lazygit interface:
• Navigate with j/k (vim-style!)
• Space to stage/unstage files
• c to commit
• P to push
• p to pull
• q to quit

The beauty of Lazygit:
✓ Visual diff viewing
✓ No command memorization
✓ See full context
✓ Undo-friendly
✓ Fast keyboard navigation

Try it:
Press ',G' to open Lazygit, press 'q' to close.

Press [Space] to continue.]],
            hint = "Lazygit = Git made visual and intuitive",
        },

        {
            id = "staging_commits",
            title = "Staging and Committing",
            type = "info",
            content = [[
The core Git workflow: stage changes and commit them.

In Lazygit:
1. Press ',G' to open Lazygit
2. Navigate to Files panel (if not there)
3. Use 'j/k' to select files
4. Press 'Space' to stage/unstage
5. Press 'c' to commit
6. Type commit message
7. Press Enter to confirm
8. Press 'q' to close

Staging options:
• Space - Stage entire file
• a - Stage all files
• d - See detailed diff
• e - Edit file directly

Commit tips:
• First line: brief summary (50 chars)
• Blank line, then details if needed
• Use present tense: "Add feature" not "Added feature"
• Reference issue numbers: "Fix #123"

Pro workflow:
Stage → Review diff → Commit → Push

This is 10x faster than CLI git commands!

Press [Space] to continue.]],
            hint = "Visual staging makes Git commits easier",
        },

        {
            id = "inline_git_signs",
            title = "Inline Git Changes (Gitsigns)",
            type = "info",
            content = [[
See Git changes directly in your code with Gitsigns!

Visual indicators:
• + Green bar - Added lines (in gutter)
• ~ Blue bar - Modified lines
• - Red mark - Deleted lines

Key commands:
• ]c - Jump to next change (hunk)
• [c - Jump to previous change
• ,hp - Preview hunk
• ,hs - Stage hunk
• ,hu - Undo hunk

🧠 Mnemonics:
   • ]c / [c = "next/previous change" (brackets = navigation!)
   • ,hp = "Hunk Preview" (see what changed)
   • ,hs = "Hunk Stage" (stage this change)
   • ,hu = "Hunk Undo" (undo this change)
   Pattern: All ,h commands = Hunk operations!

---

What's a "hunk"?
A hunk is a section of consecutive changes. 

Gitsigns lets you work with individual hunks instead of entire files!

Efficient workflow:
1. Make changes to your code
2. Press ']c' to jump to first change
3. Press ',hp' to preview what changed
4. Press ',hs' to stage if good
5. Press ']c' to move to next change
6. Repeat until all reviewed

This is perfect for:
• Reviewing your own changes
• Staging selectively
• Understanding what you modified

Press [Space] to continue.]],
            hint = "See changes as you code - instant visual feedback",
        },

        {
            id = "git_blame",
            title = "Git Blame - Who Changed This?",
            type = "info",
            content = [[
Ever wonder "who wrote this code?" 

Git blame has the answer!

Key command:
• ,hb - Toggle blame annotations

🧠 Mnemonic: ,hb = "Hunk Blame" or "History Blame"
   Continues the ,h pattern from Gitsigns
   Think: "Who wrote this hunk?"

---

What it shows:
• Who last modified each line
• When it was changed
• Commit message summary
• Commit hash

Use cases:
• Understanding code context
• Finding who to ask about code
• Tracking down when bugs introduced
• Code archaeology
• Collaboration insights

Workflow:
1. Position cursor on mysterious code
2. Press ',hb' to see blame
3. See author and commit
4. Press ',hb' again to hide

Pro tip - Combine with LSP:
1. Use 'gd' to go to definition
2. Use ',hb' to see who wrote it
3. Use ',G' and search commit hash for full context

Blame is not about finger-pointing - it's about understanding code history!

Press [Space] to continue.]],
            hint = "Blame = time travel through code history",
        },

        {
            id = "branch_management",
            title = "Working with Branches",
            type = "info",
            content = [[
Branches are essential for organized development. Lazygit makes them easy!

In Lazygit (press ,G):
• Navigate to Branches panel (usually tab key or '2')
• Press 'n' to create new branch
• Press 'Space' to checkout branch
• Press 'm' to merge branch
• Press 'd' to delete branch

Common workflows:

Feature branch:
1. Press ',G' to open Lazygit
2. Press 'n' for new branch
3. Name it (e.g., "feature/new-ui")
4. Make commits
5. Press 'P' to push
6. Create PR from GitHub/GitLab

Fix branch:
1. Checkout main branch
2. Create hotfix branch
3. Fix bug, commit
4. Merge back to main

Branch tips:
• Use descriptive names
• Keep branches focused
• Delete after merging
• Pull before creating new branches

Press [Space] to continue.]],
            hint = "Branches = parallel universes for your code",
        },

        {
            id = "git_summary",
            title = "Git Workflow Mastery Complete!",
            type = "info",
            content = [[
Congratulations! You're now a Git power user in NairoVIM:

✓ ,G - Git UI (Lazygit)

✓ ]c / [c - Next/Previous Change

✓ ,hp - Hunk Preview

✓ ,hs - Hunk Stage

✓ ,hb - Hunk Blame

✓ ,hu - Hunk Undo

🧠 Master Patterns:
   • ,G = THE Git command (capital = main interface)
   • All ,h commands = Hunk operations (p=Preview, s=Stage, b=Blame, u=Undo)
   • ]c and [c = bracket navigation for changes
   • Remember: ,G for UI, ,h for inline hunk actions!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Professional workflow:
1. Code your changes
2. Navigate hunks with ]c
3. Preview each change (,hp)
4. Stage good hunks (,hs)
5. Open Lazygit (,G)
6. Review staged changes
7. Commit with good message
8. Push to remote (P in Lazygit)

Pro tips:
• Commit often, push regularly
• Review changes before staging
• Use blame to understand context
• Keep commits atomic (one purpose)
• Write meaningful commit messages

Integration with other tools:
• LSP helps write clean code
• AI helps explain changes
• Git tracks the history
• Together = professional workflow

You now have version control mastery!

Press [Space] to complete this lesson!]],
            hint = "Git + NairoVIM = effortless version control",
        },
    },
}
