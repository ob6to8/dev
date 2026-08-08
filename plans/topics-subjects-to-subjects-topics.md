# Plan: invert `topics/subjects` → `subjects/topics`

Status: **draft — needs operator answers before execution** (see "Open questions" below).
This doc is the discussion surface since the authoring session is ephemeral (`claude -p`). Edit it in place — add answers under each question, or leave inline notes — and a future session will pick it up and execute.

## Current organization (as of 2026-08-07)

The repo is currently organized `topic/subject/file`: the top-level directories are *topics* (what kind of content — a command, a how-to, troubleshooting notes), and each contains one subdirectory per *subject* (what the content is about — `claude-p`, `bash`, `neovim`, `elixir`, `warp`).

```
commands/
  claude-p/askq.sh
  elixir/elixir-in-shell.md
  bash/shell-commands.md
  neovim/tabs.md
how-to/
  claude-p/capture-a-response-into-a-file.md
  neovim/            (empty)
  shell/             (empty)
info/
  claude-p/full-claude-p-flag-list.md
questions/
  tmux-in-nvim.md    (no subject subdir — sits directly under the topic)
troubleshooting/
  claude-p/          (empty)
  warp/2026-08-07-troubleshooting-claude-code-p-tab.md
exec-commands/       (empty, root-level, not clearly a topic)
claude-p.md          (root-level file, not filed under any topic/subject)
shell                (root-level file, no extension — not filed under any topic/subject)
test.txt             (root-level file — looks like scratch/test debris)
```

Five topics exist: `commands`, `how-to`, `info`, `questions`, `troubleshooting`.
Five-ish subjects exist across them: `claude-p`, `bash`, `neovim`, `elixir`, `warp` — plus loose references to "shell" that don't cleanly line up with the `bash` subject (see open questions).

## Proposed organization: `subject/topic/file`

Flip the nesting so each subject is a top-level directory, and topics become subdirectories under it:

```
claude-p/
  commands/askq.sh
  how-to/capture-a-response-into-a-file.md
  info/full-claude-p-flag-list.md
  troubleshooting/           (empty — carried over from troubleshooting/claude-p/)
elixir/
  commands/elixir-in-shell.md
bash/
  commands/shell-commands.md
neovim/
  commands/tabs.md
  how-to/                    (empty — carried over from how-to/neovim/)
  questions/tmux-in-nvim.md  (see open question #3 — currently unfiled by subject)
warp/
  troubleshooting/2026-08-07-troubleshooting-claude-code-p-tab.md
```

### File-by-file mapping

| Current path | New path |
|---|---|
| `commands/claude-p/askq.sh` | `claude-p/commands/askq.sh` |
| `how-to/claude-p/capture-a-response-into-a-file.md` | `claude-p/how-to/capture-a-response-into-a-file.md` |
| `info/claude-p/full-claude-p-flag-list.md` | `claude-p/info/full-claude-p-flag-list.md` |
| `troubleshooting/claude-p/` (empty) | `claude-p/troubleshooting/` (empty) |
| `commands/elixir/elixir-in-shell.md` | `elixir/commands/elixir-in-shell.md` |
| `commands/bash/shell-commands.md` | `bash/commands/shell-commands.md` |
| `commands/neovim/tabs.md` | `neovim/commands/tabs.md` |
| `how-to/neovim/` (empty) | `neovim/how-to/` (empty) |
| `how-to/shell/` (empty) | ??? — see open question #2 |
| `questions/tmux-in-nvim.md` | `neovim/questions/tmux-in-nvim.md` — see open question #3 (this file is arguably as much about tmux/terminal multiplexing as neovim) |
| `troubleshooting/warp/2026-08-07-troubleshooting-claude-code-p-tab.md` | `warp/troubleshooting/2026-08-07-troubleshooting-claude-code-p-tab.md` |
| `exec-commands/` (empty, root) | ??? — see open question #4 |
| `claude-p.md` (root) | ??? — see open question #5 |
| `shell` (root, no extension) | ??? — see open question #6 |
| `test.txt` (root) | ??? — see open question #7 |

