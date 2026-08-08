---
id: em:93816f
type: snippet
title: Vim Agent Tut
description: A working reference of vim's modes, motions, operators, text objects, and the composition grammar that generates the rest.
provenance: "Claude Opus 5"
attribution:
  when: 2026-08-05
  channel: agent-authored
  agent: "Claude Code agent, operator request in session"
  why: "operator asked for a vim cheatsheet as the first document in the new editors/vim directory"
tags: [vim, editors, modal-editing, keybindings, cheatsheet]
timestamp: 2026-08-05
---

# Vim cheatsheet

Vim is not a list of shortcuts to memorize — it is a small grammar whose terms
compose. Learn the grammar and the table below becomes derivable rather than
recallable.

## The grammar

Most editing commands are one of two shapes:

```
<operator><count><motion>          d2w    — delete two words
<operator><count><text-object>     ci"    — change inside quotes
```

An **operator** says what to do, a **motion** or **text object** says where.
Any operator combines with any motion; that product — not the individual
bindings — is what makes vim compact. Doubling an operator (`dd`, `yy`, `>>`)
applies it to the whole line.

## Modes

| Key | Enters | Purpose |
|---|---|---|
| `Esc` / `Ctrl-[` | Normal | Command mode; where you spend most time |
| `i` `a` | Insert | Before / after the cursor |
| `I` `A` | Insert | Start / end of line |
| `o` `O` | Insert | Open a line below / above |
| `v` `V` `Ctrl-v` | Visual | Character / line / block selection |
| `:` | Command-line | Ex commands (`:w`, `:s`, `:g`) |
| `R` | Replace | Overwrite as you type |

## Motions

| Key | Moves to |
|---|---|
| `h` `j` `k` `l` | Left, down, up, right |
| `w` `W` | Next word / WORD (WORD = whitespace-delimited) |
| `b` `B` | Previous word / WORD |
| `e` `ge` | End of next / previous word |
| `0` `^` `$` | Column zero, first non-blank, end of line |
| `f{c}` `t{c}` | Onto / just before the next `{c}` in the line |
| `F{c}` `T{c}` | Same, backwards |
| `;` `,` | Repeat / reverse the last `f` `t` `F` `T` |
| `{` `}` | Previous / next blank-line paragraph |
| `%` | Matching bracket |
| `gg` `G` | First / last line |
| `{n}G` `:{n}` | Line `{n}` |
| `Ctrl-d` `Ctrl-u` | Half page down / up |
| `Ctrl-o` `Ctrl-i` | Back / forward in the jump list |
| `H` `M` `L` | Top / middle / bottom of the screen |

## Operators

| Key | Does |
|---|---|
| `d` | Delete (into a register) |
| `c` | Change — delete then enter insert |
| `y` | Yank (copy) |
| `p` `P` | Put after / before the cursor |
| `>` `<` | Indent / dedent |
| `=` | Auto-indent |
| `gu` `gU` `g~` | Lowercase / uppercase / toggle case |
| `!` | Filter through an external command |

## Text objects

Used after an operator: `i` = *inner* (contents only), `a` = *around*
(contents plus delimiters or trailing whitespace).

| Object | Selects |
|---|---|
| `iw` `aw` | Word |
| `is` `as` | Sentence |
| `ip` `ap` | Paragraph |
| `i"` `a"` `i'` `a'` | Quoted string |
| `i(` `i)` `ib` | Parenthesized block |
| `i{` `i}` `iB` | Braced block |
| `i[` `i]` | Bracketed block |
| `it` `at` | XML/HTML tag |

So `ci(` changes everything inside the parens; `dap` deletes a paragraph and
its trailing blank line; `ya"` yanks a string with its quotes.

## Editing shorthand

| Key | Equivalent |
|---|---|
| `x` | `dl` — delete character |
| `s` | `cl` — substitute character |
| `D` `C` `Y` | `d$`, `c$`, `yy` |
| `r{c}` | Replace one character, stay in normal mode |
| `J` | Join the next line onto this one |
| `u` `Ctrl-r` | Undo / redo |
| `.` | Repeat the last change |

`.` is the highest-leverage key in vim: make a change small enough that
repeating it is useful, then walk the file repeating it.

## Search and substitute

| Command | Does |
|---|---|
| `/pat` `?pat` | Search forward / backward |
| `n` `N` | Next / previous match |
| `*` `#` | Search for the word under the cursor, forward / back |
| `:%s/old/new/g` | Substitute in the whole file, every occurrence |
| `:%s/old/new/gc` | …confirming each |
| `:s/old/new/g` | Current line only |
| `:'<,'>s/old/new/g` | Within the visual selection |
| `:g/pat/d` | Delete every line matching `pat` |
| `:v/pat/d` | Delete every line *not* matching `pat` |
| `:noh` | Clear search highlighting |

## Registers, marks, macros

