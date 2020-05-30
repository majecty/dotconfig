# Config 백업

vim이나 emacs, .zshrc등 다시 설정하기 귀찮은 설정파일들을 백업한다.

# zshenv, zshrc

~/.zshenv ~/.zshrc로 soft link를 만든다. zshenv는 non interactive, interactive 두 환경 모두에서 실행되는 스크립트다. zshrc는 interactive 환경에서만 실행된다.

```
ln -s -r zshenv $HOME/.zshenv
ln -s -r zshrc $HOME/.zshrc
```

# tmux.conf

```
ln -s -r tmux.conf $HOME/.tmux.conf
```
