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
