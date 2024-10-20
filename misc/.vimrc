set tabstop=2
set shiftwidth=2
set expandtab
" Highlight current line
set cursorline

" Enable syntax highlighting
syntax on

" Set color scheme
colorscheme desert

set background=dark

" Enable auto-indentation
set autoindent
set smartindent

" Show matching parentheses
set showmatch

" Enable line wrapping
set wrap

" Set the width of a tab character
set tabstop=2

" Set the number of spaces to use for each step of (auto)indent
set shiftwidth=2

" Use spaces instead of tabs
set expandtab

" Enable mouse support
set mouse=a

" Enable clipboard support
set clipboard=unnamedplus

" Show line and column number in the status line
set ruler

" Show command in the bottom bar
set showcmd

" Highlight search results
set hlsearch

" Incremental search
set incsearch

" Ignore case in search patterns
set ignorecase

" Override ignorecase if search pattern contains uppercase letters
set smartcase

" Enable persistent undo
set undofile

" Set the maximum number of undo levels
set undolevels=1000

" Set the maximum number of changes that can be undone
set undoreload=10000

" Enable wildmenu
set wildmenu

" Set the height of the command bar
set cmdheight=2

" Enable line break at word boundaries
set linebreak

" Set the maximum width of text before wrapping
set textwidth=80

" Enable folding based on syntax
set foldmethod=syntax

" Automatically open folds less than a certain number of lines
set foldlevelstart=99

" Enable auto-completion menu
set completeopt=menuone,noselect

" Enable file type detection
filetype on

" Enable plugin and indent detection
filetype plugin indent on

" Set the default encoding
set encoding=utf-8

" Set the default file format
set fileformat=unix

" Set the default file encoding
set fileencodings=utf-8,latin1

" Enable backup files
set backup

" Set the directory for backup files
set backupdir=~/.vim/backup//

" Enable swap files
set swapfile

" Set the directory for swap files
set directory=~/.vim/swap//

" Enable command history
set history=1000

" Enable auto-read when a file is changed from outside
set autoread

" Enable hidden buffers
set hidden

" Enable split windows to appear below the current window
set splitbelow

" Enable split windows to appear to the right of the current window
set splitright

" Enable status line
set laststatus=2

" Enable 24-bit RGB color in the TUI
set termguicolors
highlight Normal ctermbg=NONE guibg=NONE

" Enable the status line
set laststatus=2

" Customize the status line to show the file name
set statusline=%f
