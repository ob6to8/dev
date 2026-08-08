---
id: em:20ae75
type: snippet
title: Showing the full filename under the cursor in nvim-tree
description: Two ways to read a truncated nvim-tree entry without widening the sidebar — the built-in full_name floating popup, and a global statusline that reports the node under the cursor.
provenance: "Claude Opus 5"
attribution:
  when: 2026-08-08
  channel: agent-authored
  agent: "Claude Code agent, operator request in session"
  why: "operator asked whether the filename under the cursor can be shown in the status bar instead of widening nvim-tree"
tags: [vim, neovim, nvim-tree, plugins, statusline, configuration, file-explorer]
timestamp: 2026-08-08
---

# Showing the full filename under the cursor in nvim-tree

Widening the sidebar spends editor columns on every row to make *one* row
readable. Both recipes below keep the tree narrow and surface only the focused
entry.

## Built-in: the `full_name` popup

nvim-tree ships this. It costs one line of config:

```lua
require("nvim-tree").setup({
  renderer = { full_name = true },
})
```

Any node whose name is wider than the tree window is redrawn, in full, in a
floating window aligned over its row. The popup is driven by `CursorMoved`
inside the tree buffer, so it follows `j`/`k` and closes when the cursor moves
off or the buffer is left. It only appears when the name is *actually*
truncated — a name that already fits produces nothing.

## The status bar

There is no built-in "node under cursor" statusline component; it is three
lines built on `api.tree.get_node_under_cursor()`.

**`laststatus = 3` is load-bearing.** Under the default `laststatus = 2` every
window draws its own statusline, so the tree's statusline is exactly as wide as
the tree — it truncates the path for the same reason the tree row did. The
global statusline spans the full editor width:

```lua
vim.opt.laststatus = 3

function _G.nvim_tree_statusline()
  local buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
  if vim.bo[buf].filetype == "NvimTree" then
    local node = require("nvim-tree.api").tree.get_node_under_cursor()
    if node then
      return vim.fn.fnamemodify(node.absolute_path, ":~:.")
    end
  end
  return "%f %m %=%l:%c"  -- ordinary statusline everywhere else
end

vim.o.statusline = "%!v:lua.nvim_tree_statusline()"
```

`%!` re-evaluates the expression on every redraw, so no `CursorMoved` autocmd
is needed — the statusline asks for the node rather than being pushed it.
`:~:.` renders the path relative to the cwd, falling back to `~`-relative.

With **lualine**, the same call becomes a component instead of replacing
`statusline` wholesale:

```lua
require("lualine").setup({
  options = { globalstatus = true },
  sections = {
    lualine_c = {
      function()
        local node = require("nvim-tree.api").tree.get_node_under_cursor()
        return node and vim.fn.fnamemodify(node.absolute_path, ":~:.") or ""
      end,
    },
  },
})
```

`globalstatus = true` is lualine's `laststatus = 3`, and carries the same
requirement for the same reason.

## Choosing

`full_name` is the smaller change and needs no statusline surgery, but it only
ever shows the *name*. The statusline recipe shows the full **path**, which is
what matters when `update_focused_file.update_root` moves the root around and
the visible name loses its context.

The complementary approach — spending the columns rather than avoiding them —
is in
[widening the nvim-tree window](/knowledge/SWE/editors/vim/nvim-tree-window-width.md).

# Citations

- `:help nvim_tree.config.renderer` (`full_name`) and
  `:help nvim_tree.api.tree.get_node_under_cursor` — nvim-tree bundled
  documentation, `doc/nvim-tree-lua.txt`, at commit `b3772ad` (2026-03-14).
- `:help 'laststatus'`, `:help 'statusline'` — Neovim documentation.
