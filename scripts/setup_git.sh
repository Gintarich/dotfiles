function setup_git{
    # Configure Git user information
    # Check if git identity already exists (global)
    if git config --global user.name >/dev/null && git config --global user.email >/dev/null; then
      echo "Git user already configured:"
      echo "name:  $(git config --global user.name)"
      echo "email: $(git config --global user.email)"
    else
      echo "CONFIGURING GIT USER"
      git config --global user.email "gintars.briedis@gmail.com"
      git config --global user.name "Gintars Briedis"
    fi
    #For GitHub SSH key setup:
    # 1) Create key only if it doesn't exist
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      ssh-keygen -t ed25519 -C "you@example.com" -f "$HOME/.ssh/id_ed25519" -N ""
    fi
    # 2) Start agent + add key
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"
    # 3) Show public key (copy this to GitHub -> Settings -> SSH and GPG keys)
    cat "$HOME/.ssh/id_ed25519.pub"
}

