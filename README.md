<div align="center">

# 🤖 opencode-docker

**A custom Docker image for [opencode](https://github.com/anomalyco/opencode) — pre-loaded with
skills, slash commands, MCP servers, and a fully configured AI coding agent.**

[![Docker Pulls](https://img.shields.io/docker/pulls/yacosta738/opencode?style=flat-square&logo=docker)](https://hub.docker.com/r/yacosta738/opencode)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-dallay%2Fopencode-blue?style=flat-square&logo=github)](https://ghcr.io/dallay/opencode)
[![Release](https://img.shields.io/github/v/release/dallay/opencode-docker?style=flat-square)](https://github.com/dallay/opencode-docker/releases)
[![License](https://img.shields.io/github/license/dallay/opencode-docker?style=flat-square)](LICENSE)

[English](./README.md) · [Español](./README.es.md)

</div>

---

## What is this?

[opencode](https://github.com/anomalyco/opencode) is a terminal-based AI coding assistant.
This image ships a **ready-to-use, opinionated configuration** on top of it:

- 🧠 **AGENTS.md** — custom system prompt with Kerrigan architect persona
- ⚡ **Skills** — 40+ domain-specific skill packs (SDD, Cloudflare, Angular, React, Docker, and more)
- 🔧 **Slash commands** — pre-wired `/sdd-*` workflow commands
- 🔌 **MCP servers** — Context7, GitHub Copilot, Playwright, Chrome DevTools, gh_grep, and more
- 🔒 **Non-root** — runs as `opencode` user (uid 1001)
- 🏗️ **Multi-arch** — `linux/amd64` and `linux/arm64`

---

## Quick Start

```bash
docker run --rm -it \
  -v "$(pwd)":/workspace \
  -e GITHUB_TOKEN=your_token \
  -e CONTEXT7_API_KEY=your_key \
  yacosta738/opencode:latest
```

That mounts your current directory as the workspace and drops you straight into the opencode TUI.

---

## Available Images

| Registry | Image |
|---|---|
| Docker Hub | `yacosta738/opencode:latest` |
| GHCR | `ghcr.io/dallay/opencode:latest` |

### Tags

| Tag | Description |
|---|---|
| `latest` | Latest stable release |
| `1.0.0` | Specific version |
| `v1` | Major version alias |
| `<git-sha>` | Exact commit build |

---

## Configuration

### Environment Variables

All API keys and tokens are injected at runtime — **nothing is baked into the image**.

| Variable | Required | Description |
|---|---|---|
| `GITHUB_TOKEN` | Recommended | GitHub Copilot MCP + gh CLI auth |
| `CONTEXT7_API_KEY` | Optional | Context7 documentation MCP |
| `STITCH_API_KEY` | Optional | Google Stitch MCP |
| `SONARQUBE_TOKEN` | Optional | SonarQube MCP |
| `SONARQUBE_ORG` | Optional | SonarQube organization |

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
# edit .env with your keys
```

Then run with `--env-file`:

```bash
docker run --rm -it \
  -v "$(pwd)":/workspace \
  --env-file .env \
  yacosta738/opencode:latest
```

### Workspace Mount

The container uses `/workspace` as the working directory. Mount your project there:

```bash
# Current directory
-v "$(pwd)":/workspace

# Specific project
-v /path/to/my-project:/workspace

# Home directory (all projects)
-v "$HOME/Dev":/workspace
```

### Persistent Sessions

opencode stores session history at `/home/opencode/.local/share/opencode`.
Mount a volume to persist sessions across container runs:

```bash
docker run --rm -it \
  -v "$(pwd)":/workspace \
  -v opencode-sessions:/home/opencode/.local/share/opencode \
  --env-file .env \
  yacosta738/opencode:latest
```

---

## Included Skills

Skills are domain-specific instruction packs that extend the agent's capabilities.
They live in `/home/opencode/.config/opencode/skills/`.

<details>
<summary>View all 40+ skills</summary>

| Category | Skills |
|---|---|
| **AI / Agents** | `agents-sdk`, `building-ai-agent-on-cloudflare`, `building-mcp-server-on-cloudflare` |
| **Architecture** | `brainstorming`, `best-practices`, `frontend-design` |
| **Cloudflare** | `cloudflare`, `workers-best-practices`, `wrangler`, `durable-objects` |
| **CI/CD** | `github-actions`, `gh-fix-ci`, `gh-address-comments`, `github`, `pinned-tag`, `yeet`, `pr-creator` |
| **SDD Workflow** | `sdd-init`, `sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive` |
| **Observability** | `sentry`, `grafana-dashboards` |
| **Web** | `accessibility`, `seo`, `performance`, `core-web-vitals`, `web-quality-audit`, `webapp-testing` |
| **Databases** | `sql-optimization-patterns` |
| **Integrations** | `linear`, `notion-knowledge-capture`, `notion-meeting-intelligence`, `notion-research-documentation`, `notion-spec-to-implementation` |
| **Obsidian** | `obsidian-cli`, `obsidian-markdown`, `obsidian-bases`, `json-canvas`, `defuddle` |
| **Tooling** | `docker-expert`, `makefile`, `markdown-a11y`, `skill-creator`, `jules-cli` |

</details>

---

## Included MCP Servers

MCP (Model Context Protocol) servers extend the agent with real-time tools.

| Server | Status | Description |
|---|---|---|
| `context7` | ✅ Enabled | Up-to-date library documentation lookup |
| `gh_grep` | ✅ Enabled | Search public GitHub code patterns |
| `chrome-devtools` | ✅ Enabled | Browser DevTools automation |
| `playwright` | ✅ Enabled | End-to-end browser testing |
| `github` | ⚙️ Optional | GitHub Copilot integration (needs `GITHUB_TOKEN`) |
| `linear` | ⚙️ Optional | Linear project management |
| `notion` | ⚙️ Optional | Notion workspace integration |
| `sonarqube` | ⚙️ Optional | Code quality analysis |
| `stitch` | ⚙️ Optional | Google Stitch |
| `cloudflare-api` | ⚙️ Optional | Cloudflare dashboard API |

---

## Slash Commands

Pre-wired `/sdd-*` commands implement a full **Spec-Driven Development** workflow:

| Command | Description |
|---|---|
| `/sdd-init` | Bootstrap SDD context in a project |
| `/sdd-new` | Explore + propose a new change |
| `/sdd-ff` | Fast-forward: propose → spec → design → tasks |
| `/sdd-continue` | Resume from last completed phase |
| `/sdd-apply` | Implement tasks |
| `/sdd-verify` | Validate implementation against specs |
| `/sdd-archive` | Sync specs and close the cycle |

---

## Building Locally

```bash
git clone https://github.com/dallay/opencode-docker.git
cd opencode-docker

docker build \
  --build-arg OPENCODE_VERSION=1.4.3 \
  -t opencode:local \
  .
```

Override the opencode version:

```bash
docker build \
  --build-arg OPENCODE_VERSION=1.5.0 \
  -t opencode:custom \
  .
```

---

## Architecture

```
Dockerfile (multi-stage)
├── Stage 1: downloader  — debian:bookworm-slim
│   └── Downloads opencode binary from GitHub releases
│       (arch-aware: x64 for amd64, arm64 for arm64)
└── Stage 2: runtime     — debian:bookworm-slim
    ├── Runtime deps: git, curl, nodejs, npm, ca-certificates
    ├── Non-root user: opencode (uid 1001)
    ├── Binary: /usr/local/bin/opencode
    ├── Config: /home/opencode/.config/opencode/
    └── Workdir: /workspace
```

---

## Versioning

This repo uses [Semantic Release](https://github.com/semantic-release/semantic-release) with
[Conventional Commits](https://www.conventionalcommits.org/):

| Commit prefix | Version bump |
|---|---|
| `fix:` | Patch — `1.0.x` |
| `feat:` | Minor — `1.x.0` |
| `feat!:` or `BREAKING CHANGE` | Major — `x.0.0` |

Every push to `main` that contains releasable commits will automatically:
1. Bump the version and create a GitHub Release
2. Build and push the multi-arch Docker image to Docker Hub and GHCR
3. Run a Trivy security scan and upload results to GitHub Security tab

---

## Security

- All API keys are injected via environment variables — **never baked in**
- Container runs as non-root user `opencode` (uid 1001)
- Every release is scanned with [Trivy](https://github.com/aquasecurity/trivy) for HIGH and CRITICAL CVEs
- Results are visible in the [GitHub Security tab](https://github.com/dallay/opencode-docker/security)

---

## Contributing

1. Fork the repo
2. Make your changes using conventional commits
3. Open a PR — CI will validate the build

---

## License

MIT — see [LICENSE](LICENSE)

---

<div align="center">

Built with ❤️ by [Yuniel Acosta](https://github.com/yacosta738)

</div>
