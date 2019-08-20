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
nnoremap <C-o> <C-t>

" Git
au BufNewFile,BufRead *.git/COMMIT_EDITMSG setlocal spell spelllang=en_us

function ClangFormat()
  let l:lines="all"
  let g:clang_format_fallback_style="Google"
  if has('mac')
    if has('python3')
      py3f /usr/local/share/clang/clang-format.py
    else
      pyf /usr/local/share/clang/clang-format.py
    endif
  endif
endfunction
augroup cpp-clangformat
  autocmd!
  autocmd FileType c,cpp,objc map <C-K> :call ClangFormat()<CR>
  autocmd FileType c,cpp,objc imap <C-K> <c-o>:call ClangFormat()<CR>
augroup END

function ClangFormatOnSave()
  let l:formatdiff = 1
  if has('mac')
    if has('python3')
      py3f /usr/local/share/clang/clang-format.py
    else
      pyf /usr/local/share/clang/clang-format.py
    endif
  endif
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call ClangFormatOnSave()

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
autocmd FileType swift map <C-K> :call SwiftIndent()<CR>
autocmd FileType swift imap <C-K> <c-o>:call SwiftIndent()<CR>

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
call neobundle#end()
filetype plugin indent on
NeoBundleCheck

let g:airline_powerline_fonts = 1