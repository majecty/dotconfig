# Neovim Virtual Text 튜토리얼

이 마크다운 파일은 Neovim에서 실행 가능한 Lua 코드 블록을 포함합니다.
**`Enter` 키를 눌러서 코드 블록을 실행하세요!**

---

## 1. Virtual Text란?

Virtual Text는 버퍼의 텍스트 오른쪽(또는 아래)에 표시되는 가상 텍스트입니다.
실제 버퍼 내용에 영향을 주지 않고 추가 정보를 표시할 수 있습니다.

주요 용도:
- 에러/경고 표시
- LSPdiagnostics
- 코드 스니펫
- 커스텀 주석

---

## 2. extmarks 기초

Virtual Text는 Neovim의 extmarks API로 관리합니다.

### 2.1 extmarks 기본 정보

```lua
-- 현재 버퍼에서 extmarks 조회
local bufnr = vim.api.nvim_get_current_buf()
local marks = vim.api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, { details = true })

print("버퍼 #" .. bufnr .. "의 extmarks:")
print("  총 " .. #marks .. "개")
for i, mark in ipairs(marks) do
  print(string.format("    [%d] id=%d, line=%d, col=%d", i, mark[1], mark[2], mark[3]))
end
```

### 2.2 extmark 생성

```lua
local bufnr = vim.api.nvim_get_current_buf()

-- 간단한 extmark 생성
local ns_id = 1 -- 네임스페이스 ID (0은 기본 네임스페이스)
local cursor = vim.api.nvim_win_get_cursor(0)

line = cursor[1] - 1 -- 현재 줄 (0부터 시작)
col = cursor[2] -- 현재 열

local extmark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id,
    line, col, {
  virt_text = {{ "← 여기에 마크", "Comment" }},
  virt_text_pos = "eol",
})

print("extmark 생성: id=" .. extmark_id)
print("버퍼 #" .. bufnr .. "의 마지막 줄 끝에 표시됨")
```

### 2.3 extmark 삭제

```lua
local bufnr = vim.api.nvim_get_current_buf()

-- 특정 extmark 삭제
vim.api.nvim_buf_del_extmark(bufnr, 1, 1)

print("extmark id=1 삭제됨")
```

### 2.4 모든 extmark 삭제

```lua
local bufnr = vim.api.nvim_get_current_buf()

-- 모든 extmark 조회 후 하나씩 삭제
local marks = vim.api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, {})
for _, mark in ipairs(marks) do
  local ns_id = 1;
  local extmark_id = mark[1];
  vim.notify("삭제 중: " .. vim.inspect(mark))
  vim.api.nvim_buf_del_extmark(bufnr, ns_id, extmark_id)
end

print("버퍼 #" .. bufnr .. "의 " .. #marks .. "개 extmarks 삭제됨")
```

---

## 3. Virtual Text 생성

### 3.1 가장 간단한 Virtual Text (줄 끝)

```lua
local bufnr = vim.api.nvim_get_current_buf()

local ns_id = 1 -- 네임스페이스 ID (0은 기본 네임스페이스)
local cursor = vim.api.nvim_win_get_cursor(0)

line = cursor[1] - 1 -- 현재 줄 (0부터 시작)
col = cursor[2] -- 현재 열

vim.api.nvim_buf_set_extmark(bufnr,
  ns_id,
  line, col, {
  virt_text = {{ "Hello Virtual Text!", "String" }},
  virt_text_pos = "eol",
})

print("줄 끝에 virtual text 추가: 'Hello Virtual Text!'")
```

### 3.2줄 오른쪽에 표시

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  virt_text = {{ "→ 오른쪽", "Function" }},
  virt_text_pos = "right_align",
})

print("줄 오른쪽에 virtual text 추가")
```

### 3.3 Inline Virtual Text

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

-- 현재 줄의 특정 위치에 inline virtual text
vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  virt_text = {{ " [inline]", "Operator" }},
  virt_text_pos = "inline",
})

print("inline virtual text 추가")
```

---

## 4. Virtual Text 스타일링

### 4.1 기본 하이라이트 그룹

