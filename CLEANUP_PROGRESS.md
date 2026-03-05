# Dotfiles Cleanup - Progress Tracker

## Context
Cleaning up a years-old personal dotfiles repo at ~/personal/dotfiles.
Going file by file, presenting options for each change, then applying.

## Completed

### 1. `.gitconfig`
- Updated email to lhuang09@gmail.com
- Fixed broken excludesfile path (was /Users/lei/, now ~/.gitignore_global)
- Editor changed to just `vim` (no hardcoded /usr/bin/vim path)
- Removed duplicate [push] section, kept `default = simple`

### 2. `setup.sh` (first pass)
- Updated Homebrew PATH to Apple Silicon (/opt/homebrew/bin)
- Removed redundant HOMEBREW_CASK_OPTS
- Added `brew install --cask rectangle`

### 3. `.bash_profile` → `.zshrc` + `.zprofile`
- Deleted .bash_profile from repo
- Added .zshrc (copied from ~/.zshrc) and .zprofile (copied from ~/.zprofile)
- Removed Ruby aliases (be, bi)
- Removed custom git completion code (zsh compinit handles it)
- Kept: mvim alias, git log aliases, grep color alias

### 4. `.vimrc`
- Pathogen → vim-plug (auto-installs, run :PlugInstall on first launch)
- Gundo → undotree (same <leader>g binding)
- Syntastic → ALE (async linting)
- CtrlP → fzf.vim (<C-p> for files, <leader>a for :Rg search)
- Removed: CoffeeScript + CoffeeCompile, vim-cjsx, vim-flow, vim-jsx (archived),
  Stylus filetype detection, Ack mapping, markdown_doctor/bcat preview,
  vim-markdown-preview config, Ruby/Scala settings, duplicate settings
- Kept: NERDTree, NERDCommenter, emmet, fugitive, surround, repeat, endwise,
  markdown, Smart_TabComplete, GitDiffForLine, whitespace highlighting,
  Go/Markdown augroups, indent guides

### 5. `.tmux.conf`
- Default shell: bash → /bin/zsh
- Removed all reattach-to-user-namespace references (4 places), using pbcopy/pbpaste directly

### 6. `.slate` → `RectangleConfig.json`
- Deleted .slate (Slate is abandoned)
- Added RectangleConfig.json with existing keybindings (Cmd+Alt+J/K/O = left/right/full)

### 7. `.ackrc`
- Deleted (ripgrep replaces ack, respects .gitignore by default)

### 8. `.osx`
- Removed Dashboard commented-out refs (lines 131-135)
- Removed entire Terminal/iTerm Solarized osascript block, X11 focus-follows-mouse,
  commented iTerm Solarized install, and other dead commented-out code (~50 lines)
- Left "disable smart text" settings commented out (lines 19-30) as intended
- Cleaned up killall list: removed SizeUp, Spectacle, Tweetbot, Twitter, Opera,
  iCal, Address Book, Google Chrome Canary, Transmission
- Updated section header to "TextEdit and Disk Utility"

### 9. `.gitmodules` / vim submodules
- Emptied `.gitmodules` (all 19 submodule entries removed)
- `git rm --cached` all 16 tracked submodules from index
- Deleted all `vim/bundle/` directories from disk (including vim-stylus which wasn't in .gitmodules)
- Removed `.git/modules/vim/bundle/` cache
- Removed all submodule sections from `.git/config`
- vim-plug now manages all plugins via `~/.vim/plugged/`

## Still TODO

### 10. `karabiner.json`
- Deleted (no longer using Karabiner)

### 11. `.gitignore_global`
- Removed `.nodemonignore` (nodemon dropped this years ago)
- Removed `.ruby-version` (no longer doing Ruby)
- Kept: .idea, .DS_Store, ctags, vim swap files

### 12. `setup.sh` — second pass
- Added symlink creation for: .zshrc, .zprofile, .vimrc, .tmux.conf, .gitconfig, .gitignore_global
- Added vim-plug auto-installer (curl download)
- Changed `source ~/.osx` to `~/.osx` (execute directly)

### 13. General
- Nothing has been committed yet — all changes are unstaged/staged
- Cleanup is complete! All files modernized.
