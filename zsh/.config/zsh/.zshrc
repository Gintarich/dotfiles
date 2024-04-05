#Enviroment var
export EDITOR="nvim"
export VISUAL="nvim"
export MYNVIMRC="$HOME/repos/dotfiles/nvim/"
export CDPATH=".:$HOME/.config/:$HOME/repos/"
#precmd() {print ""}
#Some magic for compleation
autoload -Uz compinit
setopt PROMPT_SUBST
compinit
zstyle ':completion:*' menu select


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

PROMPT='%B%F{003}  %B%F{015}%~%B%F{006} 󰅂%B%F{005}$(parse_git_branch)%b%F{015} '
# RPROMPT='%F{003}$(parse_git_branch) %F{015}%T%f' 
RPROMPT='%F{003}$(parse_git_dirty) %F{015}%T%f' 
#CURSOR
# Cursor is a Block:
# echo -e -n "\x1b[\x31 q" # Blinking
echo -e -n "\x1b[\x32 q" # Steady

# Cursor is a underscore
# echo -e -n "\x1b[\x33 q" # Blinking
# echo -e -n "\x1b[\x34 q" # Steady
#
# # Cursor is a vertical line
# echo -e -n "\x1b[\x35 q" # Blinking
# echo -e -n "\x1b[\x36 q" # Steady










