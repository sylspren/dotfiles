" This is my .vimrc...I use gvim on linux, macvim on Mac OS. 7.3 required.
" Note that there's no particular ordering here (except pathogen stuff comes first).

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"Pathogen == eadier dealing with plugins
filetype off
execute pathogen#infect()
"call pathogen#helptags()
"call pathogen#runtime_append_all_bundles()
filetype plugin indent on

syntax on
filetype plugin indent on

" Text-wrapping stuff. (Also check out my cursorcolumn setting in .gvimrc.)
set textwidth=110 " 80-width lines is for 1995
let &wrapmargin= &textwidth
set formatoptions=croql " Now it shouldn't hard-wrap long lines as you're typing (annoying), but you can gq
                        " as expected.
set hidden "This allows vim to put buffers in the bg without saving, and then allows undoes when you fg them again.
set history=1000 "Longer history
set number
set hlsearch
set autoindent
set smartindent
set expandtab
set wildmenu
set wildmode=list:longest
set scrolloff=3 " This keeps three lines of context when scrolling
set title
set expandtab
set smarttab
set ts=2 sw=2 et
"set sw=2
"set sts=2
set laststatus=2
set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
set ignorecase
set smartcase
"set undofile
set backspace=indent,eol,start
set linespace=3
set showcmd

set incsearch
set mouse=a
"allow mouseclick on rhs of widescreen (past column 223)
if has("mouse_sgr")
    set ttymouse=sgr
else
   set ttymouse=xterm2
end
set clipboard=unnamed

set guifont=Monaco:h13

let mapleader = ","

" Mappings:
map <F6> :b#<CR>
map <C-n> :noh<CR>

" Gundo settings
nnoremap <leader>g :GundoToggle<CR>

" Copy current filename to system clipboard ---- {{{3
nnoremap <leader>f :let @* = expand("%")<CR>

" NERDTree settings
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeChDirMode=2
let g:NERDChristmasTree=1
nmap <leader>t :NERDTreeToggle<CR>

" Stupid NERDCommenter warning
let NERDShutUp=1

" Make it easier to move around through blocks of text:
noremap <C-J> gj
noremap <C-k> gk
noremap U 30k
noremap D 30j

" Ack >> grep
nnoremap <leader>a :Ack

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

" For some reason I accidentally hit this shortcut all the time...let's disable it. (I usually don't look at
" man pages from within vim anyway.)
:map K <Nop>

" Preview the current markdown file:
:map <leader>m :%w ! markdown_doctor \| bcat<CR><CR>

" Close a buffer without messing with the windows (vim-bclose)
nmap <leader>q <Plug>Kwbd

" Macvim default clipboard interaction is bullshit
set clipboard=unnamed

" TODO: move all the language-specific settings to ftplugins

" Nice ruby settings
let ruby_space_settings = 1

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

function! GitDiffForLine()
  execute "!git blame " . expand("%") . " -L " . line(".") . "," . line(".") .  "| cut -d' ' -f 1 | xargs git show"
endfunction

map <F1> :call GitDiffForLine()

function ToggleNERDTree()
  execute ":NERDTreeToggle"
endfunction

command -nargs=0 ToggleNERDTree :call ToggleNERDTree()

function CoffeeCompile()
  execute ":CoffeeCompile"
endfunction

map <C-c>c :call CoffeeCompile()<CR>

" Smart tab complete
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.'))      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

inoremap <tab> <c-r>=Smart_TabComplete()<CR>

" Highlight long lines

autocmd FileType ruby let w:m2=matchadd('ErrorMsg', '\%>110v.\+', -1)
autocmd FileType eruby let w:m2=matchadd('ErrorMsg', '\%>110v.\+', -1)
autocmd FileType scala let w:m2=matchadd('ErrorMsg', '\%>110v.\+', -1)
autocmd FileType golang let w:m2=matchadd('ErrorMsg', '\%>110v.\+', -1)

" this will reselect and re-yank any text that is pasted in visual mode.
" no more copying pasted over text into buffer
xnoremap p pgvy

" Indent Guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2

autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=7
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=8

" Ctrlp

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_custom_ignore= '\.(git|hg|svn|js|map)$'

" tabs
nmap tp :tabp<CR>
nmap tn :tabn<CR>
" cmap te :tabedit<CR>