```lua
local bufnr = vim.api.nvim_get_current_buf()

local hl_groups = {
  "Error",
  "WarningMsg", 
  "MoreMsg",
  "String",
  "Comment",
  "Function",
  "Keyword",
}

local cursor = vim.api.nvim_win_get_cursor(0)
local start_line = cursor[1] - 1

print("사용 가능한 하이라이트 그룹:")
for i, hl in ipairs(hl_groups) do
  vim.api.nvim_buf_set_extmark(bufnr, 0, start_line + i - 1, 0, {
    virt_text = {{ "[" .. hl .. "]", hl }},
    virt_text_pos = "eol",
  })
end

print(#hl_groups .. "개의 다른 스타일로 virtual text 추가")
```

### 4.2 커스텀 하이라이트 그룹

```lua
-- 커스텀 하이라이트 그룹 생성
vim.api.nvim_set_hl(0, "MyVirtualText", { fg = "#ffd700", bg = "#333333", bold = true })

local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  virt_text = {{ "커스텀 스타일!", "MyVirtualText" }},
  virt_text_pos = "eol",
})

print("커스텀 하이라이트 그룹 'MyVirtualText'로 virtual text 추가")
```

### 4.3 여러 줄에 걸쳐 Virtual Text

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  virt_text = {
    { "┌─ ", "Comment" },
    { "라인 1", "String" },
    { " ─┐", "Comment" },
  },
  virt_text_pos = "eol",
})

print("여러 스타일의 virtual text 추가")
```

---

## 5.Virtual Text 관리

### 5.1 여러 Virtual Text 관리

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local start_line = cursor[1] - 1

local ids = {}
for i = 1, 5 do
  local id = vim.api.nvim_buf_set_extmark(bufnr, 0, start_line + i - 1, 0, {
    virt_text = {{ "라인 " .. i .. " 표시", "Function" }},
    virt_text_pos = "eol",
  })
  table.insert(ids, id)
end

print("5개의 virtual text 생성:")
for _, id in ipairs(ids) do
  print("  id=" .. id)
end
```

### 5.2 특정 위치의 extmark 조회

```lua
local bufnr = vim.api.nvim_get_current_buf()

local marks = vim.api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, { details = true })

print("모든 extmark 조회 (" .. #marks .. "개):")
for _, mark in ipairs(marks) do
  local id, line, col, details = mark[1], mark[2], mark[3], mark[4]
  local virt_text = details.virt_text and details.virt_text[1][1] or "N/A"
  print(string.format("  id=%d, line=%d, col=%d, text='%s'", id, line, col, virt_text))
end
```

### 5.3 모든 Virtual Text 삭제

```lua
local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_buf_clear_extmarks(bufnr, -1, 0, -1)

print("버퍼 #" .. bufnr .. "의 모든 extmarks 삭제됨")
```

---

## 6. Practical Examples

### 6.1 에러 표시기

```lua
local bufnr = vim.api.nvim_get_current_buf()

local errors = {
  { line = 0, message = "E001: 문법 오류" },
  { line = 2, message = "W001: 경고: 미사용 변수" },
}

for _, err in ipairs(errors) do
  vim.api.nvim_buf_set_extmark(bufnr, 0, err.line, 0, {
    virt_text = {{ "⛔ " .. err.message, "Error" }},
    virt_text_pos = "eol",
    hl_mode = "combine",
  })
end

print(#errors .. "개의 에러/경고 표시")
```

### 6.2TODO 마커

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  virt_text = {{ "📝 TODO: 구현 필요", "WarningMsg" }},
  virt_text_pos = "eol",
})

print("TODO 마커 추가")
```

### 6.3 커스텀 데코레이션

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  virt_text = {{ "━━━━━━━━━━━━━━━━", "Comment" }},
  virt_text_pos = "eol",
})

print("구분선 데코레이션 추가")
```

### 6.4 라인 번호 옆의 정보

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  sign_text = "●",
  virt_text = {{ "변경됨", "WarningMsg" }},
  virt_text_win_col = 80,
})

print("sign과 virtual text 함께 사용")
```

---

## 7. Event Handling

### 7.1 버퍼 변경 시 Virtual Text 업데이트

```lua
-- VirtuaL Text를 업데이트하는 함수
local function update_virtual_text(bufnr)
  vim.api.nvim_buf_clear_extmarks(bufnr, -1, 0, -1)
  
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    if line:match("TODO") then
vim.api.nvim_buf_set_extmark(bufnr, 0, i - 1, 0, {
        virt_text = {{ "☰ TODO", "WarningMsg" }},
        virt_text_pos = "eol",
      })
    end
  end
end

local bufnr = vim.api.nvim_get_current_buf()
update_virtual_text(bufnr)

