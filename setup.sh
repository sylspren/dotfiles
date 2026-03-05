#!/usr/bin/env bash

set -e
input="/dev/tty"

export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH # homebrew

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

## All the other stuff
brew install jumpcut
brew install keepassx
brew install --cask rectangle

~/.osx
