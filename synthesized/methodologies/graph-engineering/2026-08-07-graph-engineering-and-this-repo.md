mark@Marks-MacBook-Pro-2 repos % claude -p "reference the recent concept of graph engineering. after doing a research spike, exaplain what the concept is. then, consider a workflow somewhat reflected in the sessions repo. consider how doing all work with ephemaral agents via claude -p or api calls might lead to a componentized workflow that could help enable graph engineering - or make it mare challenging."
Now I have what I need. Here's the picture.

## Graph engineering, per the research

The term surfaced across several blogs in July 2026 as the successor to "loop engineering." Loop engineering was about designing *one* agent's prompt→act→observe cycle. Graph engineering is about designing the **topology a fleet of those loops runs inside**: which nodes exist (LLM agents, deterministic functions, routers, human checkpoints), which transitions between them are legal, and how the runtime work-graph forms and mutates as execution proceeds. The framing that stuck is "modeling execution, not just modeling one agent's behavior" — who runs next, what state they inherit, where results converge for a decision (ship / send back).

## Your sessions repo is already doing this, informally

I read through `/Users/mark/dev/repos/sessions`. It's a knowledge base built entirely from one-shot `claude -p` invocations, and it's a surprisingly clean real-world instance of the pattern:

- **`askq.sh`** is a componentized node type: capture a question verbatim in a shell var (so the ephemeral call can't paraphrase it), pipe it through `claude -p`, write Q+A to a file. A deterministic wrapper around a stateless LLM call — exactly the "deterministic function node next to an agent node" shape graph engineering describes.
- **`plans/topics-subjects-to-subjects-topics.md`** is the clearest artifact. One ephemeral session wrote a full reorg plan with open questions, then explicitly noted: *"This doc is the discussion surface since the authoring session is ephemeral (`claude -p`). Edit it in place... and a future session will pick it up and execute."* You answered inline; a second ephemeral session came back, diffed repo state against the plan to check nothing had drifted, found one unanswered question (Q4), and stopped rather than guessing — leaving the blocker for you.
- Git log (`shell commands and test`, `movin files around`, `moved stuff around`, `new stuff`) reads like a trail of independent, small, non-communicating runs — each one committing its own slice.

None of this uses a graph framework. The "graph" exists only as a *convention* — drop a plan doc, write open questions, wait for inline answers, re-check state before acting — that lives in your habits, not in code.

## Ephemeral `claude -p`/API calls as the componentization strategy

**Where it helps graph engineering:**
- Each call is *already* a clean node: fixed input (prompt + files), fixed output (stdout/file), no hidden state carried forward. That's the atomic unit graph engineering wants — you don't have to fight session state to compose calls into a DAG.
- Because state can't live in-process, it gets forced out into the filesystem/git — which makes every edge in the graph *legible*. You can literally `cat` the message passed between two "agents." That's the observability graph-engineering writeups (TrueFoundry etc.) call out as a hard problem for frameworks with in-memory agent state; you get it for free by being forced to externalize.
- Git history becomes a provenance/audit trail of graph execution at no extra cost.
- Cheap horizontal fan-out — spinning up N independent `claude -p` calls in parallel (or `parallel()`/`pipeline()` in this session's Workflow tool) maps directly onto the "branch to specialists, converge to a decision" shape from the definition.

**Where it makes graph engineering harder:**
- There's no runtime enforcing the topology — no declared node/edge list anywhere, so the "graph" only exists as tribal convention (write a plan doc, wait for a human). Two ephemeral sessions could race on the same handoff file with nothing but git's merge behavior to save you; there's no lock, no explicit dependency resolution.
- Routing is manual. "Which agent runs next" — the actual core question graph engineering is about — is currently answered by *you* running commands by hand, not by a router node evaluating conditions. That's fine at 12 files; it won't scale to a real multi-agent org topology.
- No single place shows current graph state (what's pending, what's blocked, what failed) — you have to reconstruct it by reading files and `git log`, same as I just did to answer this question. A graph engine gives you that as a first-class view.
- The pattern is closer to "loop engineering repeated by hand" than a designed graph unless you formalize it — which is exactly what a tool like this session's `Workflow` primitives (`agent()`/`pipeline()`/`parallel()`) would give you: nodes as `agent()` calls, edges as data threaded between stages, explicit barriers where you actually need synchronized state.

The honest takeaway: ephemeral CLI/API calls give you graph engineering's node primitive almost for free (stateless, composable, inspectable), but they don't give you the graph itself — topology, routing, and state-passing all have to be hand-built, and right now in your sessions repo they're built as a *social* convention (a plan doc you're expected to notice and answer) rather than a declared, executable one.

Sources:
- [explainx.ai — Graph Engineering: Wire Multi-Agent Orgs After Loops](https://explainx.ai/blog/graph-engineering-ai-agents-multi-agent-organizations-2026)
- [Medium (Gao Dalie) — Forget Loop Engineering, Graph Engineering is about THIS](https://medium.com/@GaoDalie_AI/forget-loop-engineering-graph-engineering-is-about-this-713a9cf2e985)
- [TrueFoundry — Graph Engineering for Multi-Agent Systems](https://www.truefoundry.com/blog/graph-engineering-enterprise-guide)
- [Medium (Naresh B A) — Graph Engineering for AI Coding Agents](https://medium.com/@phoenixarjun007/graph-engineering-for-ai-coding-agents-beyond-prompt-loops-dd74bc1c4608)
- [Eigent.ai — Graph Engineering for AI Agents](https://www.eigent.ai/blog/graph-engineering-ai-agents)
- [Flowtivity — From Loops to Graphs: The Next Paradigm](https://flowtivity.ai/blog/graph-engineering-2026-guide-openclaw-codex/)
- [AI Builder Club — Graph Engineering Guide](https://www.aibuilderclub.com/blog/graph-engineering-guide-2026)
