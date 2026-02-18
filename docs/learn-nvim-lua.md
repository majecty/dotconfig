# Neovim Lua API 기초 학습 가이드

이 마크다운 파일은 Neovim에서 실행 가능한 Lua 코드 블록을 포함합니다.
**`Enter` 키를 눌러서 코드 블록을 실행하세요!**

---

## 1. Neovim의 글로벌 객체

Neovim은 Lua에 `vim` 글로벌 객체를 제공합니다.
이것이 Neovim API에 접근하는 주요 방법입니다.

```lua
-- vim 객체의 주요 모듈 확인
print("vim 객체의 주요 모듈:")
print("  vim.api   - 저수준 API (nvim_* 함수들)")
print("  vim.fn    - Vim 스크립트 함수")
print("  vim.cmd   - Ex 명령어 실행")
print("  vim.opt   - 옵션 설정")
print("  vim.keymap - 키맵 등록")
print("  vim.bo    - 버퍼 옵션")
print("  vim.wo    - 윈도우 옵션")
print("  vim.g     - 글로벌 변수")
print("  vim.b     - 버퍼 변수")
print("  vim.w     - 윈도우 변수")
```

---

## 2. 버퍼(Buffer) 기초

버퍼는 편집 중인 파일의 메모리 표현입니다.

### 2.1 현재 버퍼 정보 얻기

```lua
-- 현재 버퍼 번호
local bufnr = vim.api.nvim_get_current_buf()
print("현재 버퍼 번호: " .. bufnr)

-- 버퍼 이름 (파일 경로)
local bufname = vim.api.nvim_buf_get_name(bufnr)
print("버퍼 이름: " .. bufname)

-- 버퍼가 수정되었는지 확인
local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
print("수정됨: " .. tostring(modified))
```

### 2.2 버퍼의 모든 라인 읽기

```lua
-- 현재 버퍼의 모든 라인 읽기
local bufnr = vim.api.nvim_get_current_buf()
local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

print("총 라인 수: " .. #lines)
print("\n처음 3개 라인:")
for i = 1, math.min(3, #lines) do
  print(string.format("  [%d] %s", i, lines[i]))
end
```

### 2.3 버퍼에 텍스트 쓰기

```lua
-- 새 버퍼 생성
local new_buf = vim.api.nvim_create_buf(false, false)
print("새 버퍼 생성: #" .. new_buf)

-- 텍스트 쓰기
vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, {
  "첫 번째 라인",
  "두 번째 라인",
  "세 번째 라인"
})

print("텍스트 작성 완료!")
print("버퍼 #" .. new_buf .. "에 3개 라인 작성됨")
```

### 2.4 특정 라인 범위 읽기

```lua
-- 현재 버퍼에서 특정 범위 읽기 (0-indexed)
local bufnr = vim.api.nvim_get_current_buf()
local start_line = 0
local end_line = 5

local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

print("라인 " .. start_line .. "~" .. end_line .. ":")
for i, line in ipairs(lines) do
  print(string.format("  %s", line))
end
```

---

## 3. 윈도우(Window) 기초

윈도우는 버퍼를 보여주는 뷰포트입니다.

### 3.1 현재 윈도우 정보

```lua
-- 현재 윈도우 ID
local win = vim.api.nvim_get_current_win()
print("현재 윈도우 ID: " .. win)

-- 윈도우에 표시되는 버퍼
local bufnr = vim.api.nvim_win_get_buf(win)
print("윈도우 #" .. win .. "의 버퍼: #" .. bufnr)

-- 윈도우 크기
local height = vim.api.nvim_win_get_height(win)
local width = vim.api.nvim_win_get_width(win)
print("윈도우 크기: " .. width .. " x " .. height)

-- 커서 위치 (row, col) - 1-indexed
local cursor = vim.api.nvim_win_get_cursor(win)
print("커서 위치: 라인 " .. cursor[1] .. ", 열 " .. cursor[2])
```

### 3.2 모든 윈도우 나열

```lua
-- 모든 윈도우 나열
local windows = vim.api.nvim_list_wins()
print("열린 윈도우 수: " .. #windows)

for i, win in ipairs(windows) do
  local bufnr = vim.api.nvim_win_get_buf(win)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  print(string.format("  [%d] 윈도우 #%d -> 버퍼 #%d (%s)", i, win, bufnr, bufname))
end
```

### 3.3 새 윈도우 열기

```lua
-- 새 버퍼 생성
local buf = vim.api.nvim_create_buf(false, false)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
  "새 윈도우에 표시될 텍스트",
  "두 번째 라인",
})

-- 부동(floating) 윈도우로 열기
local win = vim.api.nvim_open_win(buf, false, {
  relative = "cursor",
  row = 1,
  col = 0,
  width = 40,
  height = 5,
  border = "rounded",
})

print("부동 윈도우 생성: #" .. win)
print("버퍼: #" .. buf)
```

---

## 4. 커서(Cursor) 조작

### 4.1 커서 위치 변경

