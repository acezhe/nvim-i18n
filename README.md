**English** | [简体中文](README.zh-CN.md)

# nvim-i18n

Neovim UI internationalization framework — providing multi-language support for Neovim plugins.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "acezhe/nvim-i18n",
  lazy = false, -- Load eagerly so other plugins can require it
  config = function()
    require("nvim-i18n").setup({
      default_locale = "en", -- Default language
    })
  end,
}
```

## Quick Start

```lua
local i18n = require("nvim-i18n")

-- Register translation tables
i18n.register("my-plugin", {
  en = { greeting = "Hello" },
  zh = { greeting = "你好" },
})

-- Get translations
print(i18n.t("my-plugin.greeting"))  -- → "Hello"

-- Switch locale
i18n.set_locale("zh")
print(i18n.t("my-plugin.greeting"))  -- → "你好"
```

Or use commands `:I18nLocale zh` / `:I18nLocale en`.

## API

| Function | Description |
|----------|-------------|
| `i18n.setup(opts)` | Initialize the framework and create the `:I18nLocale` command |
| `i18n.register(ns, translations)` | Register translation tables. `ns` is the namespace, `translations` is in `{ locale = { key = "value" } }` format |
| `i18n.t(key, locale?)` | Get a translation. `key` format is `"namespace.key"`, returns the key itself when not found |
| `i18n.set_locale(locale)` | Switch language, triggers the `User I18nLocaleChanged` event |
| `i18n.locale()` | Return the current locale |

## Events

The framework notifies consumers via Neovim autocommand events:

- **`User I18nLocaleChanged`** — triggered when the locale changes. Plugins that need to dynamically refresh UI should listen for this event.

## License

MIT
