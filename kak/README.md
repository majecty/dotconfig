# Kak config

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

