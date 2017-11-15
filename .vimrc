" ======================================================================
" Plugins {{{
" ======================================================================
call plug#begin('~/.vim/plugged')

" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'honza/vim-snippets'
augroup ultisnips_loader
    autocmd!
    autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets')
                \| autocmd! ultisnips_loader
augroup END

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
" Plug 'ctrlpvim/ctrlp.vim', {'on': ['CtrlP', 'CtrlPMixed', 'CtrlPMRU']}
" Plug 'davidhalter/jedi-vim', { 'for':  'python' }
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
Plug 'tpope/vim-dispatch', { 'on': 'Dispatch' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Standard plugins
Plug 'tpope/vim-fugitive'
Plug 'simplyzhao/cscope_maps.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'
Plug 'vivien/vim-linux-coding-style'
Plug 'flazz/vim-colorschemes'
if v:version >= 800
    Plug 'w0rp/ale', { 'on': [] }
    augroup ale_loader
        autocmd!
        autocmd InsertEnter *
                    \  if &ft =~# '^\%(c\|cpp\|go\|python\)$'
                    \|     call plug#load('ale')
                    \|     execute 'autocmd! ale_loader'
                    \| endif
    augroup END
endif
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" }}} plugins

" ======================================================================
" Essential settings {{{
" ======================================================================
set nocompatible

filetype plugin indent on
syntax enable

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set nocscopeverbose
set ruler		" show the cursor position all the time

" slows down cursor movement on OS X
" set showcmd	" display incomplete commands
set laststatus=2
set pastetoggle=<F9>
set wildmenu
set showmatch
set matchtime=1
set number
set synmaxcol=300
set switchbuf=useopen,usetab
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
" Search starts in local include directory, if there is one
set path^=include

" Display right margin at column 80
augroup indent_group
    autocmd!
    autocmd Filetype c,cpp,python,sh,ruby setlocal colorcolumn=80
    autocmd Filetype go setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
augroup end

set wildignore=*.o,*.obj,*~,*.ko
set sessionoptions-=options
set formatoptions+=j " Delete comment character when joining commented lines
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Only insert the longest common text of the matches
set completeopt+=longest

set splitbelow
set splitright

" put backup and swap files in a fixed directory to keep things more organized
set undodir=~/.vim/.undo//
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

" Colorscheme settings
let g:solarized_termcolors=256
silent! colorscheme seoul256
" }}}

" ======================================================================
" Mappings and commands {{{
" ======================================================================
let mapleader   = " "
let localleader = " "

" Prevent accidental macro recordings by moving
" macro record keybinding from 'q' to 'Q'
nnoremap Q q
nnoremap q <Nop>

" Tell the NERDTree to respect 'wildignore'
let NERDTreeRespectWildIgnore=1

" Trigger to load CtrlP
" nnoremap <silent> <c-p> :CtrlP<cr>
" Toggle NERDTree
nnoremap <silent> <leader>ee :NERDTreeToggle<CR>
nnoremap <silent> <leader>ef :NERDTreeFind<CR>
" Toggle hlsearch
nnoremap <silent> <leader>l :nohlsearch<CR><C-L>
" Toggle between alternate files
nnoremap <silent> <leader>t :e #<CR>
" Damian Conway's idea. swap semicolon with colon.
" That <SHIFT> is just plain annoying
nnoremap <silent> <leader>st :call <SID>swap_semicolon_colon()<CR>
" <Leader>c Close quickfix/location window
nnoremap <silent> <leader>c :cclose<bar>lclose<CR>
" Quickly open and source vimrc
nnoremap <leader>ev :call <SID>clever_split('split', $MYVIMRC)<CR>
nnoremap <silent> <leader>es :update $MYVIMRC<Bar>so $MYVIMRC<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG :Ag <C-R><C-A><CR>
nnoremap <silent> <c-p> :FZF<CR>
nnoremap <silent> <leader>ff :FZF<CR>
nnoremap <silent> <leader>fg :GFiles<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>ft :Tags<CR>
nnoremap <silent> <Leader>aw :Aw <C-R><C-W><CR>

" Quickfix
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" Tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" vim-commentary
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" supertab: github.com/allinurl/dotfiles
nnoremap <leader>ss :call <SID>supertabtoggle()<CR>

function! s:swap_semicolon_colon()
    if maparg(";", "n") == ":"
        nunmap ;
    else
        nnoremap ; :
    endif
    if maparg(":", "n") == ";"
        nunmap :
    else
        nnoremap : ;
    endif
endfunction

" Make it default
if !exists("g:loaded_swap_semicolon")
    call <SID>swap_semicolon_colon()
    let g:loaded_swap_semicolon = 1
endif
" }}}

" Commands {{{
" ======================================================================
command! -bar -count=0 RFC :e http://www.ietf.org/rfc/rfc<count>.txt|setl ro noma
command! -bar Invert :let &background = (&background=="light"?"dark":"light")
command! -nargs=+ -complete=command Tabdo call <SID>tabdo(<q-args>)
command! -nargs=* -complete=help Help call <SID>clever_split('help', <f-args>)
command! SudoWrite w !sudo tee % > /dev/null
command! CloseHiddenBuffers call <SID>closehiddenbuffers()
command! -bang -nargs=* Aw
  \ call fzf#vim#grep('ag -w --nogroup --column --color '.shellescape(<q-args>), 1, <bang>0)

" Replace built-in :help command with a smarter one
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev h <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Help' : 'h')<CR>
" }}}

" Autocommands
" ------------

" Automatically scale internal windows on terminal resize
augroup resize_splits
	autocmd!
	autocmd VimResized * silent! Tabdo wincmd =
augroup END

augroup vimrc
    autocmd!
    autocmd FileType vim setlocal keywordprg=:Help
    autocmd FileType help setlocal keywordprg=:help
    autocmd FileType help nnoremap <silent><buffer> q :q<CR>
augroup END

augroup compile_run_maps
    autocmd!
    autocmd Filetype c,cpp call s:cpp_maps()
    autocmd Filetype c nnoremap <buffer> <silent> <leader>4 :Dispatch cc % -o %< -Wall<CR>
    autocmd Filetype c nnoremap <buffer> <silent> <leader>5 :Dispatch cc % -o %< -Wall && %:p:r<CR>
    autocmd Filetype cpp nnoremap <buffer> <silent> <leader>4 :Dispatch c++ --std=c++11 % -o %< -Wall<CR>
    autocmd Filetype cpp nnoremap <buffer> <silent> <leader>5 :Dispatch c++ --std=c++11 % -o %< -Wall && %:p:r<CR>
    autocmd Filetype python let b:dispatch='python %' |
                \ nnoremap <buffer> <silent> <leader>5 :Dispatch<CR>
augroup END

" ======================================================================
" Plugin configurations {{{
" ======================================================================

" let g:SuperTabDefaultCompletionType = 'context'
" let g:SuperTabContextDefaultCompletionType = '<c-x><c-o>'
autocmd FileType *
            \ if &omnifunc != '' |
            \   call SuperTabChain(&omnifunc, "<c-p>") |
            \ endif
let g:SuperTabClosePreviewOnPopupClose = 1
" let g:SuperTabCompleteCase = 'ignorecase'

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

" Customize fzf colors to match your color scheme
let g:fzf_colors = {
            \ 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment']
            \ }
" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" }}}

