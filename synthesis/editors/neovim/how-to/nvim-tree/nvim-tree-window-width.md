---
id: em:6d6180
type: snippet
title: Widening the nvim-tree window
description: Configure nvim-tree's sidebar width — fixed columns, a percentage, or a dynamic width that grows to fit the longest filename — and resize it at runtime.
provenance: "Claude Opus 5"
attribution:
  when: 2026-08-08
  channel: agent-authored
  agent: "Claude Code agent, operator request in session"
  why: "operator asked how to widen nvim-tree so more of a filename is visible"
tags: [vim, neovim, nvim-tree, plugins, configuration, file-explorer]
timestamp: 2026-08-08
---

# Widening the nvim-tree window

The sidebar is 30 columns by default, which truncates most real filenames. One
option controls it — `view.width` — and it accepts either a *static spec* or a
*dynamic table* that sizes the window to its own content.

## Static width

A `width.spec` is one of three things:

```lua
require("nvim-tree").setup({
  view = { width = 50 },      -- columns
})
require("nvim-tree").setup({
  view = { width = "30%" },   -- percentage of the editor
})
require("nvim-tree").setup({
  view = { width = function() return math.floor(vim.o.columns * 0.3) end },
})
```

## Dynamic width — grow to the longest name

Passing a table instead switches nvim-tree to measuring the rendered tree and
sizing the window to its longest line:

```lua
require("nvim-tree").setup({
  view = {
    width = {
      min = 30,     -- floor (a width.spec)
      max = 60,     -- ceiling; -1 for unbounded
      padding = 2,  -- extra columns to the right
      -- lines_excluded = { "root" },  -- default
    },
  },
})
```

`max = -1` is the fully adaptive setting: the window is always exactly as wide
as it needs to be. That is the setting to reach for when the goal is *never
truncate*, but a deep tree of long paths will then claim most of the editor —
`max = 60` keeps the adaptive behaviour bounded.

`lines_excluded` defaults to `{ "root" }` so the root header (an absolute path,
usually the longest line in the buffer) is not what the window sizes itself to.
Dropping `"root"` from that list is almost always wrong.

## Resize at runtime

Width changes persist for the session:

```vim
:NvimTreeResize +10    " relative
:NvimTreeResize 60     " absolute
```

```lua
require("nvim-tree.api").tree.resize({ relative = 10 })
require("nvim-tree.api").tree.resize({ absolute = 60 })
```

## Toggling adaptive width from a key

The upstream recipe drives `max` through a function, so a keymap can flip
between a fixed and an unbounded width without re-running `setup`:

```lua
local VIEW_WIDTH_FIXED = 30
local view_width_max = VIEW_WIDTH_FIXED

local function toggle_width_adaptive()
  view_width_max = view_width_max == -1 and VIEW_WIDTH_FIXED or -1
  require("nvim-tree.api").tree.reload()
end

require("nvim-tree").setup({
  view = { width = { min = 30, max = function() return view_width_max end } },
})

vim.keymap.set("n", "<leader>A", toggle_width_adaptive, { desc = "nvim-tree: toggle adaptive width" })
```

## The other half of the problem

Widening trades editor columns for filename columns. When the tree should stay
narrow and only the *focused* name needs to be legible, see
[showing the full filename under the cursor in nvim-tree](/knowledge/SWE/editors/vim/nvim-tree-filename-under-cursor.md)
— a floating popup or the statusline shows the whole name at 30 columns.

# Citations

- `:help nvim_tree.config.view.width` — nvim-tree bundled documentation,
  `doc/nvim-tree-lua.txt`, at commit `b3772ad` (2026-03-14).
- [nvim-tree Recipes wiki — adaptive width toggle](https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes)
