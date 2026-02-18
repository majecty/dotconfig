# ToggleTerm 버퍼 및 윈도우 관리 상세 분석

## 목차
1. [개요](#개요)
2. [아키텍처](#아키텍처)
3. [버퍼 관리](#버퍼-관리)
4. [윈도우 관리](#윈도우-관리)
5. [터미널 레지스트리](#터미널-레지스트리)
6. [상태 흐름](#상태-흐름)
7. [설계 패턴](#설계-패턴)

---

## 개요

**ToggleTerm**은 Neovim의 터미널 관리 플러그인으로, 버퍼와 윈도우를 명확히 분리하여 관리합니다.

### 핵심 개념

- **버퍼(Buffer)**: 한 번 생성되면 영구적으로 존재하며, 터미널의 실제 데이터 저장소
- **윈도우(Window)**: 필요에 따라 생성/삭제되는 버퍼의 뷰 (버퍼 삭제 없음)
- **터미널 레지스트리**: 모든 터미널 인스턴스를 ID로 추적하는 전역 테이블

**이 설계로 "토글(toggle)" 기능이 가능**: 윈도우를 닫아도 버퍼는 살아있어서 나중에 다시 열 수 있음

---

## 아키텍처

### 핵심 모듈 구조

```
toggleterm.lua (메인 진입점)
├── terminal.lua (터미널 객체 및 생명주기)
├── ui.lua (윈도우/버퍼 작업)
├── config.lua (설정 관리)
└── utils.lua (헬퍼 함수)
```

### 파일별 책임

| 모듈 | 책임 |
|------|------|
| `terminal.lua` | 터미널 객체, 버퍼 생성, 작업 스폰, 생명주기 관리 |
| `ui.lua` | 윈도우 생성/삭제, 분할 처리, 부동 윈도우 |
| `toggleterm.lua` | 명령어, 토글 로직, 오토커맨드 |

---

## 버퍼 관리

### 1. 버퍼 생성 (`ui.lua:149-160`)

#### 코드
```lua
local function create_term_buf_if_needed(term)
  local valid_win = term.window and api.nvim_win_is_valid(term.window)
  local window = valid_win and term.window or api.nvim_get_current_win()
  
  -- 버퍼가 이미 존재하면 재사용
  local valid_buf = term.bufnr and api.nvim_buf_is_valid(term.bufnr)
  local bufnr = valid_buf and term.bufnr or api.nvim_create_buf(false, false)
  
  -- 윈도우에 버퍼 할당
  api.nvim_win_set_buf(window, bufnr)
  term.window, term.bufnr = window, bufnr
  term:__set_options()
  api.nvim_set_current_buf(bufnr)
end
```

#### 동작 원리

1. **재사용 우선**: `term.bufnr`이 유효하면 기존 버퍼 사용
2. **필요시 생성**: 버퍼가 없거나 유효하지 않으면 새 버퍼 생성
3. **윈도우 할당**: 버퍼를 윈도우에 연결
4. **옵션 설정**: 버퍼 옵션 적용

#### 핵심 특징

- ✅ 버퍼는 **한 번만 생성** (비용이 큼)
- ✅ 이후 계속 **재사용** (빠름)
- ✅ 버퍼 ID 저장으로 **추적 가능** (`term.bufnr`)

### 2. 버퍼 옵션 설정 (`terminal.lua:428-452`)

#### 파일타입 옵션 (`__set_ft_options`)
```lua
function Terminal:__set_ft_options()
  local buf = vim.bo[self.bufnr]
  buf.filetype = constants.FILETYPE  -- "toggleterm"
  buf.buflisted = false              -- :ls에서 보이지 않음
end
```

#### 윈도우 옵션 (`__set_win_options`)
```lua
function Terminal:__set_win_options()
  if self:is_split() then
    local field = self.direction == "vertical" and "winfixwidth" or "winfixheight"
    utils.wo_setlocal(self.window, field, true)  -- 크기 고정
  end
  
  if config.hide_numbers then
    utils.wo_setlocal(self.window, "number", false)
    utils.wo_setlocal(self.window, "relativenumber", false)
  end
end
```

#### 통합 옵션 설정 (`__set_options`)
```lua
function Terminal:__set_options()
  self:__set_ft_options()
  self:__set_win_options()
  vim.b[self.bufnr].toggle_number = self.id  -- 버퍼에 터미널 ID 저장!
end
```

#### 설정되는 옵션들

| 옵션 | 값 | 목적 |
|------|----|----|
| `filetype` | `"toggleterm"` | 터미널 버퍼 식별 |
| `buflisted` | `false` | 버퍼 목록에서 숨김 |
| `winfixwidth/height` | `true` | 분할 윈도우 크기 고정 |
| `number, relativenumber` | `false` | 줄 번호 숨김 |
| `toggle_number` | `term.id` | 버퍼 ↔ 터미널 ID 매핑 |

### 3. 버퍼 생명주기

#### 생성 흐름 (`terminal.lua:471-482`)

```lua
function Terminal:spawn()
  -- 1단계: 버퍼 생성 또는 기존 버퍼 사용
  if not self.bufnr or not api.nvim_buf_is_valid(self.bufnr) then 
    self.bufnr = ui.create_buf() 
  end
  
  -- 2단계: 레지스트리에 추가
  self:__add()
  
  -- 3단계: 작업 스폰 (버퍼 컨텍스트에서)
  if api.nvim_get_current_buf() ~= self.bufnr then
    api.nvim_buf_call(self.bufnr, function() self:__spawn() end)
  else
    self:__spawn()
  end
  
  -- 4단계: 오토커맨드 설정
  setup_buffer_autocommands(self)
  setup_buffer_mappings(self.bufnr)
  
  if self.on_create then self:on_create() end
end
```

**순서가 중요함:**
1. 버퍼 생성
2. 레지스트리 등록
3. 터미널 작업 스폰
4. 오토커맨드 설정

#### 작업 스폰 (`terminal.lua:390-415`)

```lua
function Terminal:__spawn()
  local cmd = self.cmd or config.get("shell")
  if type(cmd) == "function" then cmd = cmd() end
  
  local command_sep = get_command_sep()
  local comment_sep = get_comment_sep()
  
  -- 터미널 버퍼 이름 생성
  cmd = table.concat({
    cmd,
    command_sep,
    comment_sep,
    constants.FILETYPE,
    comment_sep,
    self.id,  -- ← 이름에 ID 포함!
  })
  
  -- termopen 호출
  self.job_id = fn.termopen(cmd, {
    detach = 1,
    cwd = dir,
    on_exit = __handle_exit(self),
    on_stdout = self:__make_output_handler(self.on_stdout),
    on_stderr = self:__make_output_handler(self.on_stderr),
    env = self.env,
    clear_env = self.clear_env,
  })
  
  self.name = cmd
  self.dir = dir
end
```

**생성되는 버퍼 이름 예:**
```
term://~/.dotfiles//3371887:/usr/bin/zsh;#toggleterm#1
                                              ↑
                                        터미널 ID = 1
```

이름에 ID를 인코딩하면 버퍼 이름으로부터 ID 식별 가능 (`M.identify()`)

#### 오토커맨드 (`terminal.lua:161-181`)

```lua
local function setup_buffer_autocommands(term)
  -- 1. 터미널 종료 시 레지스트리에서 제거
  api.nvim_create_autocmd("TermClose", {
    buffer = term.bufnr,
    group = AUGROUP,
    callback = function() delete(term.id) end,
  })
  
  -- 2. 부동 윈도우 크기 조정
  if term:is_float() then
    api.nvim_create_autocmd("VimResized", {
      buffer = term.bufnr,
      group = AUGROUP,
      callback = function() on_vim_resized(term.id) end,
    })
  end
  
  -- 3. Insert 모드 진입
  if config.start_in_insert then
    if term.window == api.nvim_get_current_win() then 
      vim.cmd("startinsert") 
    end
  end
end
```

**핵심 이벤트:**
- `TermClose`: 터미널 작업 종료 → 레지스트리에서 제거
- `VimResized`: 화면 크기 변경 → 부동 윈도우 업데이트

### 4. 버퍼 정리 (`ui.lua:164-168`, `terminal.lua:293-297`)

#### 버퍼 삭제
```lua
function M.delete_buf(term)
  if term.bufnr and api.nvim_buf_is_valid(term.bufnr) then
    api.nvim_buf_delete(term.bufnr, { force = true })
  end
end
```

#### 완전 종료 (`shutdown`)
```lua
function Terminal:shutdown()
  if self:is_open() then self:close() end  -- 윈도우만 닫음
  ui.delete_buf(self)                      -- 버퍼 삭제
  delete(self.id)                          -- 레지스트리 제거
end
```

**중요:** `close()`는 윈도우만 닫고, 버퍼는 남음!

---

## 윈도우 관리

### 1. 윈도우 열기 (`terminal.lua:487-505`)

#### 메인 `open()` 메서드

```lua
function Terminal:open(size, direction)
  local cwd = fn.getcwd()
  self.dir = _get_dir(config.autochdir and cwd or self.dir)
  ui.set_origin_window()  -- 이전 윈도우 저장
  
  if direction then self:change_direction(direction) end
  
  -- Case 1: 버퍼가 없으면 새로 생성
  if not self.bufnr or not api.nvim_buf_is_valid(self.bufnr) then
    local ok, err = pcall(opener, size, self)
    if not ok and err then return utils.notify(err, "error") end
    self:spawn()  -- 버퍼 생성 + 작업 스폰
  else
    -- Case 2: 버퍼가 있으면 윈도우만 열기
    local ok, err = pcall(opener, size, self)
    if not ok and err then return utils.notify(err, "error") end
    ui.switch_buf(self.bufnr)  -- 기존 버퍼로 전환
    if config.autochdir and self.dir ~= cwd then 
      self:change_dir(cwd) 
    end
  end
  
  ui.hl_term(self)
  if self.on_open then self:on_open() end
end
```

**두 가지 경로:**

```
경로 1: 첫 열기 (버퍼 없음)
├─ opener() → 윈도우 생성
├─ spawn() → 버퍼 생성 + 작업 스폰
└─ on_open 콜백

경로 2: 재열기 (버퍼 있음)
├─ opener() → 윈도우 생성
├─ switch_buf() → 기존 버퍼 전환
└─ on_open 콜백
```

### 2. 윈도우 타입별 열기

#### 분할(Split) 윈도우 (`ui.lua:310-333`)

```lua
function M.open_split(size, term)
  local has_open, windows = M.find_open_windows()
  local commands = split_commands[term.direction]
  
  if has_open then
    -- 이미 열린 터미널이 있으면 거기서 분할
    local split_win = windows[#windows]
    if config.persist_size then 
      M.save_window_size(term.direction, split_win.window) 
    end
    api.nvim_set_current_win(split_win.window)
    
    local window_width = vim.o.columns
    local horizontal_breakpoint = config.responsiveness.horizontal_breakpoint
    
    if term.direction == "horizontal" and window_width < horizontal_breakpoint then
      vim.cmd(commands.existing_stacked)  -- 가로로 겹쳐서 분할
    else
      vim.cmd(commands.existing)  -- 일반 분할
    end
  else
    -- 터미널이 없으면 현재 윈도우에서 분할
    vim.cmd(commands.new)
  end
  
  M.resize_split(term, size)
  create_term_buf_if_needed(term)
end
```

**분할 명령어:**
```lua
split_commands = {
  horizontal = {
    existing = "rightbelow vsplit",      -- 오른쪽에 분할
    existing_stacked = "rightbelow split",  -- 아래에 분할
    new = "botright split",              -- 아래에 새 분할
  },
  vertical = {
    existing = "rightbelow split",       -- 아래에 분할
    new = "botright vsplit",             -- 오른쪽에 새 분할
  },
}
```

**창 크기 저장 로직:**
```lua
function M.save_window_size(direction, window)
  if direction == "horizontal" then
    persistent.horizontal = api.nvim_win_get_height(window)
  elseif direction == "vertical" then
    persistent.vertical = api.nvim_win_get_width(window)
  end
end

function M.get_size(size, direction)
  local valid_size = size ~= nil and size > 0
  if not config.persist_size then 
    return valid_size and size or config.size 
  end
  -- 우선순위: 명시적 크기 > 저장된 크기 > 기본 크기
  return valid_size and size or persistent[direction] or config.size
end
```

#### 탭(Tab) 윈도우 (`ui.lua:336-344`)

```lua
function M.open_tab(term)
  -- tabedit으로 새 탭 생성
  vim.cmd("tabedit new")
  
  -- 빈 버퍼는 터미널 버퍼로 교체될 때 자동 삭제
  vim.bo.bufhidden = "wipe"
  
  create_term_buf_if_needed(term)
end
```

#### 부동 윈도우 (Float) (`ui.lua:371-383`)

```lua
function M.open_float(term)
  local opts = term.float_opts or {}
  
  -- 기존 버퍼 재사용 또는 새 버퍼 생성
  local valid_buf = term.bufnr and api.nvim_buf_is_valid(term.bufnr)
  local buf = valid_buf and term.bufnr or api.nvim_create_buf(false, false)
  
  -- 부동 윈도우 생성
  local win = api.nvim_open_win(buf, true, M._get_float_config(term, true))
  
  term.window, term.bufnr = win, buf
  utils.wo_setlocal(win, "sidescrolloff", 0)
  
  if opts.winblend then 
    utils.wo_setlocal(win, "winblend", opts.winblend) 
  end
  
  term:__set_options()
end
```

**부동 윈도우 설정 (`_get_float_config`):**

```lua
function M._get_float_config(term, opening)
  local opts = term.float_opts or {}
  
  -- 보더 스타일
  local curved = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
  local border = opts.border == "curved" and curved or opts.border or "single"
  
  -- 기본 크기: 화면의 80~90%
  local width = math.ceil(math.min(
    vim.o.columns, 
    math.max(80, vim.o.columns - 20)
  ))
  local height = math.ceil(math.min(
    vim.o.lines, 
    math.max(20, vim.o.lines - 10)
  ))
  
  -- 사용자 설정 적용
  width = vim.F.if_nil(M._resolve_size(opts.width, term), width)
  height = vim.F.if_nil(M._resolve_size(opts.height, term), height)
  
  -- 중앙 배치
  local row = math.ceil(vim.o.lines - height) * 0.5 - 1
  local col = math.ceil(vim.o.columns - width) * 0.5 - 1
  
  row = vim.F.if_nil(M._resolve_size(opts.row, term), row)
  col = vim.F.if_nil(M._resolve_size(opts.col, term), col)
  
  local float_config = {
    row = row,
    col = col,
    relative = opts.relative or "editor",
    style = opening and "minimal" or nil,
    width = width,
    height = height,
    border = opening and border or nil,
    zindex = opts.zindex or nil,
  }
  
  -- Neovim 0.9+ 기능
  if vim.version().major > 0 or vim.version().minor >= 9 then
    float_config.title_pos = term.display_name and opts.title_pos or nil
    float_config.title = term.display_name
  end
  
  return float_config
end
```

### 3. 윈도우 닫기 (`terminal.lua:286-291`)

#### 간단한 닫기 (윈도우만)
```lua
function Terminal:close()
  if self.on_close then self:on_close() end
  ui.close(self)  -- 윈도우 닫기
  ui.stopinsert()
  ui.update_origin_window(self.window)
end
```

#### UI 레벨 닫기 (`ui.lua:394-402`)

```lua
function M.close(term)
  if term:is_split() then
    close_split(term)
  elseif term:is_tab() then
    close_tab(term)
  elseif term.window and api.nvim_win_is_valid(term.window) then
    api.nvim_win_close(term.window, true)
  end
end

local function close_split(term)
  if term.window and api.nvim_win_is_valid(term.window) then
    local persist_size = config.get("persist_size")
    if persist_size then 
      M.save_window_size(term.direction, term.window) 
    end
    api.nvim_win_close(term.window, true)  -- true = 버퍼 유지
  end
  
  -- 이전 윈도우로 복귀
  if origin_window and api.nvim_win_is_valid(origin_window) then
    api.nvim_set_current_win(origin_window)
  else
    origin_window = nil
  end
end

local function close_tab(term)
  if #vim.api.nvim_list_tabpages() == 1 then
    return utils.notify("마지막 탭은 닫을 수 없습니다!", "error")
  end
  api.nvim_win_close(term.window, true)
end
```

**중요한 점:**
- ✅ 윈도우 닫기는 버퍼를 **유지** (`api.nvim_win_close(..., true)`)
- ✅ 이전 윈도우로 **자동 복귀**
- ✅ 분할 크기는 **저장**됨

### 4. 윈도우 상태 감지 (`terminal.lua:249-255`)

```lua
function Terminal:is_open()
  if not self.window then 
    return false 
  end
  
  local win_type = fn.win_gettype(self.window)
  -- 일반 윈도우("") 또는 팝업("popup")
  local win_open = win_type == "" or win_type == "popup"
  
  -- 윈도우가 유효하고 올바른 버퍼를 포함하는가?
  return win_open and api.nvim_win_get_buf(self.window) == self.bufnr
end
```

**검사 항목:**
1. 윈도우 핸들이 존재?
2. 윈도우가 유효한가? (일반 또는 팝업)
3. 윈도우에 올바른 터미널 버퍼가 있는가?

### 5. 윈도우 토글 (`terminal.lua:510-517`)

```lua
function Terminal:toggle(size, direction)
  if self:is_open() then
    self:close()  -- 열려있으면 닫기
  else
    self:open(size, direction)  -- 닫혀있으면 열기
  end
  return self
end
```

**토글의 마법:**
- 버퍼가 존재하면 → 윈도우 재사용
- 버퍼가 없으면 → 새로 생성
- 윈도우 닫아도 버퍼는 살아있음 → 토글 가능!

### 6. 원점 윈도우 추적 (`ui.lua:170-177`)

```lua
local origin_window

function M.set_origin_window() 
  origin_window = api.nvim_get_current_win() 
end

function M.get_origin_window() 
  return origin_window 
end

function M.update_origin_window(term_window)
  local curr_win = api.nvim_get_current_win()
  if term_window ~= curr_win then 
    origin_window = curr_win 
  end
end
```

**사용 시나리오:**
1. 편집 윈도우에서 `<C-`>` → `set_origin_window()` 호출
2. 터미널 윈도우 열기
3. 터미널에서 `<C-`>` → 자동으로 편집 윈도우로 복귀

---

## 터미널 레지스트리

### 1. 글로벌 레지스트리 (`terminal.lua:54`)

```lua
---@type Terminal[]
local terminals = {}
```

**특징:**
- 모든 터미널을 ID로 추적
- O(1) 시간에 접근
- 중복 생성 방지

### 2. 터미널 생성 (`terminal.lua:198-226`)

```lua
function Terminal:new(term)
  term = term or {}
  
  -- 같은 ID면 기존 터미널 반환 (중복 생성 방지)
  local id = term.count or term.id
  if id and terminals[id] then 
    return terminals[id] 
  end
  
  local conf = config.get()
  self.__index = self
  
  -- 옵션 설정
  term.newline_chr = term.newline_chr or get_newline_chr()
  term.direction = term.direction or conf.direction
  term.id = id or next_id()
  term.display_name = term.display_name
  term.float_opts = vim.tbl_deep_extend("keep", term.float_opts or {}, conf.float_opts)
  term.clear_env = vim.F.if_nil(term.clear_env, conf.clear_env)
  term.auto_scroll = vim.F.if_nil(term.auto_scroll, conf.auto_scroll)
  term.env = vim.F.if_nil(term.env, conf.env)
  term.hidden = vim.F.if_nil(term.hidden, false)
  
  -- 콜백 설정
  term.on_create = vim.F.if_nil(term.on_create, conf.on_create)
  term.on_open = vim.F.if_nil(term.on_open, conf.on_open)
  term.on_close = vim.F.if_nil(term.on_close, conf.on_close)
  term.on_stdout = vim.F.if_nil(term.on_stdout, conf.on_stdout)
  term.on_stderr = vim.F.if_nil(term.on_stderr, conf.on_stderr)
  term.on_exit = vim.F.if_nil(term.on_exit, conf.on_exit)
  
  term.__state = { mode = "?" }
  if term.close_on_exit == nil then 
    term.close_on_exit = conf.close_on_exit 
  end
  
  return setmetatable(term, self)
end
```

**중요:** `Terminal:new()`는 객체를 생성하지만 **아직 레지스트리에 추가하지 않음**!

### 3. 레지스트리 추가 (`terminal.lua:229-234`)

```lua
function Terminal:__add()
  -- ID 충돌 시 새 ID 할당
  if terminals[self.id] and terminals[self.id] ~= self then 
    self.id = next_id() 
  end
  
  -- 레지스트리에 추가
  if not terminals[self.id] then 
    terminals[self.id] = self 
  end
  
  return self
end
```

**호출 시점:** `Terminal:spawn()` 중에

### 4. 다음 ID 계산 (`terminal.lua:109-115`)

```lua
local function next_id()
  local all = M.get_all(true)
  
  -- {1, 2, 5, 6} → 3 반환
  for index, term in pairs(all) do
    if index ~= term.id then 
      return index 
    end
  end
  
  return #all + 1
end
```

**알고리즘:**
- 정렬된 배열에서 첫 번째 빈 슬롯 찾기
- 없으면 다음 번호 반환
- 삭제된 터미널의 ID 재사용

### 5. 레지스트리 조회

#### ID로 조회 (`terminal.lua:551-554`)
```lua
function M.get(id, include_hidden)
  local term = terminals[id]
  return (term and (include_hidden == true or not term.hidden)) and term or nil
end
```

#### 모든 터미널 조회 (`terminal.lua:573-580`)
```lua
function M.get_all(include_hidden)
  local result = {}
  for _, v in pairs(terminals) do
    if include_hidden or (not include_hidden and not v.hidden) then 
      table.insert(result, v) 
    end
  end
  
  table.sort(result, function(a, b) return a.id < b.id end)
  return result
end
```

#### 조건으로 조회 (`terminal.lua:559-568`)
```lua
function M.find(predicate)
  if type(predicate) ~= "function" then
    utils.notify("terminal.find expects a function, got " .. type(predicate), "error")
    return
  end
  
  for _, term in pairs(terminals) do
    if predicate(term) then 
      return term 
    end
  end
  
  return nil
end
```

### 6. 터미널 식별

#### 버퍼 이름으로 식별 (`terminal.lua:525-531`)

```lua
function M.identify(name)
  name = name or api.nvim_buf_get_name(api.nvim_get_current_buf())
  
  -- 버퍼 이름: term://path;#toggleterm#1
  --                          ↑
  --                     ID 위치
  local comment_sep = get_comment_sep()
  local parts = vim.split(name, comment_sep)
  local id = tonumber(parts[#parts])
  
  return id, terminals[id]
end
```

**예시:**
```
term://~/.dotfiles//3371887:/usr/bin/zsh;#toggleterm#1
                                             ↑
                                        ID = 1 추출
```

#### 열린 윈도우로 식별 (`ui.lua:201-214`)

```lua
function M.find_open_windows(comparator)
  comparator = comparator or default_compare
  local term_wins = {}
  
  for _, tab in ipairs(api.nvim_list_tabpages()) do
    for _, win in pairs(api.nvim_tabpage_list_wins(tab)) do
      local buf = api.nvim_win_get_buf(win)
      if comparator(buf) then
        is_open = true
        table.insert(term_wins, {
          window = win,
          term_id = vim.b[buf].toggle_number  -- 버퍼 변수에서 ID 추출
        })
      end
    end
  end
  
  return is_open, term_wins
end

local function default_compare(buf)
  return vim.bo[buf].filetype == constants.FILETYPE or 
         vim.b[buf].toggle_number ~= nil
end
```

**두 가지 식별 방법:**
1. **ID 저장**: `vim.b[bufnr].toggle_number = term.id`
2. **파일타입 확인**: `filetype == "toggleterm"`

### 7. 레지스트리 정리 (`terminal.lua:157-159`)

```lua
local function delete(num)
  if terminals[num] then 
    terminals[num] = nil 
  end
end
```

**호출 시점:**
- `TermClose` 오토커맨드 (작업 종료)
- `Terminal:shutdown()` (강제 종료)

---

## 상태 흐름

### 전체 생명주기 다이어그램

```
┌─────────────────────────────────────────────────────────────┐
│                    생성 흐름                                 │
└─────────────────────────────────────────────────────────────┘

1. Terminal:new()
   ├─ 객체 생성
   ├─ 설정 로드
   └─ 메타테이블 설정
   
2. Terminal:open()
   ├─ 원점 윈도우 저장
   ├─ opener() 호출
   │  ├─ M.open_split()  또는
   │  ├─ M.open_tab()    또는
   │  └─ M.open_float()
   ├─ create_term_buf_if_needed()
   ├─ Terminal:spawn()
   │  ├─ 버퍼 생성/재사용
   │  ├─ Terminal:__add() → 레지스트리 등록
   │  ├─ Terminal:__spawn() → termopen() 호출
   │  ├─ setup_buffer_autocommands()
   │  └─ setup_buffer_mappings()
   └─ on_open 콜백

3. Terminal:toggle()
   ├─ 열려있으면 → Terminal:close()
   └─ 닫혀있으면 → Terminal:open()

┌─────────────────────────────────────────────────────────────┐
│                    닫기 흐름                                 │
└─────────────────────────────────────────────────────────────┘

4. Terminal:close()
   ├─ on_close 콜백
   ├─ M.close()
   │  └─ close_split() / close_tab() / 윈도우 닫기
   ├─ stopinsert 명령
   └─ 원점 윈도우 복귀

버퍼는 **유지됨** → 다시 toggle하면 재사용!

5. Terminal:shutdown()
   ├─ Terminal:close()  (윈도우 닫기)
   ├─ M.delete_buf()    (버퍼 삭제)
   └─ delete(term.id)   (레지스트리 제거)

완전 삭제!

┌─────────────────────────────────────────────────────────────┐
│                 자동 정리 이벤트                             │
└─────────────────────────────────────────────────────────────┘

6. TermClose 오토커맨드 (작업 종료)
   └─ delete(term.id)
   
7. on_exit 콜백
   ├─ 사용자 콜백 실행
   └─ close_on_exit이면 윈도우 닫기 + 버퍼 삭제
```

### 상태 전이 다이어그램

```
┌─────────────┐
│   생성됨     │ Terminal:new()
└──────┬──────┘
       │
       │ Terminal:spawn()
       ▼
┌─────────────────────────────────┐
│  백그라운드 작동 (윈도우 없음)    │
│  - 버퍼 존재                     │
│  - 작업 실행 중                  │
│  - 레지스트리 등록               │
└──────┬──────────────────────────┘
       │
       │ Terminal:open()
       ▼
┌─────────────────────────────────┐
│  열림 (윈도우 보임)               │
│  - 버퍼 + 윈도우                 │
│  - 사용자 상호작용 가능           │
└──────┬──────────────────────────┘
       │
       │ Terminal:close()
       ▼
┌─────────────────────────────────┐
│  닫힘 (윈도우 숨김)               │
│  - 버퍼만 존재                   │
│  - 작업은 계속 실행              │
└──────┬──────────────────────────┘
       │
       │ Terminal:open() 또는 toggle()
       │ (버퍼 재사용)
       │
       └──────→ 열림 (윈도우 보임) 상태로 복귀
       
       │
       │ Terminal:shutdown()
       ▼
┌─────────────┐
│   삭제됨     │
└─────────────┘
```

### 모드 추적 (`terminal.lua:272-281`)

```lua
function Terminal:persist_mode()
  local raw_mode = api.nvim_get_mode().mode
  local m = "?"
  
  if raw_mode:match("nt") then  -- "nt" = 터미널 normal 모드
    m = mode.NORMAL
  elseif raw_mode:match("t") then  -- "t" = insert 모드 (터미널)
    m = mode.INSERT
  end
  
  self.__state.mode = m
end

function Terminal:__restore_mode() 
  self:set_mode(self.__state.mode) 
end

function Terminal:set_mode(m)
  if m == mode.INSERT then
    vim.schedule(function() vim.cmd("startinsert") end)
  elseif m == mode.NORMAL then
    vim.schedule(function() vim.cmd("stopinsert") end)
  elseif m == mode.UNSUPPORTED and config.get("start_in_insert") then
    vim.schedule(function() vim.cmd("startinsert") end)
  end
end
```

**설정: `persist_mode = true`**
- 터미널을 닫을 때 모드 저장
- 다시 열 때 같은 모드로 복구

---

## 설계 패턴

### 1. 재사용 패턴 (Reuse Pattern)

#### 버퍼 재사용
```lua
-- 첫 번째 열기
Terminal:open()
├─ 버퍼 생성
└─ 윈도우 생성

-- 닫기
Terminal:close()
└─ 윈도우만 닫기 (버퍼 유지)

-- 다시 열기
Terminal:open()
├─ 버퍼 재사용 ✓
└─ 윈도우 재생성
```

**이점:**
- 터미널 히스토리 보존
- 작업 상태 유지
- 성능 최적화

### 2. 지연 초기화 (Lazy Initialization)

```lua
-- UI 모듈도 lazy.require() 사용
local ui = lazy.require("toggleterm.ui")
local config = lazy.require("toggleterm.config")
```

첫 사용 시에만 모듈 로드 → 시작 속도 향상

### 3. 콜백 패턴 (Callback Pattern)

```lua
term = Terminal:new({
  on_create = function(term) ... end,   -- 생성 후
  on_open = function(term) ... end,     -- 열림 후
  on_close = function(term) ... end,    -- 닫힘 후
  on_exit = function(term, job, code) ... end,  -- 작업 종료
})
```

확장성 있는 설계

### 4. 레지스트리 패턴 (Registry Pattern)

```
하나의 전역 테이블에서 모든 터미널 추적
↓
- 중복 생성 방지
- O(1) 접근 시간
- 전체 터미널 관리 용이
```

### 5. 원점 추적 (Origin Tracking)

```lua
-- 터미널 열기 전
origin_window = 현재 윈도우

-- 터미널 닫기 후
goto origin_window
```

자동으로 이전 위치 복귀

### 6. 크기 저장 (Size Persistence)

```lua
persistent = {
  horizontal = 20,  -- 마지막 높이
  vertical = 50,    -- 마지막 너비
}

-- 다시 열 때
size = persistent[direction] or config.size
```

사용자 선호도 기억

### 7. 식별자 인코딩 (Identifier Encoding)

**방법 1: 버퍼 이름 인코딩**
```
term://path;#toggleterm#ID
                        ↑
                    ID 저장
```

**방법 2: 버퍼 변수 저장**
```lua
vim.b[bufnr].toggle_number = term.id
```

**방법 3: 파일타입 체크**
```lua
vim.bo[bufnr].filetype == "toggleterm"
```

세 가지 방법으로 중복 확인 가능

### 8. 오토커맨드 정리 (Autocommand Cleanup)

```lua
-- TermClose 이벤트
api.nvim_create_autocmd("TermClose", {
  buffer = term.bufnr,
  callback = function() delete(term.id) end,
})
```

자동으로 정리 → 메모리 누수 방지

---

## 핵심 정리

### 버퍼 관리의 5가지 원칙

| 원칙 | 설명 |
|------|------|
| **1. 한 번만 생성** | 버퍼는 처음 한 번만 생성, 이후 재사용 |
| **2. 닫아도 유지** | close()는 윈도우만 닫고 버퍼 유지 |
| **3. ID로 추적** | `toggle_number` 변수로 버퍼↔터미널 매핑 |
| **4. 파일타입 식별** | `filetype = "toggleterm"`으로 모든 터미널 버퍼 찾기 |
| **5. 자동 정리** | TermClose 이벤트로 자동 정리 |

### 윈도우 관리의 5가지 원칙

| 원칙 | 설명 |
|------|------|
| **1. 필요시 생성** | 버퍼와 달리 윈도우는 필요시에만 생성 |
| **2. 타입별 처리** | split/tab/float 세 가지 타입 지원 |
| **3. 원점 기억** | 이전 윈도우 자동 복귀 |
| **4. 크기 저장** | split 크기 자동 저장/복원 |
| **5. 토글 지원** | 같은 버퍼를 여러 윈도우에서 열 수 있음 |

### 설계의 우아함

```
버퍼와 윈도우의 명확한 분리
    ↓
토글 가능 (윈도우만 닫음)
    ↓
상태 보존 (버퍼 유지)
    ↓
메모리 효율 (재사용)
```

---

## 참고 자료

- **라이브러리**: https://github.com/akinsho/toggleterm.nvim
- **주요 파일**:
  - `lua/toggleterm.lua` - 메인 API
  - `lua/toggleterm/terminal.lua` - 터미널 객체
  - `lua/toggleterm/ui.lua` - 윈도우/버퍼 관리

