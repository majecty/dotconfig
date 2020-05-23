if [ -e ~/.vimrc ]
    then cp ~/.vimrc ~/.vimrc.backup
fi

cp ./vimrc ~/.vimrc
ln -s `pwd`/vim-include $HOME/.vim/vim-include
ln -s `pwd`/vim-include-ordered $HOME/.vim/vim-include-ordered
ln -s `pwd`/UltiSnips $HOME/.vim/UltiSnips

mkdir -p $HOME/.config/nvim
if [ -e ~/.config/nvim/coc-settings.json ]
    then cp ~/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json.backup
fi
ln -s `pwd`/coc-settings.json $HOME/.config/nvim/coc-settings.json
