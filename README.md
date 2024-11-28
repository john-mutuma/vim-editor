A NICE configuration for NeoVim with a lot of features and plugins to make your development experience better. Get the best of both worlds with NeoVim as a modern IDE.

## Installation

### Prerequisites

#### Automated setup

Find a Release version and download the zip file. Extract the zip file in your desired location,

- in the root directory of the extracted files, run `./install.sh`
- sit back and relax as the script installs all the necessary plugins and configurations
- run `> tmux` and run `> nvim` in your terminal to open NeoVim in a tmux session and start using the IDE
- run `:PackerInstall` in NeoVim to install all the plugins
- choose your favourite theme by running `:colorscheme <theme-name>`

#### Setting up terminal devicons

This will enable Vim/NeoVim to display nerd icons e.g. File Extension icons in the File Explorer

- Download and install a [patched Nerd Font](https://github.com/ryanoasis/nerd-fonts)
  - such as [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip)
  - ensure that the font installed has nerd devicons - You can use Font Book if using MacOS to check out the installed font
- Open you terminal emulator e.g. ITerm and set the Font Type to the patched font

#### Configuring a mergetool for merge conflicts

Add the following to your `~/.gitconfig` file
This will open a 3-way merge tool in NeoVim when you have merge conflicts. e.g. when opening a conflicted file within lazygit `:LazyGit` UI

```
[core]
	editor = nvim
[merge]
  tool = nvim
[mergetool "nvim"]
  cmd = nvim -c "DiffviewOpen"
[mergetool]
  prompt = false
```

## Useful keyboard mappings/shortcuts and useful commands to use the IDE

### Normal mode

- `<C-n>` - Toggle File Explorer
- `<leader>tr` - Toggle right panel
- `<leader>DD` - Toggle dark theme
- `<leader>LL` - Toggle light theme
- `<leader>G` - open embedded lazygit
- `<C-p>` - Searches MRU files with CtrlP
- `<C-F>f` - Searches git files with `:CocCommand fzf-preview.GitFiles`,. mnemonic: Find files
- `<C-F>Y` - Searches git branches with `:CocCommand fzf-preview.GitBranches`,. mnemonic: Find Y (branch sign)
- `<C-F>b` - Searches recently opened buffers,. mnemonic: Find buffers
- `gd` - Go to Definition
- `gi` - Go to Implementation
- `gR` - Go to References
- `j` - Cursor down a line
- `k` - Cursor up a line
- `gq` - Quit current buffer
- `<C-T>o` - Quit all tabs except current
- `<C-W>o` - Quit all window in current tab except current window

### Commands

- `:LazyGit` - open embedded lazygit
- `:G` - open vim-fugitive git status window. A git repo alternatively to lazygit
- `:colorscheme <Tab><Tab>` - choose your favourite theme
- `:CtrlP <Tab><Tab>` - CtrlP commands e.g. search MRU files
- `:<Tab><Tab>` - see all available commands

## Screenshots (carbonfox colorscheme)

Definitions and References provided by language servers
<img width="1792" alt="Screenshot 2021-11-11 at 19 09 49" src="./examples/Workspace3.png">

Embedded lazygit view

<img width="1792" alt="Screenshot 2021-11-11 at 19 09 49" src="./examples/Workspace4.png">

## Advanced

Once you get comfortable and excited, let's go,

#### Working with Language Servers, Debuggers and Linters

- Run `:Mason` and find and install some LSP extensions and Linters you might want
  - Configure the LSP and Linters with lspconfig
- Find Coc.nvim extensions that you might like e.g. `CocInstall coc-eslint`
- Learn to use nvim-dap

### Setting up italic text in iTerm2

Follow the instructions
https://weibeld.net/terminals-and-shells/italics.html

```
.oPYo.                    8     o                         88 88 88
8    8                    8     8                         88 88 88
8      .oPYo. .oPYo. .oPYo8    o8P .oPYo.   .oPYo. .oPYo. 88 88 88
8   oo 8    8 8    8 8    8     8  8    8   8    8 8    8 88 88 88
8    8 8    8 8    8 8    8     8  8    8   8    8 8    8 `' `' `'
`YooP8 `YooP' `YooP' `YooP'     8  `YooP'   `YooP8 `YooP' 88 88 88
:....8 :.....::.....::.....:::::..::.....::::....8 :.....:.........
:::::8 :::::::::::::::::::::::::::::::::::::::ooP'.::::::::::::::::
:::::..:::::::::::::::::::::::::::::::::::::::...::::::::::::::::::
```