" ======================================================================
" Helper functions {{{
" ======================================================================

function! s:cpp_maps()
    " Run Make using vim-dispatch
    nnoremap <buffer> <silent> <leader>7 :Dispatch make<CR>
    nnoremap <buffer> <silent> <leader>8 :Dispatch make check<CR>
endfunction

function! s:should_split_vertically()
    let try_count = 0

    while try_count < 2
        let try_count += 1
        if bufname('%') =~# 'NERD_tree_'
            execute 'wincmd l'
        endif
        if &buftype ==# 'quickfix'
            execute 'wincmd k'
        endif
    endwhile
    return winwidth('%') >= 158
endfunction

" Open help vertically or horizontally according to current window width
" based on: http://vi.stackexchange.com/a/4472
function! s:clever_split(cmd, ...)
    let l:arg = (a:0 == 1) ? a:1 : ''

    if s:should_split_vertically()
        let l:acmd = 'vertical belowright ' . a:cmd . ' ' . l:arg
    else
        let l:acmd = a:cmd . ' ' . l:arg
    endif
    try
        execute l:acmd
    catch /^Vim(help):E149:/
        echohl ErrorMsg
        echomsg v:exception
        echohl None
    endtry
endfunction

" Like tabdo but restore the current tab.
function! s:tabdo(command)
    let l:currTab=tabpagenr()
    execute 'tabdo ' . a:command
    execute 'tabn ' . currTab
endfunction

function! s:closehiddenbuffers()
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

fun! s:supertabtoggle()
    if !exists('b:SuperTabDisabled')
        let b:SuperTabDisabled = 0
    endif

    if b:SuperTabDisabled == 0
        let b:SuperTabDisabled = 1
    else
        let b:SuperTabDisabled = 0
    endif
    echo "SuperTab: " . (b:SuperTabDisabled ? 'Off' : 'On')
endfun
" }}}
