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

# kak

## kakrc 임포트하기

kak 설정파일이 ~/jhconfig/kak/kakrc 를 임포트하게 만들어야 한다.

```
# 예시
source "/home/juhyung/jhconfig/kak/kakrc"
```

## plugin 설치하기

kak을 켠 뒤 :plug-install을 실행한다.
kak-lsp의 경우 Rust 컴파일을 해야하므로 시간이 걸린다.

## kak 설치 스크립트

kak/install.sh 를 실행시키면 몇가지 설정 파일의 symbolic link를 설치한다.

