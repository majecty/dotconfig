" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

Plug 'mhinz/vim-startify'
" table formating like | 1 | 2 | 3 |
Plug 'godlygeek/tabular'
" continuously updated session files
Plug 'tpope/vim-obsession'
Plug 'thaerkh/vim-workspace'
Plug 'simnalamburt/vim-mundo'
" Run commandline async + build
Plug 'tpope/vim-dispatch'
"Plug 'fholgado/minibufexpl.vim'
Plug 'mattn/emmet-vim'
Plug 'lambdalisue/suda.vim'
Plug 'scrooloose/nerdcommenter'
" Print documents in echo area
Plug 'shougo/echodoc'
" move up -
Plug 'tpope/vim-vinegar'
" change calmelCase PasCal
Plug 'idanarye/vim-casetrate'
" Plug 'scrooloose/nerdtree'
Plug 'roy2220/easyjump.tmux'
" <f5> c-f c-b c-d c-r
Plug 'ctrlpvim/ctrlp.vim'
Plug 'https://github.com/Iron-E/vim-libmodal'
" use f to use multiple f
Plug 'https://github.com/rhysd/clever-f.vim'
Plug 'easymotion/vim-easymotion'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'ldelossa/litee.nvim'
Plug 'ldelossa/litee-calltree.nvim'
Plug 'ldelossa/litee-symboltree.nvim'
Plug 'ldelossa/litee-filetree.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

Plug 'vimwiki/vimwiki'

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'github/copilot.vim', { 'branch': 'release' }

Plug 'plasticboy/vim-markdown'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'othree/html5.vim'
Plug 'raichoo/purescript-vim'

Plug 'tomasr/molokai'
Plug 'rakr/vim-one'
Plug 'morhetz/gruvbox'

" (Optional) Multi-entry selection UI.
call plug#end()
