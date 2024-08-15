# parse_git_branch() {
#      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }
# export PS1="\u \[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
alias gits="git status"
alias gca="git commit --amend"
alias tmux="tmux -2"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use node

ZSH_CUSTOM=$HOME/zsh_custom

# git clone https://github.com/reobin/typewritten.git $ZSH_CUSTOM/themes/typewritten
# ln -s "$ZSH_CUSTOM/themes/typewritten/typewritten.zsh-theme" "$ZSH_CUSTOM/themes/typewritten.zsh-theme"
ZSH_THEME="typewritten/typewritten"

set editing-mode vim
set -o vi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
