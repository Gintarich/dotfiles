# Set the directory of zshell plugin manager ZINIT https://youtu.be/ud7YxC33Z3w?si=6qUIZi_JZ7fyAN0p
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
# Source zinit
source "${ZINIT_HOME}/zinit.zsh"
##--zinit setup--
#zvm_config() {
#}
# Add in zsh plugins
zinit light jeffreytse/zsh-vi-mode
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# Add in snippets
zinit snippet OMZP::git
# zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q
# Keybindings
# emacs mode -e
# bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
# If i add space before command, it wont get written to history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# Compleation styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -color $realpath'
#fzf
source <(fzf --zsh)


#Enviroment var
export EDITOR="nvim"
export VISUAL="nvim"
export MYNVIMRC="$HOME/repos/dotfiles/nvim/"
export CDPATH=".:$HOME/.config/:$HOME/personal/dev/dotfiles/"
#VI MODE
# bindkey -v
# export KEYTIMEOUT=1
#precmd() {print ""}
#Some magic for compleation
#autoload -Uz compinit
setopt PROMPT_SUBST
#compinit
#zstyle ':completion:*' menu select

# source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source $HOME/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

#autoload -U compinit && compinit

#----------------------------------ALIASES---------------------------------------------------------------
# EXA  
alias ls='exa --icons --color=always --group-directories-first'
alias ll='exa -alF --icons --color=always --group-directories-first'
alias la='exa -a --icons --color=always --group-directories-first'
alias l='exa -F --icons --color=always --group-directories-first'
alias l.='exa -a | egrep "^\."'
alias lout='killall -u $USER'
alias bt='bluetoothctl connect 00:0A:45:2A:5C:1D'
alias fonts='fc-list --format '%{family}\n' | sort | uniq'
alias reloadwaybar='pkill waybar && hyprctl dispatch exec waybar'
#--------------------------------------------------------------------------------------------------------

#Git prompt stuff
parse_git_dirty() {
    STATUS="$(git status 2> /dev/null)"
    if [[ $? -ne 0 ]]; then printf ""; return; else printf " ["; fi
    if echo "${STATUS}" | grep -c "renamed:" &> /dev/null; then printf " >"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "branch is ahead:" &> /dev/null; then printf " !"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "new file::" &> /dev/null; then printf " +"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "Untracked files:" &> /dev/null; then printf " ?"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "modified:" &> /dev/null; then printf " *"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "deleted:" &> /dev/null; then printf " -"; else printf ""; fi        
    printf " ]"
}

parse_git_branch(){
    #Long form
    GITBRANCH="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    if [[ "$GITBRANCH" ]]; then printf "  $GITBRANCH" ; else printf ""; fi
    #Short form
    #git rev-parse -abbrev-ref HEAD 2> /dev/null | sed -e 's/.*\/\(.*\)/\1/'
}

#PROMPT

PROMPT='%B%F{#3e8fb0}  %B%F{015}%~%B%F{006} 󰅂%B%F{005}$(parse_git_branch)%b%F{015} '
# RPROMPT='%F{003}$(parse_git_branch) %F{015}%T%f' 
RPROMPT='%F{#3e8fb0}$(parse_git_dirty) %F{015}%T%f' 
#CURSOR
# Cursor is a Block:
# echo -e -n "\x1b[\x31 q" # Blinking
# echo -e -n "\x1b[\x32 q" # Steady

# Cursor is a underscore
# echo -e -n "\x1b[\x33 q" # Blinking
# echo -e -n "\x1b[\x34 q" # Steady
#
# # Cursor is a vertical line
# echo -e -n "\x1b[\x35 q" # Blinking
# echo -e -n "\x1b[\x36 q" # Steady <-- this was mine

