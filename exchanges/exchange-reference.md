SCHEMA:
xxxx-xx-xx-<exchange-name>.md

---
id:  
session_id:  
date: 
model:  
cost_usd:
cwd: 
deps: <nil or blank>
---

## Prompt
#human-authored
...

## Response
#agent-authored
...



EXAMPLE 1:
2026-08-08-.md

---
id: 0001
session_id: 531c8e45-3aab-4cfc-a746-7fc7939a9c5a
date: 2026-08-08T13:42:00Z
model: claude-opus-5
cost_usd: 0.0412
cwd: /Users/mark/dev/repos/dev
deps:
---

## Prompt
#human-authored

What is a banana

## Response
#agent-authored

A fruit


EXAMPLE 2:
2026-08-08-.md

---
id: 0001
session_id: 531c8e45-3aab-4cfc-a746-7fc7939a9c5a
date: 2026-08-08T14:42:00Z
model: claude-opus-5
cost_usd: 0.0412
cwd: /Users/mark/dev/repos/dev
deps: <link-to-the-file-path-of-example-1.md> 
---

## Prompt
#human-authored

Where do bananas grow

## Response
#agent-authored

On trees
