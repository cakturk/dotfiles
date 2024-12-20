" ======================================================================
" Plugins {{{
" ======================================================================
call plug#begin('~/.vim/plugged')

" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
" Plug 'ctrlpvim/ctrlp.vim', {'on': ['CtrlP', 'CtrlPMixed', 'CtrlPMRU']}
" Plug 'davidhalter/jedi-vim', { 'for':  'python' }
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
Plug 'tpope/vim-dispatch', { 'on': 'Dispatch' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go', 'tag': '*' }
Plug 'majutsushi/tagbar', { 'on': ['TagbarToggle', 'TagbarDebug'] }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Standard plugins
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'simplyzhao/cscope_maps.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'
Plug 'vivien/vim-linux-coding-style'
Plug 'flazz/vim-colorschemes'

Plug 'dense-analysis/ale', { 'for': ['c', 'cpp', 'cgo', 'python'] }
let g:ale_disable_lsp = 1
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "⚠"
let g:ale_set_highlights = 0
let g:ale_sign_column_always = 1
let g:ale_linters = {'go': ['golangci-lint', 'gofmt', 'govet']}
let g:ale_c_parse_makefile = 1
let g:ale_c_parse_compile_commands = 1
let g:ale_go_golangci_lint_options = ""
let g:ale_lint_delay = 1000
let g:ale_cpp_ccls_init_options = {
            \   'cache': {
            \       'directory': '/tmp/ccls-cache'
            \   }
            \ }
let g:ale_c_ccls_init_options = {
            \   'cache': {
            \       'directory': '/tmp/ccls-cache'
            \   }
            \ }

Plug 'ConradIrwin/vim-bracketed-paste'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'

function MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let s .= '%' . i . 'T'
        let s .= (i == t ? '%1*' : '%2*')
        let s .= ' '
        let s .= i . ':'
        " let s .= winnr . '/' . tabpagewinnr(i,'$')
        let s .= ' %*'
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
        let bufnr = buflist[winnr - 1]
        let file = bufname(bufnr)
        let buftype = getbufvar(bufnr, 'buftype')
        if buftype == 'nofile'
            if file =~ '\/.'
                let file = substitute(file, '.*\/\ze.', '', '')
            endif
        else
            let file = fnamemodify(file, ':p:t')
        endif
        if file == ''
            let file = '[No Name]'
        endif
        let s .= file
        let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
endfunction
" set tabline=%!MyTabLine()
setglobal statusline=[%n]\ %<%.99f\ %y%h%w%m%r%{FugitiveStatusline()}%=%-14.(%8l/%L%)\ %-3v\ %P

if has('nvim')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " https://github.com/neoclide/coc.nvim/issues/576#issuecomment-632446784
    " https://github.com/neoclide/coc.nvim/issues/1054#issuecomment-619343648
    function! s:goto_tag(kind) abort
        let tagname = expand('<cWORD>')
        let winnr = winnr()
        let pos = getcurpos()
        let pos[0] = bufnr()

        if CocAction('jump' . a:kind)
            call settagstack(winnr, {
                        \ 'curidx': gettagstack()['curidx'],
                        \ 'items': [{'tagname': tagname, 'from': pos}]
                        \ }, 't')
        endif
    endfunction

    function s:setcocmaps()
        if has("nvim-0.5")
            nnoremap <silent><buffer><leader>gd :call <SID>goto_tag('Definition')<CR>
            nnoremap <silent><buffer><C-]> :call <SID>goto_tag('Definition')<CR>
            nnoremap <silent><buffer><leader>gx :call <SID>goto_tag('References')<CR>
        else
            nmap <silent><buffer><C-]> <Plug>(coc-definition)
            nmap <silent><buffer><leader>gd <Plug>(coc-definition)
            nmap <silent><buffer><leader>gx <Plug>(coc-references)
        endif
        nmap <silent><buffer><leader>gr <Plug>(coc-rename)
        nmap <silent><buffer><leader>gt <Plug>(coc-type-definition)
        nmap <silent><buffer><leader>gi <Plug>(coc-implementation)
        " Applying codeAction to the selected region.
        " Example: `<leader>aap` for current paragraph
        xmap <silent><buffer><leader>ga <Plug>(coc-codeaction-selected)
        nmap <silent><buffer><leader>ga <Plug>(coc-codeaction-selected)
        nmap <silent><buffer><leader>gc <Plug>(coc-fix-current)
        nmap <silent><buffer><leader>gh <Plug>(coc-codeaction)
        nnoremap <silent><buffer><leader>gj :call CocAction('doHover')<CR>
        nnoremap <silent><buffer><leader>gf :call CocAction('format')<CR>
        xmap <silent><buffer><leader>gs <Plug>(coc-format-selected)
        nmap <silent><buffer><leader>gm <Plug>(coc-format-selected)
    endfunction()

    augroup coc_maps
        autocmd!
        autocmd FileType cpp,c,go,python call s:setcocmaps()
    augroup END
endif

call plug#end()

