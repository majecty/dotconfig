# make local nvim configs lazy plugins

완료 날짜: 2026-02-08

## 설명
로컬 nvim 설정들을 lazy.nvim 패키지 구조로 리팩토링했습니다.

## 작업 내용
- `nvim/lua/packages/settings/` 디렉토리 생성: 핵심 neovim 설정 (leader, clipboard, keymaps)
- `nvim/lua/packages/terminal/` 디렉토리 생성: 터미널 모드 설정
- 각 패키지를 lazy.nvim의 `dir` 옵션으로 로드
- init.lua를 최소화 (단 `require('config.lazy')` 만 포함)

## 구조
```
nvim/lua/packages/
├── settings/
│   └── init.lua
└── terminal/
    └── init.lua

nvim/lua/plugins/
├── settings.lua  (lazy spec)
└── terminal.lua  (lazy spec)
```

## 결과
- init.lua에서 직접 import할 필요 없음
- lazy.nvim이 자동으로 로드
- 각 패키지는 독립적으로 관리 가능
