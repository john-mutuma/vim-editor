##  _          _ _       
## | |__   ___| | | ___  
## | '_ \ / _ \ | |/ _ \ 
## | | | |  __/ | | (_) |
## |_| |_|\___|_|_|\___/ 

textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 196)
yellow=$(tput setaf 226)
green=$(tput setaf 118)
cyan=$(tput setaf 87)

# DOTFILES
#
echo "${cyan}  Linking dotfiles ${textreset}"
echo "    zshrc ${green}${textreset}"
ln -sf $(pwd)/.zshrc ~/.zshrc
echo "    vimrc ${green}${textreset}"
ln -sf $(pwd)/.vimrc ~/.vimrc
echo "    tmux.conf ${green}${textreset}"
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
echo "${green}󰄸  Done ${textreset} - Linked dotfiles\n"

# NEOVIM
#
echo "${cyan}  Installing neovim ${textreset}"
brew install --quiet neovim
echo "${green}󰄸  Done ${textreset} - Installed neovim"
# neovim config dir
echo "${cyan}  Linking nvim configuration ${textreset}"

NVIM_DIR=~/.config/nvim
if [ -d $NVIM_DIR ]; then
  echo "${yellow}  nvim config already exists. Removing.${textreset}"
  rm -rf $NVIM_DIR
fi
ln -sf $(pwd)/v2/nvim $NVIM_DIR
echo "${green}󰄸  Done ${textreset} - Linked nvim config to ~/.config/nvim\n"


# TMUX
#
echo "${cyan}  Installing tmux ${textreset}"
brew install --quiet tmux
echo "${green}󰄸  Done ${textreset} - Installed tmux"
# TMUX Plugin Manager
echo "${cyan}  Setting up Tmux Plugin Manager TMP${textreset}"
TMUX_DIR=~/.tmux/plugins/tpm

if [ -d "${TMUX_DIR}" ]; then
  echo "${yellow} TMP already exists.${textreset}\n"
else
  git clone https://github.com/tmux-plugins/tpm ${TMUX_DIR}
  echo "${green}󰄸  Done ${textreset} - Setup TMP\n"
fi

# OH MY ZSH
#
echo "${cyan}  Installing oh-my-zsh ${textreset}"

OH_MY_ZSH_DIR=~/.oh-my-zsh

if [ -d "${OH_MY_ZSH_DIR}" ]; then
  echo "${yellow}  oh-my-zsh already exists.${textreset}\n"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "${green}󰄸  Done ${textreset} - Installed oh-my-zsh. You might want to consider a theme like powerlevel10k.\n"
fi

# FZF, ripgrep, bat
# FZF
echo "${cyan}  Installing FZF (Terminal fuzzy finder) ${textreset}"
brew install --quiet fzf
echo "${green}󰄸  Done ${textreset} - Installed FZF"
# ripgrep
echo "${cyan}  Installing ripgrep (FZF's companion) ${textreset}"
brew install --quiet ripgrep
echo "${green}󰄸  Done ${textreset} - Installed ripgrep\n"
# bat
echo "${cyan}  Installing bat (cat with syntax hightlighting) ${textreset}"
brew install --quiet bat
echo "${green}󰄸  Done ${textreset} - Installed bat\n"

# LAZYGIT
#
# install lazygit
echo "${cyan}  Installing lazygit ${textreset}"
brew install --quiet jesseduffield/lazygit/lazygit
brew link lazygit
# lazygit config dir
echo "${cyan}  Setting up lazygit config ${textreset}"
ln -sf $(pwd)/lazygit_config.yml ~/.config/lazygit/config.yml
export CONFIG_DIR="$HOME/.config/lazygit"
echo "${green}󰄸  Done ${textreset} - Installed lazygit and setup it's config\n"

## Finish
echo "${green}  FINISHED! ${textreset} Run tmux & nvim and Enjoy!"

