-- nvim-i18n ─ Neovim UI 国际化框架
-- 提供翻译表注册、查询、locale 切换与事件通知

local M = {}

-- ── 内部状态 ──────────────────────────────────────────────
---@type table<string, table<string, table<string, string>>>
M._translations = {} -- { namespace = { en = {...}, zh = {...} } }
M._locale = nil
M._config = nil

-- ── 公开 API ──────────────────────────────────────────────

---初始化框架
---必须在其他调用之前执行（也可省略，使用默认配置）
---@param opts? table { default_locale?: string, auto_detect?: boolean }
function M.setup(opts)
  local config = require("nvim-i18n.config")
  M._config = vim.tbl_deep_extend("force", config.defaults, opts or {})
  M._locale = M._config.default_locale

  -- 暴露当前 locale 为全局变量，方便 which-key function-valued group 等场景使用
  vim.g.i18n_locale = M._locale

  -- 创建 :I18nLocale 用户命令（先删除已有命令，避免重复 setup 时报错）
  pcall(vim.api.nvim_del_user_command, "I18nLocale")
  vim.api.nvim_create_user_command("I18nLocale", function(cmd)
    M.set_locale(cmd.args)
  end, {
    nargs = 1,
    complete = function()
      -- 从已注册的翻译表中收集所有 locale
      local locales = {}
      for _, ns in pairs(M._translations) do
        for loc, _ in pairs(ns) do
          locales[loc] = true
        end
      end
      return vim.tbl_keys(locales)
    end,
    desc = "Switch UI locale (e.g. :I18nLocale zh)",
  })
end

---注册翻译表
---@param namespace string 命名空间（如 "java"、"lazyvim"）
---@param translations table<string, table<string, string>> 翻译表 { en = { key = "value" }, zh = { key = "值" } }
function M.register(namespace, translations)
  assert(type(namespace) == "string" and #namespace > 0, "namespace must be a non-empty string")
  assert(type(translations) == "table", "translations must be a table")
  M._translations[namespace] = translations
end

---获取翻译
---key 不存在时返回 key 本身（降级行为）
---@param key string "{namespace}.{key}" 格式，如 "java.compile_all"
---@param locale? string 指定语言环境，不传则使用当前 locale
---@return string
function M.t(key, locale)
  locale = locale or M._locale or (require("nvim-i18n.config").defaults.default_locale)

  -- 解析 "namespace.key" 格式
  local dot_idx = key:find("%.")
  if not dot_idx then
    return key
  end
  local ns = key:sub(1, dot_idx - 1)
  local k = key:sub(dot_idx + 1)

  -- 查找命名空间
  local ns_translations = M._translations[ns]
  if not ns_translations then
    return key
  end

  -- 查找 locale → key
  local locale_table = ns_translations[locale]
  if not locale_table then
    return key
  end

  return locale_table[k] or key
end

---切换语言环境（触发 User I18nLocaleChanged 事件）
---@param locale string 目标 locale，如 "en" | "zh"
function M.set_locale(locale)
  M._locale = locale
  vim.g.i18n_locale = locale

  vim.notify("I18n locale: " .. locale, vim.log.levels.INFO)

  -- 通知所有消费者刷新 UI
  vim.api.nvim_exec_autocmds("User", { pattern = "I18nLocaleChanged", modeline = false })
end

---获取当前语言环境
---@return string
function M.locale()
  if M._locale then
    return M._locale
  end
  -- setup() 未调用时使用默认值
  return require("nvim-i18n.config").defaults.default_locale
end

return M
