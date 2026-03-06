#!/bin/bash
# .claude/hooks/my-hook.sh
#
# A PreToolUse hook that inspects Bash commands before they run.
# Claude sends JSON context on stdin. Your script reads it, checks
# conditions, and exits with the right code:
#
#   exit 0   allow the tool call
#   exit 2   block it (stderr is fed back to Claude as an error)
#
# Register this hook in .claude/settings.json:
#
#   {
#     "hooks": {
#       "PreToolUse": [
#         {
#           "matcher": "Bash",
#           "hooks": [
#             {
#               "type": "command",
#               "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/my-hook.sh"
#             }
#           ]
#         }
#       ]
#     }
#   }

# ── Read JSON input from stdin ──────────────────────────────────
# Every hook receives a JSON object with common fields (session_id,
# cwd, hook_event_name) plus event-specific fields. For PreToolUse
# on Bash, the key field is tool_input.command.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

# ── Check conditions ────────────────────────────────────────────
# This example blocks destructive shell commands. Replace this
# logic with whatever validation your project needs: file path
# checks, environment gates, command allowlists, etc.

if echo "$COMMAND" | grep -q 'rm -rf'; then
  # stderr goes back to Claude as an error message
  echo "Blocked: 'rm -rf' is not allowed by project hooks." >&2
  exit 2
fi

if echo "$COMMAND" | grep -q 'git push.*--force'; then
  echo "Blocked: force-pushing is not allowed by project hooks." >&2
  exit 2
fi

# ── Allow everything else ───────────────────────────────────────
# Exit 0 with no output means "proceed normally." You can also
# print JSON to stdout for finer control:
#
#   # Auto-approve (skip permission prompt):
#   echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
#
#   # Deny with a reason Claude sees:
#   echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Reason here"}}'
#
#   # Ask the user to confirm:
#   echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask"}}'
#
#   # Modify the tool input before execution:
#   echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":"safer-command"}}}'

exit 0
