-- nvim-i18n 默认配置
local M = {}

M.defaults = {
  ---默认语言
  default_locale = "en",
  ---是否根据 $LANG 环境变量自动检测（暂不实现，保留配置项）
  auto_detect = false,
}

return M
