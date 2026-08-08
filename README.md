#human-authored

This repo is based around a shell based development workflow. Agentic integration is ephemeral and persisted to files, currently via 'claude -p'. This means there is no such thing as a thread or agent conversation during dev, every question gets one answer. There is no saved state in the agent such as there typically is with TUI agent interfaces (ie. Claude Code, Codex, etc.). Instead, every exchange is treated like a file based modular component. Accrued knowledge builds up turn by turn, and thought needs to be put into where it will be persisted before it actually appears.  

All text is specified to be either "#human-authored" or "#agent-authored", indicated by the tag. 

"#agent-authored" content will link to the file holding the exchange that gave rise to it. given all agent interactions related to this repo are ephemeral, 