" }}} plugins

" ======================================================================
" General settings {{{
" ======================================================================
set nocompatible

filetype plugin indent on
syntax on

" https://www.reddit.com/r/vim/comments/8se9ug/changing_cursor_in_different_modes_with_tmux/?depth=1
" Changing cursor shape per mode
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
if exists('$TMUX')
    " tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
    let &t_SI .= "\<Esc>Ptmux;\<Esc>\<Esc>[4 q\<Esc>\\"
    let &t_EI .= "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
    " autocmd VimLeave * silent !echo -ne "\033Ptmux;\033\033[0 q\033\\"
else
    let &t_SI .= "\<Esc>[4 q"
    let &t_EI .= "\<Esc>[2 q"
    " autocmd VimLeave * silent !echo -ne "\033[0 q"
endi

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set ruler		" show the cursor position all the time
set visualbell
set mouse=ni

" slows down cursor movement on OS X
set showcmd	" display incomplete commands
set laststatus=2
set pastetoggle=<F9>
set wildmenu
set showmatch
set matchtime=1
set number
set synmaxcol=300
set switchbuf=useopen,usetab
set autoread
" set relativenumber
set scrolloff=1
set encoding=utf-8
set autowrite      " Automatically save before commands like :next and :make
if !has('nvim')
    set nocscopeverbose
    set lazyredraw
endif
set timeout timeoutlen=600 ttimeoutlen=10
set ignorecase
set smartcase
set incsearch
set fillchars=vert:\│
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

" Display right margin at 80th column
augroup indent_group
    autocmd!
    autocmd Filetype c,cpp,python,sh,ruby setlocal colorcolumn=80
    autocmd Filetype go setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
augroup end

set wildignore=*.o,*.obj,*~,*.ko
set wildignorecase
set sessionoptions-=options
set formatoptions+=j " Delete comment character when joining commented lines
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Only insert the longest common text of the matches
set completeopt+=longest

set splitbelow
set splitright

" put backup and swap files in a fixed directory to keep things more organized
set undofile
if has('nvim')
    set undodir=~/.config/nvim/undo/
    set backupdir=~/.config/nvim/backup/
    set directory=~/.config/nvim/swp/
else
    set undodir=~/.vim/.undo/
    set backupdir=~/.vim/.backup/
    set directory=~/.vim/.swp/
endif

" https://github.com/vim/vim/issues/993#issuecomment-255651605
set termguicolors

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Put these in an autocmd group, so that you can revert them with:
" :augroup vimStartup | au! | augroup END"
if !exists("#fedora")
    augroup vimStartup
        au!

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid, when inside an event handler
        " (happens when dropping a file on gvim) and for a commit message (it's
        " likely a different one than last time).
        autocmd BufReadPost *
                    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                    \ |   exe "normal! g`\""
                    \ | endif

    augroup END
endif

augroup vimrc
    autocmd!
    autocmd FileType vim setlocal keywordprg=:Help
    autocmd FileType help setlocal keywordprg=:help
    autocmd FileType help,vim nnoremap <silent><buffer> q :q<CR>
    autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

" Automatically scale internal windows on terminal resize
augroup resize_splits
    autocmd!
    " autocmd VimResized * silent! Tabdo wincmd =

    " Position the (global) quickfix window at the very bottom of the window
    " (useful for making sure that it appears underneath splits)
    "
    " NOTE: Using a check here to make sure that window-specific location-lists
    " aren't effected, as they use the same `FileType` as quickfix-lists.
    autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
augroup END

if has('nvim')
    set inccommand=nosplit
endif

" Colorscheme settings
let g:gruvbox_contrast_dark='soft'
let g:gruvbox_contrast_light='hard'
let g:seoul256_background = 236
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

" Trigger to load CtrlP
" nnoremap <silent> <c-p> :CtrlP<cr>
" Toggle NERDTree
nnoremap <silent> <leader>ee :NERDTreeToggle<CR>
nnoremap <silent> <leader>ef :NERDTreeFind<CR>
" Turn off search highlighting - :nohlsearch<CR><C-L>
nnoremap <silent> <leader>l :nohlsearch<CR><C-L>
" Toggle between alternate files
nnoremap <silent> <leader>t :e #<CR>
" Damian Conway's idea. swap semicolon with colon.
" That <SHIFT> is just plain annoying
nnoremap <silent> <leader>st :call <SID>swap_semicolon_colon()<CR>
" <Leader>c Close quickfix/location window
nnoremap <silent> <leader>c :cclose<bar>lclose<CR>
" Quickly open and source vimrc
nnoremap <silent> <leader>et :call <SID>clever_split('split', '~/.tmux.conf')<CR>
nnoremap <silent> <leader>ev :call <SID>clever_split('split', $MYVIMRC)<CR>
nnoremap <silent> <leader>es :update $MYVIMRC<Bar>so $MYVIMRC<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG :Ag <C-R><C-A><CR>
nnoremap <silent> <c-p> :FZF<CR>
nnoremap <silent> <leader>ff :FZF<CR>
nnoremap <silent> <leader>fg :GFiles<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>ft :Tags<CR>
nnoremap <silent> <Leader>aw :Aw <C-R><C-W><CR>

"Double-delete to remove trailing whitespace...
nnoremap <silent> <BS><BS> :call <SID>trimtrailingws()<CR>

" Editor mappings
nnoremap <leader>w :update<CR>
nnoremap <leader>e :e!<CR>
nnoremap <leader>x :e!<CR>

" If cursor is in first or last line of window, scroll to middle line.
" VimWiki: Make_search_results_appear_in_the_middle_of_the_screen
function! s:maybemiddle()
    if winline() == &so+1 || winline() == winheight(0) - &so
        normal! zz
    endif
endfunction

nnoremap <silent> n n:call <SID>maybemiddle()<CR>
nnoremap <silent> N N:call <SID>maybemiddle()<CR>

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

" jf/jk | Escaping!
inoremap jf <Esc>
inoremap jk <Esc>
inoremap jj <Esc>
" xnoremap jf <Esc>
" cnoremap jf <C-c>

augroup compile_run_maps
    autocmd!
    autocmd Filetype c,cpp nnoremap <buffer> <silent> <leader>7 :<c-u>Dispatch make<CR>
    autocmd Filetype c,cpp nnoremap <buffer> <silent> <leader>8 :Dispatch make check<CR>
    autocmd Filetype c nnoremap <buffer> <silent> <leader>4 :Dispatch cc -g % -o %< -Wall<CR>
    autocmd Filetype c nnoremap <buffer> <silent> <leader>5 :Dispatch cc -g % -o %< -Wall && %:p:r<CR>
    autocmd Filetype cpp nnoremap <buffer> <silent> <leader>4 :Dispatch c++ -g --std=c++11 % -o %< -Wall<CR>
    autocmd Filetype cpp nnoremap <buffer> <silent> <leader>5 :Dispatch c++ -g --std=c++11 % -o %< -Wall && %:p:r<CR>
    autocmd Filetype python let b:dispatch='python %' | nnoremap <buffer> <silent> <leader>5 :Dispatch<CR>
    autocmd Filetype go nnoremap <buffer> <silent> <leader>r :GoRun %<CR>
    autocmd Filetype go nnoremap <buffer> <silent> <leader>gg :<C-u>call <SID>build_go_files()<CR>
    autocmd Filetype go nnoremap <buffer> <silent> <leader>gf :GoTestFunc<CR>
    autocmd Filetype go nnoremap <buffer> <silent> <leader>gt :GoTest<CR>
augroup END

" vim-commentary
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" supertab: github.com/allinurl/dotfiles
nnoremap <leader>ss :call <SID>supertabtoggle()<CR>

" Tagbar
nnoremap <silent> <F8> :TagbarToggle<CR>

let g:goyo_width=100
nnoremap <silent> <F9> :Goyo<CR>

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

" ======================================================================
" Commands {{{
" ======================================================================
command! -bar -count=0 RFC :silent e https://tools.ietf.org/rfc/rfc<count>.txt|setl ro noma|redraw!
command! -bar Invert :let &background = (&background=="light"?"dark":"light")
command! -nargs=+ -complete=command Tabdo call <SID>tabdo(<q-args>)
command! -nargs=* -complete=help Help call <SID>clever_split('help', <f-args>)
command! SudoWrite w !sudo tee % > /dev/null
command! CloseHiddenBuffers call <SID>closehiddenbuffers()
command! -bang -nargs=* Aw
  \ call fzf#vim#grep('ag -w --nogroup --column --color '.shellescape(<q-args>), 1, <bang>0)

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig". Copied from 'defaults.vim'
command! DiffOrig let dsyn=&syn | vert new | set bt=nofile | let &syn=dsyn | r ++edit # | 0d_
            \ | difft | nnoremap <silent><buffer> q :q<CR> | winc p | difft

" Replace built-in :help command with a smarter one
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev h <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Help' : 'h')<CR>
" }}}

" ======================================================================
" Plugin configurations {{{
" ======================================================================

" Tell the NERDTree to respect 'wildignore'
let NERDTreeRespectWildIgnore=1

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

" lightline settings
let g:lightline = {}
let g:lightline.enable = {
            \ 'statusline': 0,
            \ 'tabline': 1
            \ }

" vim-go
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_list_type = "quickfix"
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
" au FileType go setlocal omnifunc=go#complete#GocodeComplete

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" UltiSnips
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "gosnippets/UltiSnips"]
" }}}

" ======================================================================
" Helper functions {{{
" ======================================================================

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
        if !bufexists(b) || bufname(b) ==# "GoToFile"
            continue
        endif
        if !has_key(visible, b)
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

" Damian Conway's Vim setup
function! s:trimtrailingws()
    if search('\s\+$', 'cnw')
        :%s/\s\+$//g
    endif
endfunction

" vim-go
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

" }}}
