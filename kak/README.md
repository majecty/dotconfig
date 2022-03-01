# Kak config

## kakrc 임포트하기

kak 설정파일이 ~/jhconfig/kak/kakrc 를 임포트하게 만들어야 한다.
일반적으로 "~/.config/kak/kakrc" 파일을 사용한다.

```
# 예시
source "/home/juhyung/jhconfig/kak/kakrc"
```

## plug.kak 설치하기

```
mkdir -p $HOME/.config/kak/plugins
git clone https://github.com/andreyorst/plug.kak.git $HOME/.config/kak/plugins/plug.kak
```

## plugin 설치하기

kak을 켠 뒤 :plug-install을 실행한다.
kak-lsp의 경우 Rust 컴파일을 해야하므로 시간이 걸린다.

## kak 설치 스크립트

kak/install.sh 를 실행시키면 몇가지 설정 파일의 symbolic link를 설치한다.

## kak-lsp

kak-lsp.toml에 설정에 언어에 대한 설정이 저장된다.
~/.config/kak-lsp/kak-lsp.toml 파일이다.
자세한 내용은 [이 링크](https://github.com/kak-lsp/kak-lsp)에서 보자.

### kak lsp 상황 확인하기

:lsp capabilities
위 커맨드 호출해보기

/tmp/lsp_kak-lsp_log 확인하기