| Command | Does |
|---|---|
| `"ayy` `"ap` | Yank to / put from register `a` |
| `"+y` `"+p` | Yank to / put from the system clipboard |
| `:reg` | List registers |
| `:let @+ = getcwd()` | Put the working directory on the system clipboard |
| `:let @{r} = {expr}` | Write any expression's value into register `{r}` |
| `m{a}` | Set mark `a` |
| `` `{a} `` `'{a}` | Jump to mark `a` — exact position / its line |
| `q{a}` … `q` | Record a macro into register `a` |
| `@a` `@@` | Play macro `a` / replay the last one |
| `{n}@a` | Play it `n` times |

Macros are just recorded keystrokes stored in a register, which is why `"ap`
pastes a macro as text and `"ay$` yanks edited text back into one.

Registers are also variables: `@{r}` is readable and assignable inside any
expression, so `:let` writes into one whatever a function returns — `getcwd()`
for the working directory, `expand('%:p')` for the current file's full path,
`expand('%')` for its path relative to the working directory. Assigning to `@+`
targets the system clipboard, which is what makes the value available outside
vim.

## Files, buffers, windows

| Command | Does |
|---|---|
| `:w` `:w!` | Write / force write |
| `:q` `:q!` `:wq` `ZZ` | Quit / discard / write and quit |
| `:e {file}` `:e!` | Edit a file / reload discarding changes |
| `:ls` `:b {n}` `:bd` | List / switch / delete buffers |
| `Ctrl-w s` `Ctrl-w v` | Split horizontally / vertically |
| `Ctrl-w h j k l` | Move between windows |
| `Ctrl-w q` `Ctrl-w o` | Close this window / close all others |
| `:tabnew` `gt` `gT` | New tab / next / previous |
| `:sp {file}` | Open a file in a split |

## Terminal buffers

| Command | Does |
|---|---|
| `:term` | Open a terminal in the current window |
| `:split \| term` | Split horizontally and open a terminal in the new window |
| `:vsplit \| term` | Same, vertically |
| `<C-\><C-n>` | Leave terminal mode for normal mode |

`|` is the Ex command separator, so `:split | term` is two commands in one
line — make the window, then fill it.

A terminal buffer has its own mode: keystrokes go to the running shell, not to
vim, so `Esc` reaches the shell rather than vim and the usual normal-mode keys
are unavailable. `<C-\><C-n>` is the way out, and it works from any mode, not
just this one. Once in normal mode the buffer behaves like any other — scroll
it, search it, yank from it — and `i` or `a` returns to the shell.

That is also the route to pasting into a terminal: `<C-\><C-n>` then `"+p`.

## LSP mappings

Not stock vim — these are Neovim LSP buffer-local mappings, bound in
`~/.config/nvim/init.lua` when a language server attaches. Leader is `Space`.

| Key | Calls | Does |
|---|---|---|
| `gd` | `vim.lsp.buf.definition` | Jump to the definition of the symbol under the cursor |
| `gr` | `vim.lsp.buf.references` | List every reference to the symbol |
| `K` | `vim.lsp.buf.hover` | Show the symbol's type signature and docs in a float |
| `<leader>r` | `vim.lsp.buf.rename` | Rename the symbol across the project |
| `<leader>a` | `vim.lsp.buf.code_action` | Offer the server's fixes and refactors at the cursor |

`gd` and `gr` shadow stock vim's local-declaration jump and virtual-replace
mode; `K` shadows the keyword-lookup command. They apply only in buffers with
an attached server.

## Plugin mappings

Also from `~/.config/nvim/init.lua`, and global rather than buffer-local. A
plugin's Ex command is its API; the leader mapping is the interface — bind it
once, drive it in two keystrokes.

| Key | Runs | Does |
|---|---|---|
| `<leader>e` | `:NvimTreeToggle` | Open/close the file-tree sidebar |
| `<leader>f` | `:NvimTreeFindFile` | Open the tree focused on the current file |
| `<leader>p` | `:Telescope find_files` | Fuzzy-find a file by name |
| `<leader>g` | `:Telescope live_grep` | Fuzzy-search file contents |
| `<leader>b` | `:Telescope buffers` | Switch between open buffers |

For a command used too rarely to bind, `<Tab>` completes on the command line —
`:Nvim<Tab>` cycles the plugin's commands, same as for built-ins.

## Composition worth internalizing

| Keystrokes | Effect |
|---|---|
| `ci"` | Replace a string's contents |
| `dt,` | Delete up to the next comma |
| `yiw` then `viwp` | Copy a word, paste over another |
| `>ip` | Indent the current paragraph |
| `qqA;<Esc>jq` then `10@q` | Append `;` to eleven consecutive lines |
| `:g/TODO/normal dd` | Run a normal-mode command on every matching line |
| `Ctrl-v` `{motion}` `I` text `Esc` | Insert text on every line of a block |
| `gv` | Reselect the last visual selection |
