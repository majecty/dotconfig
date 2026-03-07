# Minimal Fugitive 학습 계획

> Neovim 플러그인 개발을 통해 Git 명령어 인터페이스를 직접 구현하며 학습

## 학습 목표

- Neovim Lua 플러그인 개발의 기초 이해
- fugitive의 핵심 기능과 동작 원리 파악
- git porcelain 명령어와 Vim 인터페이스 연동 방법 학습
- 실전 프로젝트를 통한 Lua/Neovim API 숙련

---

## 파일 구조

```
nvim/lua/plugins/fugitive-clone.lua    -- lazy.nvim 설정, JGit 명령어 등록
nvim/lua/fugitive-clone/             -- lua/ 바로 아래 위치 (require 'fugitive-clone')
├── init.lua                         -- 메인 모듈, 명령어 핸들러
├── status.lua                       -- git status 기능 구현 중
└── async.lua                        -- Minimal async wrapper (코루틴 학습용)
```

## 커밋 히스토리

- `611d07c` - Add minimal-fugitive learning plan and scaffold
- `bb63163` - Update fugitive-clone with user command improvements
- `04e7fe2` - Restructure fugitive-clone: move to lua/fugitive-clone, update docs
- `08ca026` - Update docs and fugitive-clone status module

---

## 학습 단계

### Phase 1: 기초 다지기 (1-2주)

**학습 내용:**
- Neovim 플러그인 구조 이해 (lua/, plugin/ 디렉토리)
- Lua 기본 문법과 Neovim API (vim.api, vim.fn)
- vim.cmd로 git 명령어 실행하기
- 버퍼와 창(window) 조작 기초

**실습 프로젝트:**
```
nvim-minimal-fugitive/
├── lua/
│   └── minimal_fugitive/
│       ├── init.lua          -- 메인 모듈
│       └── core.lua          -- 핵심 로직
└── plugin/
    └── minimal_fugitive.lua  -- 명령어 등록
```

**구현 기능:**
- `:MGit <command>` - 기본적인 git 명령어 실행
- 결과를 새 버퍼에 표시하기

---

### Phase 2: Git Status 구현 (2-3주)

**학습 내용:**
- git status 출력 파싱하기
- 플로팅 윈도우(floating window) 또는 스플릿 창 생성
- 파일 상태 아이콘/색상 표시
- 버퍼에서 파일 선택 (cursor position 활용)

**구현 기능:**
- `:MGit status` 또는 `:MGitStatus` - 상태 창 열기
- unstaged/staged 파일 구분 표시
- 파일 목록에서 `Enter` 키로 파일 열기
- `u` 키로 unstaged 파일 stage하기

---

### Phase 3: Diff 기능 (2주)

**학습 내용:**
- git diff 출력 파싱
- diff 형식 분석 (@@ 라인, +-, context)
- Vim의 diff 모드 활용 또는 수동 diff 하이라이팅
- 사이드바이사이드(sidediff) vs 통합(unified) diff

**구현 기능:**
- `:MGit diff` - 현재 파일의 unstaged diff
- `:MGit diff <filepath>` - 특정 파일 diff
- diff 뷰에서 `q`로 닫기
- hunk 단위 스테이징 (선택적)

---

### Phase 4: Commit 기능 (2주)

**학습 내용:**
- git commit 인터페이스 설계
- 커밋 메시지 입력을 위한 임시 버퍼
- staged 파일 목록 표시
- commit 후 결과 처리

**구현 기능:**
- `:MGit commit` - 커밋 버퍼 열기
- 커밋 메시지 작성 후 `:wq`로 커밋
- 빈 메시지는 커밋 취소
- 커밋 실패 시 에러 표시

---

### Phase 5: Blame 기능 (2주)

**학습 내용:**
- git blame 출력 파싱 (커밋 해시, 작성자, 시간, 라인)
- 현재 버퍼와 blame 결과 동기화
- 가상 텍스트(virtual text) 또는 별도 창 활용

**구현 기능:**
- `:MGit blame` - 현재 파일 blame 표시
- 커밋 해시로 커밋 정보 조회 (선택적)
- 작성자별 색상 구분 (선택적)

---

### Phase 6: 추가 기능 및 Polish (2-3주)

**선택적 기능:**
- `:MGit log` - 간단한 로그 뷰
- `:MGit branch` - 브랜치 목록 및 전환
- Telescope.nvim 통합 (선택적)
- 키맵 자동 설정 (autocmd 활용)
- 설정 옵션 지원 (icons, default keymaps)

---

## 참고 자료

### 공식 문서
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [Neovim API Reference](https://neovim.io/doc/user/api.html)
- [fugitive.vim GitHub](https://github.com/tpope/vim-fugitive)

### 학습 예시
- [git-blame.nvim](https://github.com/f-person/git-blame.nvim) - 단순 blame 구현
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - 현대적인 git 플러그인
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) - diff 인터페이스

### 핵심 Neovim API 함수
```lua
-- 프로세스 실행
vim.fn.system('git status')
vim.fn.jobstart('git status', {
  on_stdout = function(_, data) ... end
})

-- 버퍼/창 조작
vim.api.nvim_create_buf(false, true)
vim.api.nvim_open_win(buf, true, {
  relative = 'editor',
  width = 80,
  height = 20,
  row = 10,
  col = 10,
  style = 'minimal',
  border = 'rounded'
})

-- 하이라이팅
vim.api.nvim_buf_add_highlight(buf, ns_id, 'GitAdded', line, col_start, col_end)

-- 자동 명령
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  callback = function() ... end
})
```

---

## 프로젝트 진행 팁

1. **작게 시작하기**: Phase 1만 완성해도 큰 성취입니다
2. **매일 조금씩**: 30분이라도 매일 코딩하는 게 중요합니다
3. **fugitive 소스 읽기**: tpope의 코드에서 패턴과 철학을 배우세요
4. **직접 써보기**: 자신의 플러그인으로 실제 git 작업을 해보세요
5. **단계별 커밋**: 각 Phase 완료 시 git에 커밋하세요 (메타학습!)

---

## 학습 체크리스트

### Phase 1
- [x] 플러그인 기본 구조 설정 (lazy.nvim + nvim_create_user_command)
- [x] `:JGit` 명령어가 git 명령어를 실행함
- [x] `nargs`, `complete` 파라미터 학습 및 적용
- [ ] 결과를 버퍼에 출력함 (진행 중)

### Phase 2
- [ ] `:MGit status` 명령어 작동
- [ ] unstaged/staged 파일 구분 표시
- [ ] 파일 선택하여 열기

### Phase 3
- [ ] `:MGit diff` 명령어 작동
- [ ] diff 하이라이팅 적용

### Phase 4
- [ ] `:MGit commit` 명령어 작동
- [ ] 커밋 메시지 작성 및 커밋 수행

### Phase 5
- [ ] `:MGit blame` 명령어 작동
- [ ] blame 정보가 현재 버퍼와 동기화됨

---

## 다음 단계

**현재 진행 상황:** Phase 1 기본 구조 완료, git 결과 버퍼 출력 구현 필요

**지금 당장 할 일:**
1. `core.lua`에 `run_git_command()` 함수 구현
2. git 결과를 새 버퍼에 표시하는 `show_in_buffer()` 구현
3. `:JGit status` 테스트 후 커밋

**학습한 내용 정리:**
- `nvim_create_user_command`의 `nargs` (`*`, `+`, `?`, `1` 차이)
- `complete` 함수 시그니처 (`arglead`, `cmdline`, `cursorpos`)
- Lua 함수 vs `v:lua.Function` 차이
