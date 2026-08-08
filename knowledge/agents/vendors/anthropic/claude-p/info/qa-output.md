## Question
what flags can you pass with claude -p

## Answer
Here's the full `claude -p` flag list from your installed version, grouped by what they do:

**Core**
- `-p, --print` — non-interactive, print response and exit
- `--output-format <text|json|stream-json>` — output shape
- `--input-format <text|stream-json>` — for streaming input
- `--model <name>` — e.g. `sonnet`, `opus`, `fable`
- `--effort <low|medium|high|xhigh|max>`

**Permissions/tools**
- `--allowedTools` / `--disallowedTools <tools...>`
- `--permission-mode <mode>` — `acceptEdits|auto|bypassPermissions|manual|dontAsk|plan`
- `--dangerously-skip-permissions` / `--allow-dangerously-skip-permissions`
- `--tools <tools...>` — restrict built-in tool set

**Context/config**
- `--add-dir <dirs...>`
- `--system-prompt <prompt>` / `--append-system-prompt <prompt>`
- `--settings <file-or-json>`
- `--setting-sources <user,project,local>`
- `--mcp-config <configs...>` / `--strict-mcp-config`
- `--agents <json>` / `--agent <name>`
- `--plugin-dir <path>` / `--plugin-url <url>`

**Session control**
- `-c, --continue`
- `-r, --resume [session_id]`
- `--session-id <uuid>`
- `--fork-session`
- `--no-session-persistence`
- `--from-pr [value]`
- `--teleport [session]`

**Cost/reliability**
- `--max-budget-usd <amount>`
- `--fallback-model <models...>`

**Streaming output detail** (needs `--output-format=stream-json`)
- `--include-partial-messages`
- `--include-hook-events`
- `--forward-subagent-text`
- `--replay-user-messages`

**Structured output**
- `--json-schema <schema>`

**Misc**
- `--bare` — minimal mode, skips hooks/LSP/CLAUDE.md/etc.
- `--safe-mode` — disables all customizations
- `-d, --debug [filter]` / `--debug-file <path>`
- `--betas <betas...>`
- `-v, --version`

Most common for scripting: `claude -p "prompt" --output-format json --allowedTools "Bash,Edit" --permission-mode acceptEdits`.
