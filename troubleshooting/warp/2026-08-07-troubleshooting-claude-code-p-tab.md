User: i am in warp terminal. i am contacting claude via claude -p. on the left sidebar, sometimes it stays the >_ icon, which indicates its a normal terminal tab. these tabs work fine. but sometimes, it gets the orange icon and renames itself to claude, indicating it believes that a claude code tui instance is running in the pane. when this happens, it freezes. in one tab, it was working fine, then did this and started freezing. any idea what is happening?

**What's happening:**

That plugin isn't a Warp-side heuristic guessing from the process name — it's a Claude Code plugin that registers hooks (`SessionStart`, `Stop`, `Notification`, `PermissionRequest`, `UserPromptSubmit`, `PostToolUse`). Each hook fires an OSC 777 escape sequence to `warp://cli-agent`, and Warp's pane UI (icon, tab title, "agent" tracking mode) is driven entirely by those signals, not by anything it observes about the process itself.

Sequence for your frozen tab:
1. `claude -p` runs → the plugin's `SessionStart` hook fires → sends the OSC signal → Warp switches that pane to "Claude Code agent" mode (orange icon, renamed tab, and it starts routing/expecting agent-status input rather than plain terminal I/O).
2. Normally the `Stop` hook fires when Claude finishes, sending the matching "done" signal that releases the pane back to normal.
3. If `Stop` never fires — the invocation is piped, backgrounded, killed, times out, errors before completion, or `-p` mode simply doesn't run the full hook lifecycle the interactive TUI does — Warp is left believing a live agent session is still active in that pane. It keeps waiting on agent-protocol messages that never arrive, which is what you're seeing as "freezing." The other tabs are unaffected because each pane's agent-state is tracked independently.

This matches two open Warp bugs — [warpdotdev/Warp#8409](https://github.com/warpdotdev/Warp/issues/8409) and [#8805](https://github.com/warpdotdev/Warp/issues/8805) — where Warp hangs/becomes unresponsive specifically during Claude Code sessions, unhanging only once Claude's process itself finishes (i.e., Warp is stuck waiting on session-state, not actually CPU-hung). Warp also shipped a related fix for tab titles getting stuck on "Wants to run AskUserQuestion" after a stale state wasn't cleared — same family of bug: hook-signal lifecycle not always matching Warp's expected start/stop pairing.

**Fixes:**
- When it freezes: don't wait it out — close the tab and open a new one. Input isn't reaching the pane because Warp isn't routing it as a plain shell anymore.
- If you mainly use `claude -p` (non-interactive/scripted) rather than interactive sessions, disable the integration to stop this from happening at all:
  ```
  /plugin uninstall warp@claude-code-warp
  ```
  (or just flip `"warp@claude-code-warp": false` in `~/.claude/settings.json` under `enabledPlugins`). You'll lose Warp's native notifications for interactive sessions, but `-p` runs will stay plain terminal tabs.
- If you want to keep it for interactive use but not `-p`, there's no built-in per-invocation opt-out in the plugin — it hooks globally — so the tradeoff above is the only lever currently.
- Worth a 👍/comment on #8409 or #8805 since this looks like the same underlying issue, just triggered via `-p` rather than the interactive TUI.

Sources:
- [Warp hangs for minutes... Issue #8409](https://github.com/warpdotdev/Warp/issues/8409)
- [Claude Code causes Warp to hang · Issue #8805](https://github.com/warpdotdev/Warp/issues/8805)
- [warpdotdev/claude-code-warp README](https://github.com/warpdotdev/claude-code-warp)
- [Claude Code in Warp docs](https://docs.warp.dev/agent-platform/cli-agents/claude-code/)
