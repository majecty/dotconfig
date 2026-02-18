return {
  {
    dir = '~/jhconfig/nvim/lua/packages/lua-executor',
    name = 'lua-executor',
    event = 'VeryLazy',
    config = function()
      -- 간단한 안내 메시지: 로컬 패키지를 VeryLazy로 로드하는 방법을 학습한 내용
      vim.notify('로컬 VeryLazy 플러그인 설정: `dir`에 로컬 패키지 경로, `name`으로 식별, `event = "VeryLazy"`로 지연로드합니다', vim.log.levels.INFO)

      local executor = require('packages.lua-executor')
      executor.setup()
    end,
  },
}
