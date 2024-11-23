##  _          _ _       
## | |__   ___| | | ___  
## | '_ \ / _ \ | |/ _ \ 
## | | | |  __/ | | (_) |
## |_| |_|\___|_|_|\___/ 

textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
yellow=$(tput setaf 2)
green=$(tput setaf 118)
cyan=$(tput setaf 87)

# DOTFILES
#
echo "${cyan}  Linking dotfiles ${textreset}"
echo " zshrc"
ln -sf $(pwd)/.zshrc ~/.zshrc
echo " vimrc"
ln -sf $(pwd)/.vimrc ~/.vimrc
echo " tmux.conf"
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
echo "${green}󰄸  Done ${textreset} - Linked dotfiles\n"

echo "${cyan}  Linking nvim configuration ${textreset}"
ln -sf $(pwd)/v2/nvim ~/.config/nvim
echo "${green}󰄸  Done ${textreset} - Linked nvim config to ~/.config/nvim\n"

# NEOVIM
#
echo "${cyan}  Installing neovim ${textreset}"
brew install neovim
echo "${green}󰄸  Done ${textreset} - Installed neovim\n"

# TMUX
#
echo "${cyan}  Installing tmux ${textreset}"
brew install tmux
echo "${green}󰄸  Done ${textreset} - Installed tmux\n"

# LAZYGIT
#
# install lazygit
echo "${cyan}  Installing lazygit ${textreset}"
brew install jesseduffield/lazygit/lazygit

# lazygit config dir
echo "${cyan}  Setting up lazygit config ${textreset}"
ln -sf $(pwd)/lazygit_config.yml ~/.config/lazygit/config.yml
export CONFIG_DIR="$HOME/.config/lazygit"
echo "${green}󰄸  Done ${textreset} - Installed lazygit and setup it's config\n"

echo "${green}  FINISHED! ${textreset} Run tmux & nvim and Enjoy!"

