#!/usr/bin/env bash

set -e
input="/dev/tty"

export PATH=/usr/local/bin:/usr/local/sbin:$PATH # homebrew
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# install homebrew
echo "Checking homebrew..."
if ! which -s brew; then
  # Homebrew will make sure xcode tools are installed
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/HomeBrew/install/master/install)" < $input
fi
brew doctor
mkdir -p ~/Library/LaunchAgents

## Remap capslock
brew cask install seil
# TODO: open seil and set capslock to 53 (escape)
# TODO: switch alt and command on external
# TODO: disable capslock on built-in

## iterm2
brew cask install iterm2

## mvim
brew install macvim

# TODO: setup git & ssh

## slate
# TODO: run slate and setup permissions
brew cask install slate

## download and setup dotfiles
if ! [ -d ~/personal ]; then
  mkdir ~/personal
fi

if ! [ -d ~/personal/dotfiles ]; then
  git clone git@github.com:sylspren/dotfiles.git ~/personal/dotfiles

  ln -s ~/personal/dotfiles/.bash_profile ~/.bash_profile
  ln -s ~/personal/dotfiles/bash_plugins ~/.bash_plugins

  ln -s ~/personal/dotfiles/.vimrc ~/.vimrc
  ln -s ~/personal/dotfiles/vim ~/.vim

  ln -s ~/personal/dotfiles/.slate ~/.slate

  ln -s ~/personal/dotfiles/.ackrc ~/.ackrc

  ln -s ~/personal/dotfiles/.gitignore_global ~/.gitignore_global
  ln -s ~/personal/dotfiles/.gitconfig ~/.gitconfig
else
  echo 'dotfiles already setup, skipping.'
fi

## Setup Ruby
if ! [ -d ~/.rbenv ]; then
  read -p "Setup ruby? (y/n) " includeRuby
  if [ "$includeRuby" = "y" ]; then
    echo "Installing rbenv..."
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    cd ~/.rbenv && src/configure && make -C src
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    cd ~

    echo "Installing ruby-build..."
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

    echo "Installing ruby..."
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    rbenv install 2.1.3
  fi
else
  echo 'Rbenv already setup, skipping.'
fi

# TODO(optional): node

## All the other stuff
brew cask install jumpcut
brew cask install firefox
brew cask install keepassx
brew install ack
brew install the_silver_searcher
brew cask install spotify

# TODO: dropbox
