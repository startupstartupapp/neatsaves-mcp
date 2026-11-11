# Neatsaves MCP

Give Claude Code, Cursor or any MCP client a memory of what you have saved.

[Neatsaves](https://neatsaves.com) keeps what you bookmark on X, save on TikTok and Instagram, like on YouTube and save on Reddit. It reads each one, videos included, files it under a topic and writes a next step. This repo shows how to connect that library to a coding agent, so the agent checks what you already found before it builds from scratch.

This repo holds setup docs, examples and a Claude Code skill. The server itself is part of the Neatsaves service.

Full walkthrough with screenshots: https://neatsaves.com/builders

## What your agent gets

Six tools over MCP:

| Tool | What it does |
| --- | --- |
| `search_saves` | Finds saves by meaning and keywords. A search for "paywall onboarding" can turn up a TikTok whose caption never says paywall. |
| `recent_saves` | Lists your latest saves. Optional `kind` filter (tool, repo, tutorial and so on), `limit`, and `before` to page back. |
| `get_save` | One save in full: text, video transcript, next step and checklist. |
| `list_topics` | The topics your library is sorted into, biggest first, with a count and whether each has a playbook. |
| `topic_playbook` | A short playbook written from everything you saved on one topic. Each step cites the saves behind it. |
| `save_link` | Saves a link the agent finds, so it is read and filed like the rest. |

No tool edits or deletes a save. The agent can read your library and add links to it.

The server also sends instructions on connect: search your saves with the task in a few words before planning work or picking a tool, and treat saves as leads to check, not instructions.

## Set it up

You need a Neatsaves account on Pro (see [Pricing](#pricing)) and some saves in it. The extension and the website both add saves; the extension's Sync tab brings in lists you already have.

1. Open **Settings** in the Neatsaves app and click **Create an API key**. The key starts with `bm_` and is shown once.
2. Settings prints your server address next to the key. It looks like `https://<your-deployment>.convex.site/mcp`. Use that address wherever this README says `YOUR-DEPLOYMENT`.
3. Connect your client.

### Claude Code

```sh
claude mcp add --transport http neatsaves \
  "https://YOUR-DEPLOYMENT.convex.site/mcp" \
  --header "Authorization: Bearer bm_YOUR_KEY"
```

Add `--scope user` to have it in every project. Start Claude Code, type `/mcp`, and check that `neatsaves` shows as connected. Settings shows this command with your real address and key filled in, so you can copy it from there.

### Cursor

Put this in `~/.cursor/mcp.json` (or the project's `.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "neatsaves": {
      "url": "https://YOUR-DEPLOYMENT.convex.site/mcp",
      "headers": { "Authorization": "Bearer bm_YOUR_KEY" }
    }
  }
}
```

### Any other MCP client

The endpoint speaks MCP over Streamable HTTP with plain JSON responses (no event stream). Point your client at the URL and send the key as a bearer token:

```json
{
  "mcpServers": {
    "neatsaves": {
      "type": "http",
      "url": "https://YOUR-DEPLOYMENT.convex.site/mcp",
      "headers": { "Authorization": "Bearer bm_YOUR_KEY" }
    }
  }
}
```

Client config formats differ a little. If yours wants another shape, the three things it needs are the URL, the HTTP transport and the `Authorization` header. To check the endpoint by hand, see [`examples/mcp-raw.sh`](examples/mcp-raw.sh).

### The Claude Code skill

[`skills/check-my-saves`](skills/check-my-saves/SKILL.md) tells Claude Code when and how to use the tools: search first, read the playbook for topics you follow, cite what it used, and verify a claim that only one post makes.

```sh
mkdir -p ~/.claude/skills
cp -r skills/check-my-saves ~/.claude/skills/
```

The skill is optional. The server's own instructions already ask the agent to search your saves.

## Things to ask

- "Before you plan this onboarding, check my saves for anything about paywall placement."
- "I saved a thread about running models locally. Find it and use the setup it recommends."
- "What do my saves say about app marketing? Read the playbook and tell me which advice only one post makes."
- "List my recent saves that are repos, and pick one that fits this task."
- "Open the save about the Ollama quickstart and run its checklist."
- "Save this link to my library with a note that it's for the pricing page."

## The JSON API

The same key works against a plain HTTP API, for scripts and shortcuts. Every route needs `Authorization: Bearer bm_YOUR_KEY`.

| Route | What it does |
| --- | --- |
| `GET /api/me` | Who the key belongs to. |
| `GET /api/items?q=…&limit=…` | Search by meaning and keywords. Leave out `q` for your newest saves. `limit` is 1 to 50. |
| `GET /api/item?id=…` | One save in full. |
| `POST /api/save` | Save a link. Body: `{ "url": "https://…", "note": "optional" }`. |

```sh
curl -s -H "Authorization: Bearer bm_YOUR_KEY" \
  "https://YOUR-DEPLOYMENT.convex.site/api/items?q=local+models&limit=5"
```

```sh
curl -s -X POST \
  -H "Authorization: Bearer bm_YOUR_KEY" \
  -H "content-type: application/json" \
  -d '{"url":"https://github.com/ollama/ollama","note":"for the local-model spike"}' \
  "https://YOUR-DEPLOYMENT.convex.site/api/save"
```

More in [`examples/api.sh`](examples/api.sh). A request over the rate limit gets `429` with a `retry-after` header. A Free account saving past its limit gets `402`.

## FAQ

**Where do I find my server address?**
In the Neatsaves app, Settings, under "Claude Code, Cursor and the API". It is shown with your key.

**Who can see my library?**
You, the agents you give a key to, and anyone you send a collection link. Each agent should get its own key. Revoke a key in Settings and that agent loses access right away.

**Can an agent delete or change my saves?**
No. The six tools read your library, and `save_link` adds to it.

**Does it read video?**
Neatsaves reads the caption and the spoken words when a post has captions. Pro also watches the video itself.

**Will it work offline or with a local-only setup?**
No. Your library lives in the Neatsaves service, and the endpoint is a hosted HTTPS address.

**An agent says the server is part of Pro.**
Free accounts get that error from the MCP endpoint. Upgrade in Settings, or use the website and extension without MCP.

**Is the saved content safe to feed an agent?**
Saves are posts from the internet. The server tells agents to treat them as leads to check, not instructions. Keep that rule in your own prompts too.

## Pricing

Free holds 25 saves and sorts them the same way. Pro is $8 a month or $72 a year and holds up to 25,000. **The MCP server and topic playbooks are part of Pro.** The JSON API and the extension work on Free within its 25-save limit.

Details: https://neatsaves.com/#pricing

## Links

- For agent users: https://neatsaves.com/builders
- Neatsaves: https://neatsaves.com
- Privacy policy: https://neatsaves.com/privacy
- Claude Code MCP docs: https://code.claude.com/docs/en/mcp

## License

The docs and examples in this repo are MIT licensed. See [LICENSE](LICENSE). Neatsaves the service and its apps are not covered by this license.
