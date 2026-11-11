#!/usr/bin/env sh
# Talking to the MCP endpoint by hand: Streamable HTTP, JSON in, JSON out (no event stream).
NEATSAVES_URL="https://YOUR-DEPLOYMENT.convex.site"
NEATSAVES_KEY="bm_YOUR_KEY"
post() {
  curl -s -X POST "$NEATSAVES_URL/mcp" \
    -H "Authorization: Bearer $NEATSAVES_KEY" \
    -H "content-type: application/json" \
    -d "$1"
}

post '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}'
post '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
post '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"search_saves","arguments":{"query":"paywall after onboarding"}}}'
