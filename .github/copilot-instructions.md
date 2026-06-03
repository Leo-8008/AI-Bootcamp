# AI-Bootcamp — GitHub Copilot Instructions

This workspace connects GitHub Copilot CLI to Zurich's internal Confluence (ITEAC space) to produce Enterprise Architecture Management (EAM) artifacts — Architecture Decisions, Standards, Exceptions, EA Principles, Software/Tool Evaluations, and Solution Blueprints.

Three custom agents support the workflow:
1. **`problem-framing-coach`** — clarify the problem *before* any solution work (Lean / A3 style)
2. **`solution-design-assistant`** — Claude-first variant; fetches Confluence pages itself when shell is available
3. **`solution-design-assistant-copilot`** — Copilot-first variant; expects Confluence pages to be pre-fetched by the parent Copilot session

---

## Project layout

```
AI-Bootcamp/
├── .github/
│   └── copilot-instructions.md          # This file — Copilot CLI project instructions
├── CLAUDE.md                            # Equivalent instructions for Claude Code
├── .gitignore                           # Excludes secrets
├── confluence-cli.config.template.json  # Token template (never commit a real token)
├── .claude/
│   ├── agents/
│   │   ├── solution-design-assistant.md         # Claude-first EAM agent (direct Confluence fetch)
│   │   ├── solution-design-assistant-copilot.md # Copilot-first EAM agent (pre-fetched Confluence content)
│   │   └── problem-framing-coach.md             # Custom agent — Problem clarification
│   └── skills/confluence/SKILL.md       # confluence-cli skill definition
├── problem-statements/                  # One-pagers produced by problem-framing-coach
└── scripts/
    ├── setup-confluence.sh              # One-shot confluence-cli setup script
    └── fetch-eam-context.ps1            # Copilot helper: route intent → fetch Confluence context
```

---

## Prerequisites

| Tool | Version | Purpose |
|---|---|---|
| Node.js | ≥ 18 | Required by `confluence-cli` |
| GitHub Copilot CLI | current | Main assistant; loads skills from `.claude/skills/` and agents from `.claude/agents/` |

---

## First-time setup

### 1. Install Node.js

Download from https://nodejs.org. After installing, **restart your terminal / IDE**.

```powershell
node --version   # should show v18+
npm --version
```

### 2. Install confluence-cli globally

```powershell
npm install -g confluence-cli
```

### 3. Create a Personal Access Token in Confluence

1. Go to https://confluence.zurich.com → profile picture (top right) → **Settings**
2. Left sidebar: **Personal Access Tokens** → **Create token**
3. Choose a name (e.g. `copilot-cli`) and an expiry date → **Create**
4. Copy the token — it is shown only once

### 4. Configure confluence-cli

The easiest way is the included setup script:

```bash
bash scripts/setup-confluence.sh
```

It will prompt for your PAT, write `~/.confluence-cli/config.json`, and work around the Git Bash path conversion bug automatically.

Manual alternative:

```bash
confluence init \
  --domain confluence.zurich.com \
  --api-path "//rest/api" \
  --auth-type bearer \
  --token "<YOUR_TOKEN>"
```

> **Git Bash on Windows:** Use the double-slash `//rest/api` during init (Git Bash otherwise rewrites `/rest/api` to a Windows path). The setup script corrects it back to `/rest/api` in the saved config automatically.

Config is saved to `~/.confluence-cli/config.json` — outside the repo, personal to you.

### 5. Verify

```bash
confluence read 78481720 --format markdown
```

Should return the page *"1.5 Standards, Patterns, Decisions, Exception and Technical Debt"* from the ITEAC space.

---

## Using the confluence skill

The `confluence` skill is loaded automatically from `.claude/skills/confluence/SKILL.md`. Copilot CLI can invoke it directly:

```
/skill confluence read 78481720
```

Or in natural language — Copilot will invoke the skill when a Confluence task is detected.

**Available operations:** `read`, `search`, `find`, `children`, `create`, `update`, `delete`, `move`, `attachments`, `convert` — full reference in `.claude/skills/confluence/SKILL.md`.

