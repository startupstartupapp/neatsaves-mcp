#!/usr/bin/env sh
# The plain JSON API. Set the two variables from Neatsaves Settings first.
NEATSAVES_URL="https://YOUR-DEPLOYMENT.convex.site"
NEATSAVES_KEY="bm_YOUR_KEY"
auth="Authorization: Bearer $NEATSAVES_KEY"

# Who the key belongs to
curl -s -H "$auth" "$NEATSAVES_URL/api/me"

# Search by meaning and keywords (limit is 1 to 50)
curl -s -H "$auth" "$NEATSAVES_URL/api/items?q=local+models&limit=5"

# Your newest saves, no query
curl -s -H "$auth" "$NEATSAVES_URL/api/items?limit=10"

# One save in full: text, transcript, next step, checklist (take an id from a list above)
curl -s -H "$auth" "$NEATSAVES_URL/api/item?id=SAVE_ID"

# Save a link. It is read, filed and given a next step on its own.
curl -s -X POST -H "$auth" -H "content-type: application/json" \
  -d '{"url":"https://github.com/ollama/ollama","note":"for the local-model spike"}' \
  "$NEATSAVES_URL/api/save"