```lua
-- 현재 윈도우에서 커서를 특정 위치로 이동
local win = vim.api.nvim_get_current_win()

-- 라인 5, 열 10으로 이동 (1-indexed)
vim.api.nvim_win_set_cursor(win, {5, 10})

local cursor = vim.api.nvim_win_get_cursor(win)
print("커서 이동: 라인 " .. cursor[1] .. ", 열 " .. cursor[2])
```

### 4.2 상대적 커서 이동

```lua
-- 현재 커서 위치 가져오기
local win = vim.api.nvim_get_current_win()
local cursor = vim.api.nvim_win_get_cursor(win)
local row, col = cursor[1], cursor[2]

print("현재 커서: 라인 " .. row .. ", 열 " .. col)

-- 아래로 3줄 이동
vim.api.nvim_win_set_cursor(win, {row + 3, col})
print("3줄 아래로 이동했습니다")
```

---

## 5. 옵션(Option) 설정

### 5.1 글로벌 옵션

```lua
-- 글로벌 옵션 읽기
local number = vim.o.number
local tabstop = vim.o.tabstop
local background = vim.o.background

print("현재 옵션:")
print("  number: " .. tostring(number))
print("  tabstop: " .. tabstop)
print("  background: " .. background)
```

### 5.2 글로벌 옵션 변경

```lua
-- 글로벌 옵션 설정
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

print("옵션 변경:")
print("  number = " .. tostring(vim.o.number))
print("  tabstop = " .. vim.o.tabstop)
print("  shiftwidth = " .. vim.o.shiftwidth)
```

### 5.3 버퍼 옵션

```lua
-- 현재 버퍼 옵션 읽기
local bufnr = vim.api.nvim_get_current_buf()
local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
local buflisted = vim.api.nvim_buf_get_option(bufnr, "buflisted")

print("버퍼 #" .. bufnr .. " 옵션:")
print("  filetype: " .. filetype)
print("  buflisted: " .. tostring(buflisted))
```

### 5.4 버퍼 옵션 변경

```lua
-- 버퍼 옵션 설정
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")

print("버퍼 #" .. bufnr .. "의 filetype을 'markdown'으로 변경")
```

### 5.5 윈도우 옵션

```lua
-- 윈도우 옵션 읽기
local win = vim.api.nvim_get_current_win()
local number = vim.api.nvim_win_get_option(win, "number")
local cursorline = vim.api.nvim_win_get_option(win, "cursorline")

print("윈도우 #" .. win .. " 옵션:")
print("  number: " .. tostring(number))
print("  cursorline: " .. tostring(cursorline))
```

---

## 6. Ex 명령어 실행

### 6.1 vim.cmd로 명령어 실행

```lua
-- 간단한 명령어 실행
print("'set number' 명령어 실행...")
vim.cmd("set number")

print("'set norelativenumber' 명령어 실행...")
vim.cmd("set norelativenumber")

print("명령어 실행 완료!")
```

### 6.2 복잡한 명령어

```lua
-- 현재 버퍼를 새 탭에서 열기
print("새 탭 생성...")
vim.cmd("tabnew")

-- 현재 버퍼 정보
local bufnr = vim.api.nvim_get_current_buf()
local bufname = vim.api.nvim_buf_get_name(bufnr)

print("새 탭에서 열린 버퍼: #" .. bufnr)
print("버퍼 이름: " .. bufname)
```

---

## 7. 키맵 등록

### 7.1 기본 키맵 설정

```lua
-- 현재 버퍼에 키맵 등록
local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>t", function()
  print("✓ 키맵 실행됨! (leader + t)")
end, { buffer = bufnr, desc = "Test keymap" })

print("키맵 등록: <leader>t")
print("이 버퍼에서 <leader>t를 눌러보세요!")
```

### 7.2 여러 모드에 키맵 등록

```lua
-- Normal, Insert 모드에 키맵 등록
local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set({"n", "i"}, "<C-j>", function()
  print("Ctrl+J 눌림!")
end, { buffer = bufnr, desc = "Test in N and I mode" })

print("키맵 등록: <C-j> (Normal, Insert 모드)")
```

---

## 8. 변수 관리

### 8.1 글로벌 변수

```lua
-- 글로벌 변수 설정
vim.g.my_var = "안녕하세요"
vim.g.my_number = 42

print("글로벌 변수 설정:")
print("  vim.g.my_var = " .. vim.g.my_var)
print("  vim.g.my_number = " .. vim.g.my_number)

-- 글로벌 변수 읽기
print("\n글로벌 변수 읽기:")
print("  vim.g.my_var = " .. vim.g.my_var)
```

### 8.2 버퍼 변수

```lua
-- 버퍼 변수 설정
local bufnr = vim.api.nvim_get_current_buf()
vim.b.my_buffer_var = "버퍼 전용 데이터"
vim.b.counter = 1

print("버퍼 #" .. bufnr .. "에 변수 설정:")
print("  vim.b.my_buffer_var = " .. vim.b.my_buffer_var)
print("  vim.b.counter = " .. vim.b.counter)
```

### 8.3 윈도우 변수

```lua
-- 윈도우 변수 설정
local win = vim.api.nvim_get_current_win()
vim.w.my_window_var = "윈도우 전용 데이터"

print("윈도우 #" .. win .. "에 변수 설정:")
print("  vim.w.my_window_var = " .. vim.w.my_window_var)
```

