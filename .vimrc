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
set history=1000

" default indent settings
set shiftwidth=4
set expandtab
set smarttab
set autoindent

set linebreak

set wildignore=*.o,*.obj,*~,*.ko
set sessionoptions-=options
set formatoptions+=j " Delete comment character when joining commented lines

colorscheme seoul256

let mapleader   = " "
let localleader = " "

call plug#begin('~/.vim/plugged')

" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'kien/ctrlp.vim', { 'on':  'CtrlP' }

" Standard plugins
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'
Plug 'simplyzhao/cscope_maps.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'
Plug 'cakturk/kernel-coding-style'

call plug#end()

" Trigger to load CtrlP
nnoremap <silent> <c-p> :CtrlP<cr>
" Toggle NERDTree
nnoremap <silent> <leader>e :NERDTreeToggle<CR>
" Toggle hlsearch
nnoremap <silent> <leader>l :nohlsearch<CR><C-L>

augroup load_us_ultisnips
	autocmd!
	autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets')
augroup END
