" vim-plug plugin manager (auto-install if missing)
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-markdown'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'mbbill/undotree'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

set nocompatible
syntax on
filetype plugin indent on

" Text-wrapping stuff.
set textwidth=110
let &wrapmargin= &textwidth
set formatoptions=croql

set hidden
set history=1000
set number
set hlsearch
set autoindent
set smartindent
set expandtab
set wildmenu
set wildmode=list:longest
set scrolloff=3
set title
set smarttab
set ts=2 sw=2 et
set laststatus=2
set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
set ignorecase
set smartcase
set backspace=indent,eol,start
set linespace=3
set showcmd
set incsearch
set mouse=a

if has("mouse_sgr")
    set ttymouse=sgr
else
   set ttymouse=xterm2
end

" Share clipboard
set clipboard=unnamed

set guifont=Monaco:h13

let mapleader = ","

" Mappings:
map <F6> :b#<CR>
map <C-n> :noh<CR>

" Undotree (replaces Gundo)
nnoremap <leader>g :UndotreeToggle<CR>

" Copy current filename to system clipboard
nnoremap <leader>f :let @* = expand("%")<CR>

" NERDTree settings
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeChDirMode=2
let g:NERDChristmasTree=1
nmap <leader>t :NERDTreeToggle<CR>

" NERDCommenter
let NERDShutUp=1
let NERDSpaceDelims=1

" Make it easier to move around through blocks of text:
noremap <C-J> gj
noremap <C-k> gk
noremap U 30k
noremap D 30j

" Audio bell == annoying
set vb t_vb=

" Show extra whitespace
highlight ExtraWhitespace ctermbg=green guibg=green
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd BufWritePre * :%s/\s\+$//e

" A command to delete all trailing whitespace from a file.
command DeleteTrailingWhitespace %s:\(\S*\)\s\+$:\1:

" Disable K (man page lookup) — too easy to hit accidentally
map K <Nop>

" Close a buffer without messing with the windows (vim-bclose)
nmap <leader>q <Plug>Kwbd

" Go specific settings
augroup golang
  au!
  au FileType go set noexpandtab
augroup END

" Markdown settings
augroup markdown
  au!
  au FileType markdown set comments=b:*,b:-,b:+,n:>h
augroup END

" Git blame for current line
function! GitDiffForLine()
  execute "!git blame " . expand("%") . " -L " . line(".") . "," . line(".") .  "| cut -d' ' -f 1 | xargs git show"
endfunction
map <F1> :call GitDiffForLine()

" Smart tab complete
function! Smart_TabComplete()
  let line = getline('.')
  let substr = strpart(line, -1, col('.'))
  let substr = matchstr(substr, "[^ \t]*$")
  if (strlen(substr)==0)
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1
  let has_slash = match(substr, '\/') != -1
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"
  elseif ( has_slash )
    return "\<C-X>\<C-F>"
  else
    return "\<C-X>\<C-O>"
  endif
endfunction
inoremap <tab> <c-r>=Smart_TabComplete()<CR>

" Highlight long lines in Go
autocmd FileType golang let w:m2=matchadd('ErrorMsg', '\%>110v.\+', -1)

" Reselect and re-yank text pasted in visual mode
xnoremap p pgvy

" Indent Guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=7
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=8

" fzf (replaces CtrlP)
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
nnoremap <C-p> :Files<CR>
nnoremap <leader>a :Rg<space>

" Tabs
nmap tp :tabp<CR>
nmap tn :tabn<CR>

" JSX
let g:user_emmet_leader_key='<C-l>'

" ALE (async linting, replaces Syntastic)
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fix_on_save = 0
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'

" Swap and backup directory
" Create swap/backup directory if it doesn't exist
if !isdirectory($HOME . "/.vim/swapfiles")
    call mkdir($HOME . "/.vim/swapfiles", "p", 0700)
endif
set directory=$HOME/.vim/swapfiles/
set backupdir=$HOME/.vim/swapfiles/