**Recommended invocation** (works on any platform, including Git Bash on Windows where the npm `confluence` shim is broken — it resolves `basedir` against the Git install root and crashes):

```powershell
node "$(npm root -g)/confluence-cli/bin/confluence.js" read <pageId> --format markdown
```

If `confluence` is on `PATH` and works in your shell (typically PowerShell or cmd, not Git Bash), the shorter form is also fine:

```powershell
$env:PATH = "$env:APPDATA\npm;$env:PATH"
confluence read <pageId> --format markdown
```

---

## Custom agents

All agents are loaded automatically from `.claude/agents/` and available to Copilot CLI as custom agents. Invoke them explicitly to get the intended behaviour.

### `problem-framing-coach`

Coaches you through formulating a sharp problem statement *before* any solution work — Lean / A3 / Toyota Kata style. Pushes back on premature solutions, surfaces hidden assumptions, and produces a Problem One-Pager.

**Invoke with:**
> *"Use the `problem-framing-coach`: I think we need to replace our auth middleware."*

The coach asks clarifying questions one at a time and writes a one-pager to:
- `problem-statements/<YYYY-MM-DD>-<slug>.md` (always, in this repo)
- A shared SharePoint-synced folder if configured in the agent frontmatter

**Modes:** `warn` (default — flags red flags but proceeds) or `block` (refuses to advance until red flags are resolved). Switch at any time: *"switch to block mode"*.

**Output is classified:** all files include `_Classification: Internal Use Only_`.

The one-pager produced here is the authoritative input for `solution-design-assistant` downstream.

---

### `solution-design-assistant-copilot`

Produces decision-ready EAM artifacts using Zurich's official Confluence templates. Use this variant in GitHub Copilot CLI.

> **Why a separate Copilot agent?** Copilot CLI sub-agents do not have shell access, so this agent is designed to work from pre-fetched Confluence content only.

**Invoke with:**

> *"Fetch Confluence pages 78481720 and 378448646 and then use the `solution-design-assistant-copilot` to create an Architecture Decision for [your topic]."*

Copilot CLI reads the pages with `powershell` in the main session and passes the content inline to the agent. The agent then works entirely from the provided text.

If the problem is vague or no Problem One-Pager exists, the agent will recommend running `problem-framing-coach` first.

## Natural prompt routing in Copilot CLI

For normal user prompts, Copilot CLI should hide the page-ID lookup and do the routing itself.

### Step 1 — decide whether this is problem framing or solution design

- If the user describes a **vague problem, pain point, or solution idea without a clear artifact type**, use `problem-framing-coach` first.
- If the user clearly wants an **ADR, Standard, Exception, Principle, evaluation, or Blueprint**, fetch EAM context first and then invoke `solution-design-assistant-copilot`.

### Step 2 — fetch EAM context automatically

Use the helper script below from the main Copilot session:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\fetch-eam-context.ps1 -IntentText "<user request>"
```

Why this script exists:
- infers the likely EAM task type from natural language
- always includes page `78481720` (EAM vocabulary)
- fetches the matching template page(s)
- avoids the Windows Git Bash shim issue by invoking `confluence-cli` through `node`
- emits a single prompt-ready Markdown bundle for `solution-design-assistant-copilot`

### Step 3 — handle ambiguous routing

- If the helper returns `taskType=adr-or-standard`, ask one clarifying question or let `solution-design-assistant-copilot` ask it.
- If the helper returns `taskType=unknown`, ask one clarifying question about the intended artifact type before invoking the agent.

### Step 4 — invoke the Copilot-specific agent

Pass the helper output inline to `solution-design-assistant-copilot`.

**Recommended natural-language pattern:**

> *"Interpret my request, fetch the needed EAM Confluence context automatically, and then use `solution-design-assistant-copilot` to help me. My request is: We should standardize our frontend framework across products."*

**More explicit pattern:**

> *"Run `powershell -ExecutionPolicy Bypass -File .\\scripts\\fetch-eam-context.ps1 -IntentText \"We should standardize our frontend framework across products\"` and pass the result to `solution-design-assistant-copilot`."*

