---
name: make-verylazy-local
description: 네오빔 설정에서 로컬(내부) 패키지를 `VeryLazy` 이벤트로 지연 로드하도록 구성하는 방법을 문서화한 스킬입니다.
---

# 로컬 VeryLazy 플러그인 만들기

이 스킬은 네오빔 설정 저장소(예: `~/jhconfig`)에서 로컬 디렉터리로 존재하는 패키지/모듈을 플러그인 매니저에 등록하고 `VeryLazy` 이벤트로 지연 로드하는 권장 절차와 검증 방법을 제공합니다.

## Process

### 1. 준비
- 로컬 패키지 코드를 `nvim/lua/packages/<package-dir>/...` 또는 `nvim/lua/packages/<module>.lua`에 둡니다.

### 2. 플러그인 스펙에 등록
- 플러그인 스펙 파일(`nvim/lua/plugins/*.lua`)에서 `dir`, `name`, `event = 'VeryLazy'`를 사용해 로컬 경로를 지정합니다.

### 3. 초기화/구성
- `config` 콜백에서 `require('packages.<module>')`로 모듈을 불러와 `setup()` 또는 초기화 함수를 호출합니다.

### 4. 검증
- 네오빔을 재시작하고 VeryLazy 이벤트 이후에 모듈이 로드되는지 확인합니다.

## Example

플러그인 스펙 예시(`nvim/lua/plugins/lua-executor.lua`):

```lua
return {
  {
    dir = '~/jhconfig/nvim/lua/packages/lua-executor',
    name = 'lua-executor',
    event = 'VeryLazy',
    config = function()
      vim.notify('로컬 VeryLazy 플러그인 로드됨', vim.log.levels.INFO)
      local executor = require('packages.lua-executor')
      if executor and executor.setup then
        executor.setup()
      end
    end,
  },
}
```

## Guidelines

**DO:**
- `dir`에 절대경로(또는 홈 확장 '~')를 사용해 명확하게 지정하세요.
- `name`은 플러그인 관리자나 로그에 표시될 고유 식별자를 사용하세요.
- `config`에서 `require('packages.<module>')` 경로가 실제 파일 위치와 일치하는지 확인하세요.

**DON'T:**
- 로컬 디렉터리를 플러그인 형태로 만들지 않고 단순한 파일 구조와 매니저의 기대 구조가 불일치하는 상태로 등록하지 마세요.

## 검증 방법

1. `nvim`으로 재시작
2. VeryLazy 이벤트 이후 확인:
   - `:lua print(vim.inspect(package.loaded['packages.lua-executor']))` — 로드된 테이블이면 성공
   - 또는 `vim.notify`로 남긴 알림 확인

## 테스트/디버깅 팁

- `:messages`로 시작 로그와 알림을 확인하세요.
- `dir` 경로와 파일 권한 확인: `ls -la ~/jhconfig/nvim/lua/packages/lua-executor`.
- `require` 경로가 파일 구조와 일치하는지 점검하세요 (`lua/packages/<module>.lua` -> `require('packages.<module>')`).

## 커밋/변경 규칙

- 변경 후 커밋 메시지는 간결하게: 예) `add skill: make-verylazy-local`.
- 변경 전 로컬에서 동작 검증 권장.

## 문의

- 이 스킬을 확장해 플러그인 템플릿을 자동 생성하는 스크립트가 필요하면 알려주세요.
