set nocompatible

filetype plugin indent on
syntax on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set ruler		" show the cursor position all the time

" slows down cursor movement on OS X
" set showcmd	" display incomplete commands
set laststatus=2
set wildmenu

set number

set ignorecase
set smartcase
set incsearch		" do incremental searching
" Highlight strings matched by the search pattern
if &hlsearch == 0
    set hls
endif
set history=1000

" default indent settings
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set colorcolumn=80
set linebreak

set wildignore=*.o,*.obj,*~,*.ko
set sessionoptions-=options
set formatoptions+=j " Delete comment character when joining commented lines

" Only insert the longest common text of the matches
set completeopt+=longest

set splitbelow
set splitright

let mapleader   = " "
let localleader = " "

" Prevent accidental macro recordings by moving
" macro record keybinding from 'q' to 'Q'
nnoremap Q q
nnoremap q <Nop>

call plug#begin('~/.vim/plugged')

" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'kien/ctrlp.vim', { 'on':  'CtrlP' }
Plug 'davidhalter/jedi-vim', { 'for':  'python' }

" Standard plugins
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'
Plug 'simplyzhao/cscope_maps.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'
Plug 'cakturk/kernel-coding-style'
Plug 'flazz/vim-colorschemes'

call plug#end()

silent! colorscheme seoul256

" Tell the NERDTree to respect 'wildignore'
let NERDTreeRespectWildIgnore=1

" Trigger to load CtrlP
nnoremap <silent> <c-p> :CtrlP<cr>
" Toggle NERDTree
nnoremap <silent> <leader>e :NERDTreeToggle<CR>
" Toggle hlsearch
nnoremap <silent> <leader>l :nohlsearch<CR><C-L>
" Toggle between alternate files
nnoremap <silent> <leader>t :e #<CR>

augroup load_us_ultisnips
	autocmd!
	autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets')
                    \| autocmd! load_us_ultisnips
augroup END

function! CloseHiddenBuffers()
  " figure out which buffers are visible in any tab
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any buffer that are loaded and not visible
  let l:tally = 0
  for b in range(1, bufnr('$'))
    if bufname(b) !=# "GoToFile" && buflisted(b) && !has_key(visible, b)
      let l:tally += 1
      exe 'bwipeout' . b
    endif
  endfor
  echon "Deleted " . l:tally . " buffers"
endfun
