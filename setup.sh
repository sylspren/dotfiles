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

## Remap capslock
brew cask install karabiner-elements

## iterm2
brew cask install iterm2

## mvim
brew install macvim

## tmux & tmux clipboard fixer
brew install tmux
brew install reattach-to-user-namespace

## slate
brew cask install slate
echo "Go give slate and karabiner access to Accessibliity. Then add them to startup items"
open "x-apple.systempreferences:com.apple.preference.security"
read -p "Done?"

## download and setup dotfiles
if ! [ -d ~/personal ]; then
  mkdir ~/personal
fi

if ! [ -d ~/personal/dotfiles ]; then
  git clone git@github.com:sylspren/dotfiles.git ~/personal/dotfiles

  cd ~/personal/dotfiles && git submodule init && git submodule update

  ln -s ~/personal/dotfiles/.bash_profile ~/.bash_profile
  ln -s ~/personal/dotfiles/bash_plugins ~/.bash_plugins

  ln -s ~/personal/dotfiles/.vimrc ~/.vimrc
  ln -s ~/personal/dotfiles/vim ~/.vim

  ln -s ~/personal/dotfiles/.tmux.conf ~/.tmux.conf

  mkdir -p ~/.config/karabiner
  ln -s ~/personal/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json

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

## PIP
if ! which -s pip; then
  read -p "Setup pip? (y/n) " setupPip
  if [ "$setupPip" = "y" ]; then
    echo "Installing pip..."
    curl https://bootstrap.pypa.io/get-pip.py > get-pip.py
    sudo python get-pip.py
  fi
else
  echo 'PIP already setup skipping.'
fi

# TODO(optional): node

## All the other stuff
brew cask install jumpcut
brew cask install firefox
brew cask install keepassx
brew install ack
brew install the_silver_searcher
brew cask install spotify
brew cask install evernote

# TODO: dropbox
