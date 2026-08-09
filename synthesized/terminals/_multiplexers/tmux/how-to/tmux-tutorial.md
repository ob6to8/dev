---
type: tutorial
title: tmux tutorial
description: The session/window/pane model, the prefix grammar, the key tables it generates, and the CLI that does the same work from outside.
provenance: "Claude Opus 5"
attribution:
  when: 2026-08-08
  channel: agent-authored
  agent: "Claude Code agent, operator request in session"
  why: "operator asked for a tmux tutorial as the first authored document in the tmux directory"
tags: [tmux, terminal, multiplexer, sessions, keybindings, tutorial]
timestamp: 2026-08-08
version: "tmux 3.7b, stock defaults (no ~/.tmux.conf on this machine)"
---

# tmux tutorial

tmux is a terminal multiplexer: it puts a server between your terminal emulator
and your shells. The shells belong to the server, not to the window you started
them from, which is the whole point — close the terminal, reboot the emulator,
ssh in from elsewhere, and the processes are still running.

Like vim, it is a small grammar rather than a list of shortcuts. Two ideas
generate almost everything below: the **object hierarchy** and the **prefix**.

## The object hierarchy

```
server
└── session      a workspace; what you attach to and detach from
    └── window   a full-screen tab within the session
        └── pane a split of a window; each pane is one shell (one pty)
```

- A **pane** is a process. Kill it and the shell dies.
- A **window** is a set of panes filling the screen. One is always active.
- A **session** is a set of windows plus the currently-attached client(s).
- The **server** starts on first use and exits when the last session ends.

Detaching leaves the session running on the server with no client attached.
Nothing stops; output just accumulates. That is the feature people come for.

## The prefix

