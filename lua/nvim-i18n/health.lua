-- nvim-i18n :checkhealth 支持

local M = {}

function M.check()
  vim.health.start("nvim-i18n")

  -- 检查模块是否正确加载
  local ok, i18n = pcall(require, "nvim-i18n")
  if not ok then
    vim.health.error("nvim-i18n 加载失败: " .. tostring(i18n))
    return
  end

  vim.health.ok("nvim-i18n 已加载")

  -- 显示当前 locale
  local current = i18n.locale()
  vim.health.info("当前 locale: " .. current)

  -- 统计已注册的命名空间
  local ns_count = 0
  local ns_list = {}
  for ns, _ in pairs(i18n._translations) do
    ns_count = ns_count + 1
    table.insert(ns_list, ns)
  end

  if ns_count > 0 then
    vim.health.ok("已注册 " .. ns_count .. " 个命名空间: " .. table.concat(ns_list, ", "))
  else
    vim.health.info("暂无注册的命名空间")
  end
end

return M
