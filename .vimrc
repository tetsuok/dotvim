syntax on
set autoindent
set enc=utf-8
set fileencodings=utf-8
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start
set laststatus=2
set statusline=%F%r%h%=
set autochdir
set visualbell t_vb=
set listchars=trail:~
set cursorline

hi Comment ctermfg=grey guifg=grey20
hi MatchParen term=standout ctermbg=LightGrey ctermfg=Black guibg=LightGrey guifg=Black
hi StatusLineNC cterm=bold ctermbg=DarkGrey ctermfg=white
hi StatusLine term=none cterm=none ctermfg=white ctermbg=darkgrey
hi Search term=none cterm=none ctermfg=white ctermbg=darkgreen
hi Pmenu ctermbg=white ctermfg=black
hi PmenuSel ctermbg=gray ctermfg=black
colorscheme jellybeans

filetype plugin indent on

" Make ctags behave like GNU Global
nnoremap <C-j> <C-]>
nnoremap <C-]> g<C-]>
"nnoremap <C-o> <C-t>

" Git
au BufNewFile,BufRead *.git/COMMIT_EDITMSG setlocal spell spelllang=en_us

function ClangFormat()
  let l:lines="all"
  let g:clang_format_fallback_style="Google"
  if has('mac')
    if has('python3')
      py3f /usr/local/share/clang/clang-format.py
    else
      pyf /usr/share/clang/clang-format/clang-format.py
    endif
  endif
endfunction

let g:clang_format_fallback_style="Google"
augroup cpp-clangformat
  autocmd!
  autocmd FileType c,cpp,objc map <C-y> :call ClangFormat()<CR>
  autocmd FileType c,cpp,objc imap <C-y> <c-o>:call ClangFormat()<CR>
  if has('mac')
    autocmd FileType c,cpp,objc map <C-I> :py3f /usr/local/share/clang/clang-format.py<cr>
    autocmd FileType c,cpp,objc imap <C-I> <c-o>:py3f /usr/local/share/clang/clang-format.py<cr>
  else
    autocmd FileType c,cpp,objc map <C-I> :py3f /usr/share/clang/clang-format/clang-format.py<cr>
    autocmd FileType c,cpp,objc imap <C-I> <c-o>:py3f /usr/share/clang/clang-format/clang-format.py<cr>
  endif
augroup END

function ClangFormatOnSave()
  let l:formatdiff = 1
  if has('mac')
    if has('python3')
      py3f /usr/local/share/clang/clang-format.py
    else
      pyf /usr/share/clang/clang-format/clang-format.py
    endif
  endif
endfunction
autocmd BufWrite,FileWritePre,FileAppendPre *.h,*.cc,*.cpp call ClangFormatOnSave()

" Swift
au BufNewFile,BufRead *.swift setf swift
let g:swift_highlight_comments = 1
if has('mac')
  " TODO: Find out a better way to set the path to swift-format on macOS.
  let g:swift_format_path = "/Library/Developer/CommandLineTools/usr/bin/swift-format"
endif
function SwiftIndent()
  let l:lines ="all"
  " TODO: rename to swift-indent.py once swift-indent is officially shipped
  if has('python3')
    py3f ~/.vim/swift-format.py
  else
    pyf ~/.vim/swift-format.py
  endif
endfunction
autocmd FileType swift map <C-y> :call SwiftIndent()<CR>
autocmd FileType swift imap <C-y> <c-o>:call SwiftIndent()<CR>
autocmd FileType python noremap <C-y> :call yapf#YAPF()<CR>
autocmd FileType python imap <C-y> <c-o>:call yapf#YAPF()<CR>

let g:autopep8_disable_show_diff=1

" Go
let g:go_fmt_command = "goimports"

" NeoBundle
if &compatible
  set nocompatible " Be iMproved
endif
set rtp^=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }
NeoBundle 'tell-k/vim-autopep8'
NeoBundle 'fatih/vim-go'
NeoBundle 'cohama/lexima.vim'
NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
NeoBundle 'junegunn/fzf.vim'
call neobundle#end()
filetype plugin indent on
NeoBundleCheck

let g:airline_powerline_fonts = 1

" neosnippet
let g:neosnippet#snippets_directory='~/.vim/mysnippets'
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
"
" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let mapleader = ","
let maplocalleader = ","

" fzf
set rtp+=~/.fzf/bin/fzf
set rtp+=~/.fzf
nmap ; :Buffers<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>t :Files<CR>
let g:fzf_buffers_jump = 1

call plug#begin()
Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
call plug#end()
