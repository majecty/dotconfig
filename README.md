# Config 백업

vim이나 emacs, .zshrc등 다시 설정하기 귀찮은 설정파일들을 백업한다.

# zshenv, zshrc, commonenv.sh

~/.zshenv ~/.zshrc로 soft link를 만든다. zshenv는 non interactive,
interactive 두 환경 모두에서 실행되는 스크립트다. zshrc는 interactive
환경에서만 실행된다.

.commonenv.sh는 그래픽 환경과 터미널 환경에서 공통으로 사용하는 PATH
설정 스크립트다. .zshenv와 .xsessionrc가 이를 실행한다. Posix shell
문법만 사용한다.

```
ln -s -r zshenv $HOME/.zshenv
ln -s -r zshrc $HOME/.zshrc
ln -srb commonenv.sh $HOME/.commonenv.sh
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

