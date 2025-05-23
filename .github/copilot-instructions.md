# NairoVIM Copilot Instructions

## Code Generation Instructions

- Always use Lua when generating code.
- We use lazy.nvim to install neovim plugins.

## Pull Requests and Commit  Message Format

### Instructions for commit messages for plugin update with lazy.nvim

- When creating a commit messages title for lazy-lock.json file, include a timestamp
  in the format YYYY-MM-DD in the title. The title should be prefixed with `chore(update-plugins):`
- Also note the packages updated in the commit message body.
- Refer to the lazy-lock.json file for the packages updated.

### Instructions for Pull Requests title and description

When creating a pull request, use the following format for the title:
`YYYY-MM-DD: <Title of the PR>`
In the description, include the following:

```markdown
## What does this PR do?
  - Start with a short paragraph summary of the changes made in the PR
  - Include a list of the changes made in the PR
## Why is it needed?
## How have the changes been tested?
## Screenshots (if applicable)
## Checklist
  - use a checlist format for this section
```
