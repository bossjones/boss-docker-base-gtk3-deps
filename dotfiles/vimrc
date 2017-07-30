set nocompatible

set runtimepath-=~/.vim
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath-=~/.vim/after
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set background=dark
set backup
set backupdir=$XDG_CACHE_HOME/vim/backup//
set directory=$XDG_CACHE_HOME/vim/swap//
set fileencodings=ucs-bom,utf-8,latin1
set fileformat=unix
set foldlevelstart=1
set history=100
set modeline
set ruler
set spelllang=en_us
set tabstop=4
set textwidth=100
set viminfo='1000,n$XDG_CACHE_HOME/vim/viminfo

filetype plugin indent on
syntax on

call plug#begin('$XDG_CONFIG_HOME/vim/plugins')
Plug 'freitass/todo.txt-vim'
Plug 'ledger/vim-ledger'
Plug 'rust-lang/rust.vim'
call plug#end()
