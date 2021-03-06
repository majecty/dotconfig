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
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

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
Plug '~/my-prototype-plugin'

Plug 'tpope/vim-fugitive'
Plug 'leafgarland/typescript-vim'

Plug 'vimwiki/vimwiki'
Plug 'mhinz/vim-startify'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-obsession'
Plug 'tomasr/molokai'
Plug 'thaerkh/vim-workspace'
Plug 'editorconfig/editorconfig-vim'
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-dispatch'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'fholgado/minibufexpl.vim'
Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'
Plug 'lambdalisue/suda.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'shougo/echodoc'
Plug 'tpope/vim-vinegar'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'idanarye/vim-casetrate'
Plug 'raichoo/purescript-vim'
Plug 'rakr/vim-one'
" (Optional) Multi-entry selection UI.
call plug#end()
