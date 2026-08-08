mark@Marks-MacBook-Pro-2 repos % claude -p "examine sessions and itsjustshell to get a sense of how i am working with all ephemeral claude -p sessions. i am 
doing everything within neovim and the :term in neovim. could tmux be a good option for running multiple "agents", ie. claude -p calls in terminal tabs?"
Yes — and it fits your itsjustshell thesis better than any alternative. tmux is another Unix primitive (a process that owns ptys), not a framework layered on
 top of one.

**What you already found** (`sessions/tmux/questions/tmux-in-nvim.md`): nvim's own `:tabnew`/`gt` only gives tab-*like* switching between terminal buffers — 
no detach, no persistence if nvim dies. Real tabs with persistence means tmux outside, nvim inside one pane.

**For your specific use case — parallel `claude -p` agents — that's a stronger case, not just a nice-to-have:**

- **Each pane = an independent node.** This maps directly onto what the graph-engineering session already noted about your `sessions` repo: `claude -p` calls
 are stateless, file-in/file-out nodes. tmux panes give you the runtime container for that — one process per node, visually separated, independently killable
/restartable without taking down the others.
- **Detach/reattach solves your actual pain point.** A long `claude -p` call s
ly — `tmux attach` picks the session back up. Neither Warp tabs nor nvim `:ter
- **It sidesteps the Warp freeze bug you hit** (`sessions/warp/troubleshooting
aude -p`'s hook lifecycle. Inside tmux, Warp only ever sees one long-lived pro
ude -p` invocati
ons directly, so there's nothing for the plugin to latch onto and desync. Clea
- **`send-keys` gives you scriptable fan-out**, which is the actual "run N age

```bash
for topic in a b c; do
  tmux new-window -n "$topic" "claude -p 'research $topic' > $topic.md"
done
```
or `tmux new-session -d`, `split-window`, `send-keys ... Enter` per pane if yo

**One tension worth naming**: this only externalizes the container, not the ro
