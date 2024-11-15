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

# Install oh-my-zsh
# if [ ! -d "$HOME/.oh-my-zsh" ]; then
#     echo "Installing oh-my-zsh..."
#     curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
# fi

# Install git completion
# if [ ! -f "$HOME/.git-completion.bash" ]; then
#     echo "Installing git completion..."
#     curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
# fi

# List of files to symlink
files=(".bash_aliases" ".bashrc" ".config/fish" ".gitconfig" ".inputrc" ".profile" ".sh_common" ".zprofile" ".zshrc")

# Loop through the files
for file in "${files[@]}"; do
    create_symlink "$file"
done

# Install trash-cli
if ! command -v trash &> /dev/null; then
    echo "Installing trash-cli..."
    pip install trash-cli
fi

echo "Dotfiles installation complete."
