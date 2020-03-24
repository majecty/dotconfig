if [ -e file ]
    then cp ~/.vimrc ~/.vimrc.backup
fi

cp ./vimrc ~/.vimrc
ln -s `pwd`/vim-include $HOME/.vim/vim-include
ln -s `pwd`/vim-include-ordered $HOME/.vim/vim-include-ordered
