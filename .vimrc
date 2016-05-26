set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" auto complete
Plugin 'YouCompleteMe'

" linter
Plugin 'syntastic'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line





















syntax on
"colorscheme badwolf
colorscheme hybrid_jay
"colorscheme molokai

set directory=$HOME/.vim/swap//
if !isdirectory(&directory)
  call mkdir(&directory)
endif

set backupdir=$HOME/.vim/backup//
if !isdirectory(&backupdir)
  call mkdir(&backupdir)
endif

set backupcopy=yes
set backup

set number



" let terminal resize scale the internal windows
autocmd VimResized * :wincmd =


" This moves the matches for your search to the center of the screen when you
" press n or N so it is easier to identify where you are in your document.
nnoremap n nzz
nnoremap N Nzz



" With this snippet you can open file that you just edited and do undo from
" previous session.
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo


" Whenever you open up a read only file you have to either reopen vim with
" sudo or remember a vim command to write out to a new file with sudo. This
" mapping expands:w!! to :w !sudo tee % > /dev/null
cnoremap w!! w !sudo tee % >/dev/null

" use ; instead of :
nnoremap ; :



" I select everything in a file far more than I increment an integer! Why not
" make CTRL-A do what it does in almost every other program?
nmap <C-a> ggVG

" CTRL-C doesn't do anything valuable in Normal mode. Why not map it to what
" it does in almost every other program?
vmap <C-c> "+y




"set AirlineTheme murmur
let g:airline_powerline_fonts = 1
let g:airline_theme = 'murmur'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 1
set list          " Display unprintable characters f12 - switches
set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping
"let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long', 'mixed-indent-file' ]
let g:airline#extensions#whitespace#checks = [ 'indent', 'mixed-indent-file' ]
" <Leader>number: Select the tab of index equal to number.
let mapleader = "\\"
nmap <Leader>1 :b1<CR>
nmap <Leader>2 :b2<CR>
nmap <Leader>3 :b3<CR>
nmap <Leader>4 :b4<CR>
nmap <Leader>5 :b5<CR>
nmap <Leader>6 :b6<CR>
nmap <Leader>7 :b7<CR>
nmap <Leader>8 :b8<CR>
nmap <Leader>9 :b9<CR>
nmap <Leader>- :bprevious<CR>
nmap <Leader>+ :bnext<CR>
" :bnext
" :bprevious
" :bfirst
" :blast
" :b10
" :b <buffer-name>




set rtp+=$HOME/.local/lib/python3.5/site-packages/powerline/bindings/vim/

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256
" colours)
set t_Co=256