Every tmux key is `prefix` then a key. Stock prefix is `Ctrl-b`; `Ctrl-a` is the
common rebind (see [Configuration](#configuration)). Notation below: `C-b %`
means press `Ctrl-b`, release, then `%`.

```
<prefix><key>              one command
<prefix><count><key>       rarely used; counts are not general like vim's
<prefix>:<command>         the command prompt — every binding is just a command
```

The last form is the grammar underneath: keys are bindings to commands, and any
command can be typed at the `:` prompt or run from the shell as
`tmux <command>`. Learn a command once and you have it in three places.

## Starting and attaching

| Shell command | Does |
|---|---|
| `tmux` | Start a server (if needed) and a new unnamed session |
| `tmux new -s work` | New session named `work` |
| `tmux ls` | List sessions, their window counts, and attach state |
| `tmux attach` / `tmux a` | Attach to the most recently used session |
| `tmux a -t work` | Attach to `work` |
| `tmux new -A -s work` | Attach to `work` if it exists, else create it — the idempotent form worth aliasing |
| `tmux kill-session -t work` | Kill one session |
| `tmux kill-server` | Kill everything |

`tmux a -d -t work` detaches other clients as it attaches — use it when two
terminals fighting over one session forces both to the smaller screen size.

## Sessions

| Key | Does |
|---|---|
| `C-b d` | Detach; the session keeps running |
| `C-b s` | Interactive session tree; navigate and `Enter` to switch |
| `C-b $` | Rename the current session |
| `C-b (` / `C-b )` | Previous / next session |
| `C-b L` | Switch to the last-used session |

## Windows

| Key | Does |
|---|---|
| `C-b c` | Create a window |
| `C-b ,` | Rename the current window |
| `C-b &` | Kill the current window (prompts) |
| `C-b n` / `C-b p` | Next / previous window |
| `C-b 0`–`C-b 9` | Jump to window by index |
| `C-b '` | Prompt for a window index |
| `C-b w` | Interactive window list across all sessions |
| `C-b l` | Last-used window — the fastest binding in tmux |
| `C-b f` | Find a window by name |
| `C-b .` | Move the window to a different index |

## Panes

| Key | Does |
|---|---|
| `C-b %` | Split vertically (new pane to the right) |
| `C-b "` | Split horizontally (new pane below) |
| `C-b <arrow>` | Move to the pane in that direction |
| `C-b o` | Cycle to the next pane |
| `C-b ;` | Last-used pane |
| `C-b q` | Show pane numbers; press one to jump there |
| `C-b x` | Kill the pane (prompts) |
| `C-b z` | Zoom — toggle the pane to full window and back |
| `C-b {` / `C-b }` | Swap the pane with the previous / next one in the layout |
| `C-b space` | Cycle through the preset layouts |
| `C-b !` | Break the pane out into its own window |
| `C-b C-<arrow>` | Resize by one cell |
| `C-b M-<arrow>` | Resize by five cells |
| `C-b t` | Clock (mostly a party trick; useful to confirm the prefix works) |

`C-b z` deserves emphasis: it is how you work in a split layout without ever
resizing anything. Zoom in, work, zoom out.

Splits inherit the current pane's working directory only if told to:
`tmux split-window -c "#{pane_current_path}"`, which is a standard config line.

## Copy mode

Copy mode is how you scroll, search scrollback, and select text without the
mouse. Stock key table is emacs-style; `setw -g mode-keys vi` switches it to vi
motions, which is the usual choice next to a vim workflow.

| Key | Does |
|---|---|
| `C-b [` | Enter copy mode |
| `q` | Leave copy mode |
| arrows / `C-u` `C-d` | Scroll (with `mode-keys vi`, all vim motions work) |
| `/` and `?` | Search forward / backward, `n` `N` to repeat |
| `space` (vi: `v`) | Start selection |
| `Enter` (vi: `y`) | Copy selection and exit |
| `C-b ]` | Paste the buffer |
| `C-b =` | List paste buffers and choose one |

Buffers are tmux's own, not the system clipboard. To bridge them on macOS:

```tmux
bind -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"
```

Related, from the shell: `tmux capture-pane -p -S -` dumps the entire scrollback
of the current pane to stdout — the right tool when you want a pane's output in
a file rather than in a selection.

## The command prompt and the CLI

`C-b :` opens tmux's command prompt. The same commands run from any shell, which
is what makes tmux scriptable and worth wiring into agent workflows.

| Command | Does |
|---|---|
| `tmux new-window -n logs 'tail -f app.log'` | Window running a command; it closes when the command exits |
| `tmux split-window -h -c "#{pane_current_path}"` | Split, keeping the directory |
| `tmux send-keys -t work:2.1 'make test' Enter` | Type into a specific pane from outside |
| `tmux capture-pane -p -t work:2.1` | Read a pane's contents to stdout |
| `tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}'` | Inventory every pane |
| `tmux display -p '#{pane_current_path}'` | Print a format variable |
| `tmux source-file ~/.tmux.conf` | Reload config without restarting |

Targets are `session:window.pane`; any part may be omitted to mean "current".
`send-keys` plus `capture-pane` is a complete read/write interface to a live
shell — a long-running process becomes something a one-shot script can drive.

## Configuration

Stock tmux is usable but under-configured. `~/.tmux.conf` is read at server
start; `tmux source-file ~/.tmux.conf` reloads it. A minimal set that earns its
place:

```tmux
# Prefix on the home row; C-b collides with vim's page-up
set -g prefix C-a
unbind C-b
bind C-a send-prefix          # C-a C-a reaches the inner tmux or the shell

set -g base-index 1           # windows start at 1, matching the number row
setw -g pane-base-index 1
set -g renumber-windows on

set -g mouse on               # scroll, select panes, drag borders
set -sg escape-time 10        # stop tmux eating Esc before vim sees it
set -g history-limit 50000

setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"

# Splits that keep the current directory, on more mnemonic keys
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

bind r source-file ~/.tmux.conf \; display "reloaded"
```

`escape-time` is the one people regret skipping: at the default, tmux waits long
enough after `Esc` that vim's mode switches feel laggy inside tmux.

## Nesting

Running tmux inside tmux (ssh into a remote that also runs tmux) means two
servers see the same prefix. Two conventions:

- **`C-a C-a`** — with `bind C-a send-prefix`, pressing the prefix twice sends it
  through to the inner session. Simplest, no config on the far side.
- **Different prefixes** — inner session uses `C-b`, outer uses `C-a`. Clearer,
  but requires config in both places.

tmux inside a neovim `:terminal` is the same collision one layer over: nvim's
terminal-mode escape (`C-\ C-n`) and tmux's prefix both want the keystroke, and
the conventional layering is the reverse — tmux outside, nvim in a pane. See
[tmux-in-nvim](../questions/tmux-in-nvim.md) and
[tmux-in-neovim-2](../questions/tmux-in-neovim-2.md) in this repo.

## Getting unstuck

| Symptom | Cause / fix |
|---|---|
| Prefix does nothing | Another program grabbed the key, or you are in an inner session — try `C-b C-b` |
| `no server running on /tmp/tmux-501/default` | No sessions exist; just run `tmux` |
| `sessions should be nested with care` | You are already inside tmux; use `C-b s` to switch, or `tmux new -d` then switch |
| Screen sized to someone else's terminal | Another client is attached — `tmux a -d` to force them off |
| Colors wrong in vim | `set -g default-terminal "screen-256color"` (or `tmux-256color`) in the config |
| `Esc` feels slow in vim | `set -sg escape-time 10` |
| Scrollback lost on window resize | Expected; raise `history-limit` and use `capture-pane` for anything you need to keep |

## Composition worth internalizing

| Sequence | Effect |
|---|---|
| `tmux new -A -s work` | One command that both creates and resumes a workspace |
| `C-b %` then `C-b z` | Split for reference, zoom to work, zoom back |
| `C-b l` | Bounce between two windows without thinking about indices |
| `C-b [` `/pattern` `Enter` `n` | Search the scrollback of a long-running process |
| `tmux capture-pane -p -S - > out.txt` | Persist a pane's full history to a file |
| `tmux send-keys -t build 'make' Enter` | Drive a session from a script or an ephemeral agent |
| `C-b !` | Promote a pane that outgrew its split into its own window |
| `C-b d` then `ssh` elsewhere then `tmux a` | The same shells, from a different machine |
