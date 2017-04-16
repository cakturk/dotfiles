set nocompatible
set nocscopeverbose

filetype plugin indent on
syntax on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set ruler		" show the cursor position all the time

" slows down cursor movement on OS X
" set showcmd	" display incomplete commands
set laststatus=2
set pastetoggle=<F9>
set wildmenu
set showmatch
set matchtime=1
set number
set relativenumber
set scrolloff=1
set autowrite      " Automatically save before commands like :next and :make
set lazyredraw
set ttimeoutlen=10
set ignorecase
set smartcase
set incsearch
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
set linebreak

" Indentation options
set cinoptions=:0,l1,t0,g0,(0

" Display right margin at column 80
autocmd Filetype c,cpp,python,sh,ruby setlocal colorcolumn=80
autocmd Filetype go setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8

set wildignore=*.o,*.obj,*~,*.ko
set sessionoptions-=options
set formatoptions+=j " Delete comment character when joining commented lines

" Only insert the longest common text of the matches
set completeopt+=longest

set splitbelow
set splitright

" put backup and swap files in a fixed directory to keep things more organized
set undodir=~/.vim/.undo//
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

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
Plug 'ctrlpvim/ctrlp.vim', {'on': ['CtrlP', 'CtrlPMixed', 'CtrlPMRU']}
Plug 'davidhalter/jedi-vim', { 'for':  'python' }
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
Plug 'tpope/vim-dispatch', { 'on': 'Dispatch' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }

" Standard plugins
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'simplyzhao/cscope_maps.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'
Plug 'vivien/vim-linux-coding-style'
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

" vim-commentary
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

command! -bar -count=0 RFC :e http://www.ietf.org/rfc/rfc<count>.txt|setl ro noma
command! -bar Invert :let &background = (&background=="light"?"dark":"light")
command! -nargs=+ -complete=command Tabdo call <SID>tabdo(<q-args>)
command! -nargs=* -complete=help Help call <SID>help_split_smart(<f-args>)
command! SudoWrite w !sudo tee % > /dev/null

augroup load_us_ultisnips
	autocmd!
	autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets')
                    \| autocmd! load_us_ultisnips
augroup END

" Automatically scale internal windows on terminal resize
augroup resize_splits
	autocmd!
	autocmd VimResized * silent! Tabdo wincmd =
augroup END

function! s:cpp_maps()
    " Run Make using vim-dispatch
    nnoremap <buffer> <silent> <leader>7 :Dispatch make<CR>
    nnoremap <buffer> <silent> <leader>8 :Dispatch make check<CR>
endfunction

augroup compile_run_maps
    autocmd!
    autocmd Filetype c,cpp call s:cpp_maps()
    autocmd Filetype c nnoremap <buffer> <silent> <leader>5 :Dispatch cc % -o %< -Wall && %:p:r<CR>
    autocmd Filetype cpp nnoremap <buffer> <silent> <leader>5 :Dispatch c++ % -o %< -Wall && %:p:r<CR>
    autocmd Filetype python let b:dispatch='python %' |
                \ nnoremap <buffer> <silent> <leader>5 :Dispatch<CR>
augroup END

" Open help vertically or horizontally according to current window width
" based on: http://vi.stackexchange.com/a/4472
function! s:help_split_smart(tag)
    if winwidth('%') >= 158
        execute 'vertical belowright help ' . a:tag
    else
        execute 'help ' . a:tag
    endif
endfunction

" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
let g:ctrlp_user_command = {
        \ 'types': {
            \ 1: ['.git', 'git ls-files -co --exclude-standard %s'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
        \ 'fallback': 'ag %s -l --nocolor -g ""'
    \ }
" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0

" Like tabdo but restore the current tab.
function! s:tabdo(command)
    let l:currTab=tabpagenr()
    execute 'tabdo ' . a:command
    execute 'tabn ' . currTab
endfunction

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

" github.com/allinurl/dotfiles
map <leader>s :call SuperTabToggle()<CR>

fun! SuperTabToggle()
    if !exists('b:SuperTabDisabled')
        let b:SuperTabDisabled = 0
    endif

    if b:SuperTabDisabled == 0
        let b:SuperTabDisabled = 1
    else
        let b:SuperTabDisabled = 0
    endif
    echo "SuperTab: " b:SuperTabDisabled
endfun
