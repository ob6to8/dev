#!/usr/bin/env bash
#
# askq - ask Claude Code a question in print mode ("claude -p") and capture
# both the question and its answer into a single markdown file.
#
# How it works:
#   The question is stored in a shell variable first, so it is captured
#   verbatim before being sent to Claude. This guarantees the "## Question"
#   section in the output file matches exactly what you typed, rather than
#   asking Claude to repeat the question back (which risks paraphrasing).
#   `claude -p "$q"` runs Claude Code in print (non-interactive) mode: it
#   sends the prompt, prints the response to stdout, and exits (no REPL).
#   The echoed question and the response are grouped and redirected
#   together into one output file.
#
# Usage:
#   Run directly:
#     ./askq.sh "What is the capital of France?"            # writes qa-output.md
#     ./askq.sh "What is the capital of France?" answer.md   # writes answer.md
#
#   Or source it to load `askq` as a function in your current shell:
#     source askq.sh
#     askq "What is the capital of France?" answer.md

askq() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: askq \"question\" [output-file]" >&2
    return 1
  fi

  local q="$1"
  local out="${2:-qa-output.md}"

  {
    echo "## Question"
    echo "$q"
    echo
    echo "## Answer"
    claude -p "$q"
  } > "$out"

  echo "Saved to $out"
}

# Only run automatically when executed directly, not when sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
  askq "$@"
fi
