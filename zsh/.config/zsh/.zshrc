#Enviroment var
export EDITOR="nvim"
export VISUAL="nvim"
export MYNVIMRC="$HOME/repos/dotfiles/nvim/"
export CDPATH=".:$HOME/repos/dotfiles/nvim/.config/:$HOME/repos/"



#Git prompt stuff
parse_git_dirty(){
    STATUS="$(git status 2> /dev/null)"
    if [[ $? -ne 0 ]]; then printf ""; return; else printf " ["; fi
    if echo "${STATUS}" | grep -c "renamed:"            &> /dev/null; then print " >"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "branch is ahead:"    &> /dev/null; then print " !"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "new file::"          &> /dev/null; then print " +"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "Untracked files:"    &> /dev/null; then print " ?"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "modified:"           &> /dev/null; then print " *"; else printf ""; fi        
    if echo "${STATUS}" | grep -c "deleted:"            &> /dev/null; then print " -"; else printf ""; fi        
    printf " ]"
}

parse_git_branch(){
    #Long form
    git rev-parse --abbrev-ref HEAD 2> /dev/null
    #Short form
    #git rev-parse -abbrev-ref HEAD 2> /dev/null | sed -e 's/.*\/\(.*\)/\1/'
}

PROMPT='%B%F{003}  %B%F{015}%~%B%F{006} 󰅂%b%F{015} '











