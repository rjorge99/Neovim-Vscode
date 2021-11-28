call plug#begin('~/.config/nvim/autoload/plugged')
    Plug 'sheerun/vim-polyglot'             " Better Syntax Support
    Plug 'scrooloose/NERDTree'              " File Explorer
    Plug 'jiangmiao/auto-pairs'             " Auto pairs for '(' '[' '{'
    Plug 'christianchiarulli/nvcode-color-schemes.vim'  " Visual Code Color Scheme
    Plug 'nvim-treesitter/nvim-treesitter'  " Code highlighting
    Plug 'vim-airline/vim-airline'          " Status Bar
    Plug 'vim-airline/vim-airline-themes'   " Status Bar theme
    Plug 'https://github.com/xiyaowong/nvim-transparent'    " Transparent  background
    Plug 'neoclide/coc.nvim', {'branch': 'release'}         " Intelisense   
    Plug 'tomasiser/vim-code-dark'          " Colorscheme CodeDark 

    " if exists('g:vscode')
        Plug 'asvetliakov/vim-easymotion'
    " endif
call plug#end()