## Open questions for the operator

Please answer inline (edit this file directly) so a future session can execute without re-asking.

1. **Naming collision: `bash` vs `shell`.** The repo has a `commands/bash/` subject dir, but also a root-level `how-to/shell/` (empty) and a stray root file literally named `shell`. Should the subject going forward be called `bash` (matches current subject dir) or `shell` (matches the two loose references)? Recommend picking one and merging the other into it.
   - **Answer:**
   bash

2. **`how-to/shell/` (empty dir).** Was this a placeholder for future shell how-tos, or dead weight from an earlier reorg? Fold into whichever subject you pick in Q1, or delete?
   - **Answer:**
   delete

3. **`questions/tmux-in-nvim.md` subject assignment.** Content is about neovim *and* tmux. There's no `tmux` subject elsewhere in the repo. File it under `neovim/questions/`, or should `tmux` become its own subject?
   - **Answer:**
   tumx should become its own subject

4. **`exec-commands/` (empty, root-level).** Doesn't fit the topic vocabulary (`commands`/`how-to`/`info`/`questions`/`troubleshooting`) — is this a topic you intend to keep (e.g. distinct from `commands/`), a stray, or safe to delete?
   - **Answer:**

5. **`claude-p.md` (root file, about `--system-prompt`/`--append-system-prompt`).** This reads like `info/claude-p/` content (a fact about a flag) — fold into `claude-p/info/`, perhaps merged with `full-claude-p-flag-list.md`, or kept as a separate file under `claude-p/info/system-prompt.md`?
   - **Answer:**
   separate

6. **`shell` (root file, no extension — a captured terminal transcript about extracting fenced code blocks from markdown).** Same shape as the `how-to/claude-p/` entries (a captured Q&A). Rename with a `.md` extension and file under the subject chosen in Q1 as a `how-to/` entry (e.g. `bash/how-to/extract-fenced-code-blocks.md`)?
   - **Answer:**
   yes

7. **`test.txt` (root file, contents: `test`).** Looks like scratch debris, not real content. OK to delete?
   - **Answer:**
   delete

8. **Empty directories in general** (`how-to/neovim/`, `how-to/shell/`, `troubleshooting/claude-p/`, `exec-commands/`) — git doesn't track empty directories, so these currently only exist on disk locally and aren't actually in the repo history. Confirm you want the *new* structure's empty placeholder dirs (e.g. `claude-p/troubleshooting/`, `neovim/how-to/`) preserved on disk (e.g. via a `.gitkeep`), or should empty dirs just be dropped and recreated organically when content shows up?
   - **Answer:**
   drop

9. **Execution mechanics.** Once the above are answered, execution is a set of `git mv` calls per the mapping table (adjusted per answers) followed by a commit. Any preference on commit granularity (one commit for the whole move vs. one per subject), or should a future session just do it in one shot?
   - **Answer:**
   one shot

## Execution checklist (for the session that carries this out)

- [ ] Confirm all "Open questions" above have operator answers.
- [ ] Re-run `find . -not -path './.git*' | sort` to confirm no files have changed since this plan was written (avoid clobbering new work).
- [ ] `git mv` each file per the (possibly-revised) mapping table.
- [ ] Recreate empty placeholder dirs per answer to Q8 if wanted.
- [ ] Verify no topic dir (`commands/`, `how-to/`, `info/`, `questions/`, `troubleshooting/`) remains at repo root — everything should hang off a subject dir instead.
- [ ] `git status` review before commit — check nothing unexpected got swept in.
- [ ] Commit with a message describing the topics/subjects → subjects/topics inversion.

## Follow-up questions (execution session, 2026-08-07)

Re-checked the repo (`find . -not -path './.git*' | sort`) — matches the plan exactly, nothing has changed since this doc was written. All open questions have operator answers except one:

- **Q4 (`exec-commands/`, empty, root-level) is still unanswered.** Every other question (Q1, Q2, Q3, Q5, Q6, Q7, Q8, Q9) has an answer, so this is the only blocker to execution. Please answer inline above under Q4, or here:
  - **Answer:**

