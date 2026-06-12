# nvim-i18n

Neovim UI 国际化框架 ─ 为 Neovim 插件提供多语言支持。

## 安装

使用 [lazy.nvim](https://github.com/folke/lazy.nvim)：

```lua
{
  "acezhe/nvim-i18n",
  lazy = false, -- 不延迟加载，确保其他插件 require 时可用
  config = function()
    require("nvim-i18n").setup({
      default_locale = "en", -- 默认语言
    })
  end,
}
```

## 快速开始

```lua
local i18n = require("nvim-i18n")

-- 注册翻译表
i18n.register("my-plugin", {
  en = { greeting = "Hello" },
  zh = { greeting = "你好" },
})

-- 获取翻译
print(i18n.t("my-plugin.greeting"))  -- → "Hello"

-- 切换语言
i18n.set_locale("zh")
print(i18n.t("my-plugin.greeting"))  -- → "你好"
```

或用命令 `:I18nLocale zh` / `:I18nLocale en`。

## API

| 函数 | 说明 |
|------|------|
| `i18n.setup(opts)` | 初始化框架，创建 `:I18nLocale` 命令 |
| `i18n.register(ns, translations)` | 注册翻译表。`ns` 为命名空间，`translations` 为 `{ locale = { key = "value" } }` 格式 |
| `i18n.t(key, locale?)` | 获取翻译。`key` 格式为 `"namespace.key"`，key 不存在时返回 key 本身 |
| `i18n.set_locale(locale)` | 切换语言，触发 `User I18nLocaleChanged` 事件 |
| `i18n.locale()` | 返回当前 locale |

## 事件

框架通过 Neovim 自动命令事件通知消费者：

- **`User I18nLocaleChanged`** — locale 切换时触发。需要动态刷新 UI 的插件应监听此事件。

## 许可

MIT
