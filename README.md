#human-authored

This repo is based around a shell based development workflow. Agentic integration is ephemeral and persisted to files, currently via 'claude -p'. This means there is no such thing as a thread or agent conversation during dev or ideation, every question gets one response, and the exchange ends. There is no saved state in the agent such as there typically is with TUI agent interfaces (ie. Claude Code, Codex, etc.). Instead, every exchange is treated like a file based modular component, stored as "exchanges" in ./exchanges/exchanges. Accrued knowledge builds up discretely turn by turn. Thought needs to be put into where it will be persisted before it actually appears.  

All text is specified to be either "#human-authored" or "#agent-authored", indicated by the tag. 

"#agent-authored" written content will link to the file holding the exchange that gave rise to it. this counts for prose (md files) as well as code. Given all agent interactions related to this repo are ephemeral, ongoing sequences of exchanges around a common focus are derived after the fact through explicit exchange dependencies tracked in the frontmatter of exchange documents.  

Information is persisted as three types:

### Input
Two input kinds representing persisted verbatim information records: exchanges and resources. 

#### Exchanges
Exchanges are single turn exchanges between an operator and an agent within a set document schema, persisted as a flat collection within exchanges/exchanges. 

Aggregations of linked exchanges are persisted as "threads", in exchanges/threads.

#### Resources
Resources are links to informational resources on the web, persisted as a flat list in /resources.

### Output
Three output kinds reprenting authored outputs by the system:

#### Functions 
These are either implementation references or standalone actionable scripts.

#### Data
Data either as reference schema or to be incorporated into functions or programs.

#### Programs 
Assemblies of functions and/or data to construct standalone programs. 



### Synthesized

Data that is synthesized from input sources, as well as analysis and documentation of outputs. Human or LLM synthesized, marked as such in either case.
The only data type where the file structure is a taxonomy, and doubles as tags for instances of type input and output. 
Instances hold links to any referrant inputs as deps.