---

## 9. 알림과 입력

### 9.1 알림 메시지

```lua
-- 일반 알림
vim.notify("이것은 정보 알림입니다", vim.log.levels.INFO)

-- 경고
vim.notify("이것은 경고입니다", vim.log.levels.WARN)

-- 에러
vim.notify("이것은 에러입니다", vim.log.levels.ERROR)

print("알림 메시지 3개 표시됨")
```

### 9.2 사용자 입력

```lua
-- 사용자에게 선택지 제시
local choice = vim.fn.confirm("어느 옵션을 선택하시겠습니까?", "&Yes\n&No\n&Cancel")

if choice == 1 then
  print("Yes를 선택했습니다")
elseif choice == 2 then
  print("No를 선택했습니다")
elseif choice == 3 then
  print("Cancel을 선택했습니다")
else
  print("선택이 취소되었습니다")
end
```

---

## 10. 파일타입 감지

### 10.1 파일타입 확인

```lua
-- 현재 버퍼의 파일타입 확인
local bufnr = vim.api.nvim_get_current_buf()
local filetype = vim.bo[bufnr].filetype

print("현재 버퍼의 파일타입: " .. filetype)

-- 파일타입에 따른 처리
if filetype == "markdown" then
  print("마크다운 파일입니다!")
elseif filetype == "lua" then
  print("Lua 파일입니다!")
else
  print("기타 파일타입: " .. filetype)
end
```

### 10.2 파일타입 변경

```lua
-- 파일타입 변경
local bufnr = vim.api.nvim_get_current_buf()
vim.bo[bufnr].filetype = "lua"

print("파일타입을 'lua'로 변경했습니다")
print("현재 파일타입: " .. vim.bo[bufnr].filetype)
```

---

## 11. 간단한 플러그인 예제

### 11.1 현재 시간 삽입하는 함수

```lua
-- 함수 정의
function InsertTimestamp()
  local timestamp = vim.fn.strftime("%Y-%m-%d %H:%M:%S")
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  
  -- 현재 라인 다음에 시간 삽입
  vim.api.nvim_buf_set_lines(bufnr, cursor[1], cursor[1], false, {
    "# 작성 시간: " .. timestamp
  })
  
  print("타임스탬프 삽입: " .. timestamp)
end

-- 함수 실행
InsertTimestamp()
```

### 11.2 통계 출력 함수

```lua
-- 버퍼 통계 함수
function BufferStats()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  local char_count = 0
  for _, line in ipairs(lines) do
    char_count = char_count + #line
  end
  
  print("버퍼 통계:")
  print("  라인 수: " .. #lines)
  print("  총 문자 수: " .. char_count)
  print("  평균 라인 길이: " .. math.floor(char_count / #lines))
end

-- 함수 실행
BufferStats()
```

---

## 12. 연습: 간단한 명령어 만들기

### 12.1 텍스트 변환 함수

```lua
-- 현재 라인을 대문자로 변환하는 함수
function ToUpperLine()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor[1] - 1  -- 0-indexed
  
  local lines = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)
  if #lines > 0 then
    local upper_line = lines[1]:upper()
    vim.api.nvim_buf_set_lines(bufnr, line_num, line_num + 1, false, {upper_line})
    print("라인을 대문자로 변환했습니다")
  end
end

-- 함수 실행
ToUpperLine()
```

### 12.2 여러 함수 조합

```lua
-- 유틸리티 함수들
local Utils = {}

function Utils.get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, cursor[1] - 1, cursor[1], false)
  return lines[1] or ""
end

function Utils.get_word_under_cursor()
  return vim.fn.expand("<cword>")
end

function Utils.get_selection()
  return vim.fn.getregcharpos('"v")
end

-- 함수 테스트
print("현재 라인: " .. Utils.get_current_line())
print("커서 아래 단어: " .. Utils.get_word_under_cursor())
```

---

## 요약

지금까지 배운 내용:

1. **vim 글로벌 객체** - Neovim API 진입점
2. **버퍼 조작** - 텍스트 읽기/쓰기
3. **윈도우 조작** - 화면 분할, 뷰포트 관리
4. **커서 제어** - 위치 이동, 조회
5. **옵션 설정** - 글로벌/버퍼/윈도우 옵션
6. **명령어 실행** - Ex 명령어 실행
7. **키맵 등록** - 사용자 정의 단축키
8. **변수 관리** - 글로벌/버퍼/윈도우 변수
9. **사용자 상호작용** - 알림, 입력
10. **파일타입** - 파일 타입 감지 및 설정
11. **플러그인 작성** - 간단한 함수 만들기

---

## 다음 단계

더 배울 수 있는 주제들:

- **오토커맨드(Autocommands)** - 이벤트 기반 자동화
- **하이라이트(Highlights)** - 색상 및 스타일 설정
- **간편본(Marks)** - 버퍼 내 북마크
- **검색과 치환** - 찾기 및 바꾸기 기능
- **매크로** - 명령어 기록 및 재생

