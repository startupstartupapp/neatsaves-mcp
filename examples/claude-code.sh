#!/usr/bin/env sh
# Adds the Neatsaves MCP server to Claude Code.
# Settings > "Claude Code, Cursor and the API" in the Neatsaves app prints this command with your
# real address and key already filled in. Copy it from there; this file only shows the shape.
claude mcp add --transport http neatsaves \
  "https://YOUR-DEPLOYMENT.convex.site/mcp" \
  --header "Authorization: Bearer bm_YOUR_KEY"

# --scope user puts it in every project instead of only the one you are in:
# claude mcp add --scope user --transport http neatsaves ...
# Then start Claude Code and type /mcp. neatsaves should show as connected.
