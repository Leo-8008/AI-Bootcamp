# AI-Bootcamp

Claude-Code-Workspace mit:
- **Confluence-Zugriff** über `confluence-cli` (Skill in `.claude/skills/confluence/`)
- **Sub-Agent `solution-design-assistant`** (`.claude/agents/solution-design-assistant.md`) für Problem-Clarification + One-Pager-Erstellung

## Projekt-Layout

```
AI-Bootcamp/
├── CLAUDE.md                                    # Diese Datei
├── .gitignore                                   # Schließt Secrets aus
├── confluence-cli.config.template.json          # Token-Vorlage
├── .claude/
│   ├── agents/
│   │   ├── solution-design-assistant.md         # Claude-Code Sub-Agent (EAM-Output)
│   │   └── problem-framing-coach.md             # Claude-Code Sub-Agent (Problem-Clarification, Lean/A3)
│   ├── skills/confluence/SKILL.md               # confluence-cli Skill-Doku
│   └── settings.local.json                      # Lokale Permissions (gitignored)
├── problem-statements/                          # Vom problem-framing-coach erzeugte One-Pager (committed)
└── scripts/
    └── setup-confluence.sh                      # One-Shot-Setup für confluence-cli
```

## Voraussetzungen

| Tool | Version | Zweck |
|---|---|---|
| Node.js | ≥ 18 | Für `confluence-cli` |
| Claude Code | aktuell | Hauptwerkzeug; lädt Skills aus `.claude/skills/` und Sub-Agents aus `.claude/agents/` |

## Erstmal-Einrichtung (für jeden Mitwirkenden)

### 1. Node.js installieren

Download: https://nodejs.org. Nach der Installation **Terminal/IDE neu starten**.

```bash
node --version    # sollte v18+ zeigen
npm --version
```

### 2. confluence-cli global installieren

```bash
npm install -g confluence-cli
```

### 3. Personal Access Token (PAT) in Confluence erstellen

1. https://confluence.zurich.com → Profilbild oben rechts → **Settings**
2. Links: **Personal Access Tokens** → **Create token**
3. Name (z. B. `claude-code`), Ablaufdatum wählen → **Create**
4. Token kopieren — wird nur einmal angezeigt

### 4. confluence-cli konfigurieren

Einfachster Weg — das mitgelieferte Setup-Skript:

```bash
bash scripts/setup-confluence.sh
```

Es fragt nach dem PAT, schreibt `~/.confluence-cli/config.json` und umgeht den Git-Bash-Pfadkonvertierungs-Bug. Alternativ manuell:

```bash
confluence init \
  --domain confluence.zurich.com \
  --api-path "//rest/api" \
  --auth-type bearer \
  --token "<DEIN_TOKEN>"
```

> **Wichtig (Git Bash auf Windows):** Der API-Path braucht den **doppelten Slash** (`//rest/api`), weil Git Bash sonst `/rest/api` in einen Windows-Pfad konvertiert. Anschließend in `~/.confluence-cli/config.json` manuell auf `/rest/api` korrigieren — oder einfach das Setup-Skript nutzen.

Die Konfiguration landet in `~/.confluence-cli/config.json` (außerhalb des Repos, persönlich).

### 5. Verifizieren

```bash
confluence read 78481720 --format markdown
```

Liefert die Seite *„1.5 Standards, Patterns, Decisions, Exception and Technical Debt"* aus dem ITEAC-Space.

## Nutzung

### Confluence-Befehle

Sobald die Konfiguration steht, kennt Claude den Skill `confluence` automatisch (geladen aus `.claude/skills/confluence/SKILL.md`). Verfügbar: `read`, `search`, `find`, `children`, `create`, `update`, `delete`, `move`, `attachments`, `convert` u. a. — vollständige Referenz in der `SKILL.md`.

### Sub-Agent `solution-design-assistant`

Spezialisierter Agent für **Zurich EAM-Aufgaben**: Architecture Decisions, Standards, Exceptions, EA Principles, Software-/Tool-Evaluations, Solution Blueprints und allgemeine One-Pager.

Du kannst ihn direkt aufrufen, z. B.:

> *„Nutze den `solution-design-assistant`: Ich brauche eine Architecture Decision für die Migration der Auth-Middleware."*

Der Agent zieht automatisch das passende Confluence-Template + die Begriffsdefinitionen aus dem ITEAC-Space und stellt klärende Fragen, bevor er das Output produziert.

**Hinterlegte Confluence-Templates (ITEAC-Space):**

| Aufgabe | Template-Page-ID |
|---|---|
| Architecture Decision (ADR) | `378448646` |
| EA Standard | `134849433` |
| Exception (Standard-Abweichung) | `369698720` |
| EA Principle | `264221812` |
| Software-Evaluation | `395517931` |
| Tool-Evaluation | `331163651` |
| Solution Blueprint (Arc42) | `729905979` |
| **Begriffsdefinitionen** (immer geladen) | `78481720` |
| EA-Standard Definition Process | `357834693` |
| Templates-Übersicht (Fallback) | `434382050` |

Bei neuen Templates → Page-ID in `.claude/agents/solution-design-assistant.md` ergänzen.

## Sub-Agent `problem-framing-coach`

Coaches users through formulating a sharp problem statement *before* any solution work — Lean / A3 inspired. Pushes back on premature solutions, surfaces assumptions, writes a Problem One-Pager to `problem-statements/<date>-<slug>.md` (locally) and optionally to a configured shared SharePoint-synced folder.

**Invoke explicitly, e.g.:**
> "Use the `problem-framing-coach`: I think we need to replace our auth middleware."

The coach will redirect from solution-talk to problem-talk and produce a one-pager that `solution-design-assistant` can consume downstream.

**Modes:** `warn` (default, flags red flags but proceeds) or `block` (refuses to advance until red flags are resolved). Set via frontmatter `enforcement_mode` or via chat command (*"switch to block mode"*).

**Output paths:** configured in the agent's frontmatter (`output_paths.project` and `output_paths.shared`). The shared path is per-user (typically a OneDrive-synced SharePoint folder) and should NOT be committed with a real user-specific path — leave a placeholder in the committed file.

**Classification:** All files include `_Classification: Internal Use Only_` in their header.

## Sicherheitshinweise

- **Token niemals committen.** `.gitignore` schließt `.env*`, `.confluence-cli/` und `.claude/settings.local.json` aus.
- **Token rotieren**, falls er versehentlich geteilt wurde (Confluence → Profil → Personal Access Tokens → Token revoken und neu erstellen).
- `.claude/settings.local.json` ist bewusst lokal — sie kann projekt-spezifische Permissions enthalten, die ein anderer Nutzer nicht braucht.

## Bekannte Stolperfallen

| Problem | Ursache | Lösung |
|---|---|---|
| `confluence: command not found` | npm-global-bin nicht im `PATH` | Terminal neu starten oder `PATH` ergänzen: `export PATH="$APPDATA/npm:$PATH"` (Windows) |
| `❌ Confluence API path must start with "/"` | Git Bash konvertiert `/rest/api` in Windows-Pfad | Doppelten Slash `//rest/api` verwenden, dann in Config korrigieren — oder `setup-confluence.sh` nutzen |
| `401 Unauthorized` | Token abgelaufen oder falsch | Neuen PAT erstellen, `setup-confluence.sh` erneut ausführen |
