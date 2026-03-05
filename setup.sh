#!/usr/bin/env bash

set -e
input="/dev/tty"

export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH # homebrew

# Install homebrew
echo "Checking homebrew..."
if ! which -s brew; then
  # Homebrew will make sure xcode tools are installed
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

## Git
brew install git

## SSH
if ! [ -f ~/.ssh/id_rsa.pub ]; then
  read -p "Create SSH Key? (y/n) " setupSSH
  if [ "$setupSSH" = "y" ]; then
    # create SSH key
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

    echo "Created SSH key on ~/.ssh/ , please copy the key content of ~/.ssh/id_rsa.pub and add to Github"
    echo "Follow these instructions: https://help.github.com/articles/generating-ssh-keys#step-3-add-your-ssh-key-to-github"
    read -p "Hit ENTER to continue when you are done"
  else
    echo "Don't forget to copy existing ssh keys to ~/.ssh!"
    read -p "Copy your existing ssh key to ~/.ssh. Ensure it's added to github. Click ENTER to continue"
  fi
else
  read -p "Found SSH key already exists, ensure this key was added to Github. Click ENTER to continue"
fi

## Download and setup dotfiles
if ! [ -d ~/personal ]; then
  mkdir ~/personal
fi

if ! [ -d ~/personal/dotfiles ]; then
  git clone git@github.com:sylspren/dotfiles.git ~/personal/dotfiles
else
  echo 'dotfiles already setup, skipping.'
fi

DOTFILES_DIR=~/personal/dotfiles

## Symlink dotfiles
ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/.zprofile ~/.zprofile
ln -sf $DOTFILES_DIR/.vimrc ~/.vimrc
ln -sf $DOTFILES_DIR/.tmux.conf ~/.tmux.conf
ln -sf $DOTFILES_DIR/.gitconfig ~/.gitconfig
ln -sf $DOTFILES_DIR/.gitignore_global ~/.gitignore_global

## Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## Terminal and editor
brew install --cask iterm2
brew install macvim

## All the other stuff
brew install --cask firefox
brew install --cask spotify
brew install --cask dropbox
brew install jumpcut
brew install keepassx
brew install --cask rectangle

~/.osx
