----------------------------------------------------------------------
-- Lesson 5: AI-Assisted Coding with OpenCode
----------------------------------------------------------------------
-- Master AI-powered development workflows in NairoVIM
----------------------------------------------------------------------

return {
    id = "05_ai",
    title = "AI-Assisted Coding",
    description = "Learn to leverage OpenCode AI for faster, smarter development",
    difficulty = "intermediate",
    duration = "7 min",

    steps = {
        {
            id = "ai_intro",
            title = "Introduction to AI-Assisted Development",
            type = "info",
            content = [[
Welcome to Lesson 5: AI-Assisted Coding!

NairoVIM integrates OpenCode, an AI assistant powered by Claude Sonnet 4, directly into your terminal workflow.

What OpenCode can do:
• Explain complex code in plain English
• Suggest improvements and refactors
• Generate boilerplate code
• Debug issues and suggest fixes
• Answer questions about your codebase
• Provide best practices and patterns

Unlike web-based AI tools, OpenCode:
✓ Works directly in your terminal
✓ Has full context of your files
✓ Integrates seamlessly with Neovim
✓ Preserves your flow (no context switching)
✓ Respects your privacy (direct API calls)

Think of it as having a senior developer pair programming with you!

Press [Space] to continue.]],
            hint = "AI assistance = 10x faster learning and development",
        },

        {
            id = "toggle_opencode",
            title = "Opening OpenCode Terminal",
            type = "info",
            content = [[
Let's start with the basics: opening and closing OpenCode.

Key command:
• <leader>ot (,ot) - Toggle OpenCode terminal

🧠 Mnemonic: ,ot = "Opencode Toggle" (exact match!)
   Pattern: All ,o commands are Opencode AI features
   Think: "I want to open the AI terminal"

How it works:
1. Press ',ot' (comma, then o, then t)
2. OpenCode terminal opens at the bottom
3. You can type questions or commands
4. Press ',ot' again to close it

The terminal layout:
• Takes ~40% of screen (adjustable)
• Has a backdrop to focus your attention
• Persists between sessions
• Beautiful markdown rendering

Try this workflow:
- Press ',ot' to open
- Ask a simple question like "what is LSP?"
- See the response
- Press ',ot' to close

You can have OpenCode open while coding - it won't get in your way!

Press [Space] to continue.]],
            hint = "Toggle with ,ot - your AI assistant is one keypress away",
        },

        {
            id = "ask_about_code",
            title = "Ask About Code",
            type = "info",
            content = [[
The most powerful feature: ask OpenCode about your actual code!

Key commands:
• <leader>oa (,oa) - Ask about code at cursor
• <leader>o+ (,o+) - Add file/selection to context
• <leader>oA (,oA) - Ask general question with context

🧠 Mnemonics:
   • ,oa = "Opencode Ask" (lowercase = quick question)
   • ,oA = "Opencode Ask" (uppercase = bigger question with context)
   • ,o+ = "Opencode Plus" (add more context)
   Pattern: ,o = Opencode, then action letter!

How "Ask about cursor" works:
1. Position cursor on any code
2. Press ',oa' (comma, o, a)
3. OpenCode opens with that code in context
4. Type your question
5. Get AI-powered answer

Example questions:
• "What does this function do?"
• "Why is this async?"
• "What are the side effects?"
• "Can this be optimized?"
• "What's the time complexity?"

The AI sees your code and gives specific answers!

Press [Space] to continue.]],
            hint = "Ask questions about code you don't understand",
        },

        {
            id = "context_management",
            title = "Managing Context",
            type = "info",
            content = [[
OpenCode is smarter when you give it more context!

Key commands:
• <leader>o+ (,o+) - Add current buffer to context
• <leader>o- (,o-) - Remove context
• <leader>oc (,oc) - Clear all context

🧠 Mnemonics:
   • ,o+ = "Opencode Plus" (add more context)
   • ,o- = "Opencode Minus" (remove context)
   • ,oc = "Opencode Clear" (start fresh)
   Think: +/- symbols match their purpose!

Adding context workflow:
1. Open a related file (e.g., the component)
2. Press ',o+' to add it to context
3. Open another file (e.g., the test)
4. Press ',o+' again
5. Now OpenCode knows both files!
6. Ask cross-file questions

Example multi-file question:
"Does the component in file A properly implement the interface in file B?"

Context tips:
• Add up to 3-5 related files
• More context = better answers
• Clear context (,oc) when switching tasks
• Visual selection + ,o+ adds just that code

Press [Space] to continue.]],
            hint = "More context = smarter AI responses",
        },

        {
            id = "explain_code",
            title = "Explain Code Feature",
            type = "info",
            content = [[
Quick explanations without typing questions!

Key command:
• <leader>oe (,oe) - Explain code at cursor

🧠 Mnemonic: ,oe = "Opencode Explain" (perfect match!)
   When confused, think: "I need to Explain this"

This is a shortcut for common questions:
1. Position cursor on complex code
2. Press ',oe' (comma, o, e)
3. OpenCode automatically explains it
4. Get breakdown of what the code does

What you get:
• Plain English explanation
• Purpose of the code
• How it works step-by-step
• Potential gotchas
• Related concepts

Perfect for:
- Reading unfamiliar codebases
- Understanding complex algorithms
- Learning new patterns
- Code review preparation
- Onboarding to new projects

Example: Position on a React useEffect hook, press ',oe', get full explanation of dependencies, cleanup, and side effects.

Press [Space] to continue.]],
            hint = "Need a quick explanation? Press ,oe",
        },

        {
            id = "ai_workflows",
            title = "Effective AI Workflows",
            type = "info",
            content = [[
Here are proven workflows to maximize OpenCode's value:

1. Debug Workflow:
   - See an error? Press ',oa'
   - Ask "Why is this failing?"
   - Get diagnosis and fix suggestions
   - Apply fix, test, repeat

2. Learning Workflow:
   - Encounter new code? Press ',oe'
   - Get explanation
   - Ask follow-ups with ',oA'
   - Build understanding

3. Refactoring Workflow:
   - Select code to refactor
   - Press ',o+' to add context
   - Ask "How can I improve this?"
   - Get suggestions with examples

4. Feature Development:
   - Add relevant files (,o+)
   - Describe what you want to build
   - Get implementation guidance
   - Ask about edge cases

Pro tips:
• Be specific in questions
• Use context for better answers
• Iterate on responses
• Start new session (,on) for different tasks

Press [Space] to continue.]],
            hint = "Use AI strategically - it's a thinking partner, not just a tool",
        },

        {
            id = "ai_summary",
            title = "AI-Assisted Coding Complete!",
            type = "info",
            content = [[
Congratulations! You're now equipped with AI superpowers:

✓ ,ot - Opencode Toggle (terminal)
✓ ,oa - Opencode Ask (quick question)
✓ ,o+ - Opencode Plus (add context)
✓ ,oe - Opencode Explain (explain code)
✓ ,on - Opencode New (new session)
✓ ,oA - Opencode Ask (with context)

🧠 Master Pattern: ALL ,o commands = Opencode AI!
   • t=Toggle, a=Ask, e=Explain, +=Plus context, -=Minus context
   • Lowercase = quick actions, Uppercase = more context/power
   • Remember just ",o" and the rest flows naturally!

Best practices:
• Use AI to learn, not just copy
• Ask "why" questions, not just "how"
• Build context for complex questions
• Verify AI suggestions before applying
• Use it to explore alternatives

AI workflow integration:
1. LSP (gd, gR) - Navigate code
2. AI (,oa) - Understand code
3. LSP (,rn, ,ca) - Refactor code
4. AI (,o+, ,oA) - Validate changes

You now have a senior developer available 24/7 in your terminal!

Remember: AI is a tool to amplify your skills, not replace thinking.

Press [Space] to complete this lesson!]],
            hint = "AI + LSP = unstoppable development velocity",
        },
    },
}