### `solution-design-assistant`

Produces the same kind of output, but is better suited to Claude Code because that runtime can give the sub-agent shell access.

**Claude Code — direct invocation:**
> *"Use the `solution-design-assistant`: I need an Architecture Decision for migrating the auth middleware."*

**Confluence templates used (ITEAC space):**

| Task type | Template page ID |
|---|---|
| Architecture Decision (ADR) | `378448646` |
| EA Standard | `134849433` |
| Exception (deviation from a standard) | `369698720` |
| EA Principle | `264221812` |
| Software evaluation | `395517931` |
| Tool evaluation | `331163651` |
| Solution Blueprint (Arc42) | `729905979` |
| **EAM vocabulary** (always loaded) | `78481720` |
| EA Standard Definition Process | `357834693` |
| Templates overview (fallback) | `434382050` |

To add a new template: add its page ID to both solution-design-assistant agent files if both runtimes should support it.

---

## Recommended workflow

```
User has a vague idea
        ↓
problem-framing-coach   →  problem-statements/<date>-<slug>.md
        ↓
solution-design-assistant-copilot  (Copilot CLI; uses pre-fetched Confluence pages)
        ↓
EAM artifact (ADR / Standard / Exception / Blueprint / …)

Claude Code alternative:
problem-framing-coach   →  problem-statements/<date>-<slug>.md
        ↓
solution-design-assistant  (Claude Code; fetches Confluence directly)
        ↓
EAM artifact (ADR / Standard / Exception / Blueprint / …)
```

---

## Cross-platform tool names

Agent definition files live in `.claude/agents/` because that is where the project currently keeps custom agent specs for both runtimes. `.github/` is for Copilot instructions, not where this project wires agent definitions.

Agent definition files (`.claude/agents/`) use Claude Code tool names in their frontmatter (`tools: Bash, Read, Write, ...`). GitHub Copilot CLI uses different names for the same capabilities. The agent body text uses neutral verbs ("run a shell command", "read the file") so both runtimes understand it correctly where behavior is shared.

Quick mapping reference:

| Action | Claude Code | Copilot CLI |
|---|---|---|
| Shell command | `Bash` | `powershell` |
| Read file | `Read` | `view` |
| Create file | `Write` | `create` |
| Edit file | `Edit` | `edit` |
| Fetch URL | `WebFetch` | `web_fetch` |

**Do not add Copilot CLI tool names to the `tools:` frontmatter** — it may break Claude Code's tool gating.

---

## Personal configuration (`.env.local`)

The `problem-framing-coach` reads `.env.local` at startup to get your personal shared folder path — no user-specific path is ever committed to the repo.

```powershell
Copy-Item .env.local.template .env.local
# Open .env.local and set PROBLEM_STATEMENTS_SHARED_PATH
```

Example:
```
PROBLEM_STATEMENTS_SHARED_PATH=C:\Users\YOUR.NAME\Zurich Insurance\CrEAM - Dokumente\01 Architecture Governance\AI Bootcamp project\Problem Statements
```

If the variable is empty or the path is unreachable, the agent saves locally to `problem-statements/` only and warns you.

---

## Security

- **Never commit a token.** `.gitignore` excludes `.env*`, `.confluence-cli/`, and `.claude/settings.local.json`.
- **Rotate the token** if it was accidentally shared: Confluence → Profile → Personal Access Tokens → revoke and recreate.
- The config template at `confluence-cli.config.template.json` contains only a placeholder — it is safe to commit.

---

## Known issues

| Problem | Cause | Fix |
|---|---|---|
| `confluence: command not found` | npm global bin not on `PATH` | Restart terminal, or prepend: `$env:PATH = "$env:APPDATA\npm;$env:PATH"` |
| `❌ Confluence API path must start with "/"` | Git Bash converts `/rest/api` to a Windows path | Use `//rest/api` during init, then fix in config — or use `setup-confluence.sh` |
| `401 Unauthorized` | Token expired or wrong | Create a new PAT, re-run `setup-confluence.sh` |
