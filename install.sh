#!/bin/bash

# Set the dotfiles directory to the directory of this install script.
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create a backup, up to two levels (.bak.bak).
backup_file() {
    if [ -L "$1" ]; then
        echo "Replacing symlink $1"
        rm "$1"
    fi
    if [ -e "$1" ]; then
        if [ -e "$1.bak" ]; then
            echo "Backing up $1.bak"
            mv "$1.bak" "$1.bak.bak"
        fi
        echo "Backing up $1"
        mv "$1" "$1.bak"
    fi
}

# Create symlinks and backup existing files
create_symlink() {
    file="$1"
    target="$HOME/$file"
    backup_file "$target"
    ln -s "$dotfiles_dir/$file" "$target"
}

sudo apt-get update -qq && sudo apt-get install -y --no-install-recommends -qq zsh fish trash-cli

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
fi

# Install git completion
if [ ! -f "$HOME/.git-completion.bash" ]; then
    echo "Installing git completion..."
    curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
fi

# Install git transcrypt
if [ ! -d "$HOME/git-transcrypt" ]; then
    # Prereqs
    sudo apt-get install -y --no-install-recommends -qq xxd
    git clone https://github.com/elasticdog/transcrypt.git ~/git-transcrypt
    mkdir -p "$HOME/.local/bin"
    target="$HOME/.local/bin/git-transcrypt"
    backup_file "$target"
    ln -s "$HOME/git-transcrypt/transcrypt" "$target"
fi

# List of files to symlink
files=(".bash_aliases" ".bashrc" ".config/fish" ".gitconfig" ".inputrc" ".profile" ".sh_common" ".zprofile" ".zshrc")

# Loop through the files
for file in "${files[@]}"; do
    create_symlink "$file"
done

echo "Dotfiles installation complete."
