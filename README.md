A NICE configuration for NeoVim with a lot of features and plugins to make your development experience better. Get the best of both worlds with NeoVim as a modern IDE.

## Installation

Find a Release version and download the zip file. Extract the zip file in your desired location,

- in the root directory of the extracted files, run `./install.sh`
- sit back and relax as the script installs all the necessary plugins and configurations
- run `> tmux` and run `> nvim` in your terminal to open NeoVim in a tmux session and start using the IDE

### Installation of Neovim plugins

- run `:PackerInstall` in NeoVim to install all the plugins
- install your favourite Coc.nvim extensions e.g. `CocInstall coc-eslint`, `CocInstall coc-prettier` etc
- choose your favourite theme by running `:colorscheme <theme-name>`

### Setting up terminal devicons

This will enable Vim/NeoVim to display nerd icons e.g. File Extension icons on `nvim-tree` or NERDTree etc.

- Download and install a [patched Nerd Font](https://github.com/ryanoasis/nerd-fonts)
  - such as [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip)
  - ensure that the font installed has nerd devicons - You can use Font Book if using MacOS to check out the installed font
- Open you terminal emulator e.g. ITerm and set the Font Type to the patched font

### Useful keyboard mappings/shortcuts to use the IDE

#### Normal mode

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
- `<Space>c` - Searches Coc.nvim commands with `:CocCommand`

## Screenshots (carbonfox colorscheme)

Definitions and References provided by language servers
<img width="1792" alt="Screenshot 2021-11-11 at 19 09 49" src="./examples/Workspace3.png">

Embedded lazygit view

<img width="1792" alt="Screenshot 2021-11-11 at 19 09 49" src="./examples/Workspace4.png">

## Other tips

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