print("버퍼에서 'TODO' 패턴 검색 후 virtual text 표시")
```

### 7.2 커서 위치 기반 Virtual Text

```lua
local bufnr = vim.api.nvim_get_current_buf()

local function show_cursor_info()
  vim.api.nvim_buf_clear_extmarks(bufnr, -1, 0, -1)
  
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1] - 1
  local col = cursor[2]
  
vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
    virt_text = {{ string.format("Ln %d, Col %d", cursor[1], col + 1), "Comment" }},
    virt_text_pos = "eol",
  })
end

show_cursor_info()

print("커서 위치 정보 표시")
```

---

## 8. Advanced Features

### 8.1 Virtual Text with Scrolling

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  virt_text = {{ "스크롤 시 표시 유지", "Function" }},
  virt_text_pos = "eol",
  virt_text_win_col = 60,
  ephemeral = false,
})

print("고정 위치 virtual text (스크롤 영향 없음)")
```

### 8.2 NS( Namespace) 사용

```lua
local bufnr = vim.api.nvim_get_current_buf()

-- 새 namespace 생성
local ns_id = vim.api.nvim_create_namespace("my_virtual_text")

-- namespace에 virtual text 추가
vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
  virt_text = {{ "Namespace 테스트", "Keyword" }},
  virt_text_pos = "eol",
})

print("Namespace '" .. ns_id .. "'에 virtual text 추가")
```

### 8.3 Hover Virtual Text

```lua
local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local line = cursor[1] - 1
local col = cursor[2]

vim.api.nvim_buf_set_extmark(bufnr, 0, line, col, {
  virt_text = {{ "Hover 테스트", "String" }},
  virt_text_pos = "eol",
  hover = {
    enabled = true,
    delay = 200,
    hide_on_insert = true,
  },
})

print("Hover 가능한 virtual text 추가")
```

---

## 요약

배운 내용:

1. **extmarks 기초** - 생성, 조회, 삭제
2. **Virtual Text 위치** - eol, right_align, inline
3. **스타일링** - 기본/커스텀 하이라이트 그룹
4. **관리** - 여러 virtuaL Text 동시 관리
5. **실전 예제** - 에러 표시, TODO 마커, 데코레이션
6. **이벤트 처리** - 버퍼/커서 변경 시 업데이트
7. **고급 기능** - Namespace, Hover 등

---

## 9. lazydev로 타입 확인

lazydev는 Neovim Lua API의 타입 체킹을 제공하는 LSP 클라이언트입니다.

### 9.1 lazydev 설치

```lua
-- lazydev 설정 예시
require("lazy").setup({
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "vim",
        "nvim-lua/plenary.nvim",
      },
    },
  },
})

print("lazydev가 설치되면 vim 라이브러리에 대한 LSP 지원이 활성화됩니다")
```

### 9.2 vim 라이브러리 타입 확인

lazydev가 활성화되면 Neovim API 함수에 마우스를 올리거나 Hover하면 타입 정보를 확인할 수 있습니다.

```lua
-- hover로 타입 확인 가능:
-- vim.api.nvim_buf_set_extmark() - 함수 위에 마우스를 올려서 시그니처 확인
-- vim.api.nvim_get_current_buf() - 반환 타입 확인

local bufnr = vim.api.nvim_get_current_buf()
-- bufnr: number 타입 반환

local marks = vim.api.nvim_buf_get_extmarks(bufnr, 0, -1, {})
-- marks: table 타입 반환

print("lazydev가 설치되어 있으면 위 함수들의 반환 타입을 hover로 확인할 수 있습니다")
```

### 9.3 타입 정의 파일 위치

```lua
-- lazydev가 사용하는 타입 정의 파일 경로 확인
local lazydev_lib = vim.fn.stdpath("data") .. "/lazy/lazydev.nvim/lua"
print("lazydev 타입 정의: " .. lazydev_lib)

-- vim 라이브러리의 타입 정의는 lazydev가 자동으로 로드
print("vim API 타입은 자동 완료 및 hover 지원")
```

---

## 다음 단계

더 배울 수 있는 주제들:

- **nvim-semantic-tokens** - 세맨틱 하이라이팅
- **LSP virtual text** - LSP diagnostics 연동
- **Treesitter virtual text** - AST 기반 분석
- **Custom LSP client** - 자체 LSP 클라이언트 구현
