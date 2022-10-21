set nocompatible
" required for vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'preservim/nerdtree'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'airblade/vim-gitgutter'

call vundle#end()
filetype plugin indent on
syntax on

"disable soft wraps
set nowrap
augroup WrapLine
	autocmd!
	autocmd FileType txt setlocal wrap
	autocmd FileType rst setlocal wrap
augroup End
" enable line numbers
set number relativenumber
set nu rnu
set ruler
set visualbell
set encoding=utf-8
set ttyfast

" always show mode status line
set laststatus=2
" always show mode
set showmode


inoremap jj <ESC>

set t_Co=256
