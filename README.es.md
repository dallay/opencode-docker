<div align="center">

# 🤖 opencode-docker

**Imagen Docker personalizada para [opencode](https://github.com/anomalyco/opencode) — preconfigurada
con skills, slash commands, servidores MCP y un agente de coding completamente listo para usar.**

[![Docker Pulls](https://img.shields.io/docker/pulls/yacosta738/opencode?style=flat-square&logo=docker)](https://hub.docker.com/r/yacosta738/opencode)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-dallay%2Fopencode-blue?style=flat-square&logo=github)](https://ghcr.io/dallay/opencode)
[![Release](https://img.shields.io/github/v/release/dallay/opencode-docker?style=flat-square)](https://github.com/dallay/opencode-docker/releases)
[![License](https://img.shields.io/github/license/dallay/opencode-docker?style=flat-square)](LICENSE)

[English](./README.md) · [Español](./README.es.md)

</div>

---

## ¿Qué es esto?

[opencode](https://github.com/anomalyco/opencode) es un asistente de código con IA que corre en
la terminal. Esta imagen trae una **configuración lista y opinionada** encima de él:

- 🧠 **AGENTS.md** — system prompt personalizado con la persona arquitecta Kerrigan
- ⚡ **Skills** — más de 40 packs de instrucciones especializadas (SDD, Cloudflare, Angular, React, Docker y más)
- 🔧 **Slash commands** — comandos `/sdd-*` del workflow SDD preconfigurados
- 🔌 **Servidores MCP** — Context7, GitHub Copilot, Playwright, Chrome DevTools, gh_grep y más
- 🔒 **Non-root** — corre como usuario `opencode` (uid 1001)
- 🏗️ **Multi-arch** — `linux/amd64` y `linux/arm64`

---

## Inicio rápido

```bash
docker run --rm -it \
  -v "$(pwd)":/workspace \
  -e GITHUB_TOKEN=tu_token \
  -e CONTEXT7_API_KEY=tu_key \
  yacosta738/opencode:latest
```

Monta tu directorio actual como workspace y te lleva directo al TUI de opencode.

---

## Imágenes disponibles

| Registry | Imagen |
|---|---|
| Docker Hub | `yacosta738/opencode:latest` |
| GHCR | `ghcr.io/dallay/opencode:latest` |

### Tags

| Tag | Descripción |
|---|---|
| `latest` | Última versión estable |
| `1.0.0` | Versión específica |
| `v1` | Alias de versión mayor |
| `<git-sha>` | Build de commit exacto |

---

## Configuración

### Variables de entorno

Todas las API keys y tokens se inyectan en tiempo de ejecución — **nada está dentro de la imagen**.

| Variable | Requerida | Descripción |
|---|---|---|
| `GITHUB_TOKEN` | Recomendada | MCP de GitHub Copilot + autenticación de gh CLI |
| `CONTEXT7_API_KEY` | Opcional | MCP de documentación Context7 |
| `STITCH_API_KEY` | Opcional | MCP de Google Stitch |
| `SONARQUBE_TOKEN` | Opcional | MCP de SonarQube |
| `SONARQUBE_ORG` | Opcional | Organización de SonarQube |

Copia `.env.example` a `.env` y completa tus valores:

```bash
cp .env.example .env
# edita .env con tus claves
```

Luego ejecuta con `--env-file`:

```bash
docker run --rm -it \
  -v "$(pwd)":/workspace \
  --env-file .env \
  yacosta738/opencode:latest
```

### Montar el workspace

El contenedor usa `/workspace` como directorio de trabajo. Monta tu proyecto ahí:

```bash
# Directorio actual
-v "$(pwd)":/workspace

# Proyecto específico
-v /ruta/a/mi-proyecto:/workspace

# Directorio home (todos los proyectos)
-v "$HOME/Dev":/workspace
```

### Sesiones persistentes

opencode guarda el historial de sesiones en `/home/opencode/.local/share/opencode`.
Monta un volumen para persistir las sesiones entre ejecuciones:

```bash
docker run --rm -it \
  -v "$(pwd)":/workspace \
  -v opencode-sessions:/home/opencode/.local/share/opencode \
  --env-file .env \
  yacosta738/opencode:latest
```

---

## Skills incluidas

Las skills son packs de instrucciones especializadas que extienden las capacidades del agente.
Viven en `/home/opencode/.config/opencode/skills/`.

<details>
<summary>Ver las 40+ skills</summary>

| Categoría | Skills |
|---|---|
| **IA / Agentes** | `agents-sdk`, `building-ai-agent-on-cloudflare`, `building-mcp-server-on-cloudflare` |
| **Arquitectura** | `brainstorming`, `best-practices`, `frontend-design` |
| **Cloudflare** | `cloudflare`, `workers-best-practices`, `wrangler`, `durable-objects` |
| **CI/CD** | `github-actions`, `gh-fix-ci`, `gh-address-comments`, `github`, `pinned-tag`, `yeet`, `pr-creator` |
| **Workflow SDD** | `sdd-init`, `sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive` |
| **Observabilidad** | `sentry`, `grafana-dashboards` |
| **Web** | `accessibility`, `seo`, `performance`, `core-web-vitals`, `web-quality-audit`, `webapp-testing` |
| **Bases de datos** | `sql-optimization-patterns` |
| **Integraciones** | `linear`, `notion-knowledge-capture`, `notion-meeting-intelligence`, `notion-research-documentation`, `notion-spec-to-implementation` |
| **Obsidian** | `obsidian-cli`, `obsidian-markdown`, `obsidian-bases`, `json-canvas`, `defuddle` |
| **Tooling** | `docker-expert`, `makefile`, `markdown-a11y`, `skill-creator`, `jules-cli` |

</details>

---

## Servidores MCP incluidos

Los servidores MCP (Model Context Protocol) extienden el agente con herramientas en tiempo real.

| Servidor | Estado | Descripción |
|---|---|---|
| `context7` | ✅ Activo | Búsqueda de documentación de librerías actualizada |
| `gh_grep` | ✅ Activo | Búsqueda de patrones en código público de GitHub |
| `chrome-devtools` | ✅ Activo | Automatización de Chrome DevTools |
| `playwright` | ✅ Activo | Testing de navegador end-to-end |
| `github` | ⚙️ Opcional | Integración con GitHub Copilot (requiere `GITHUB_TOKEN`) |
| `linear` | ⚙️ Opcional | Gestión de proyectos en Linear |
| `notion` | ⚙️ Opcional | Integración con Notion |
| `sonarqube` | ⚙️ Opcional | Análisis de calidad de código |
| `stitch` | ⚙️ Opcional | Google Stitch |
| `cloudflare-api` | ⚙️ Opcional | API del dashboard de Cloudflare |

---

## Slash Commands

Los comandos `/sdd-*` preconfigurados implementan un workflow completo de **Spec-Driven Development**:

| Comando | Descripción |
|---|---|
| `/sdd-init` | Inicializa el contexto SDD en un proyecto |
| `/sdd-new` | Explora y propone un nuevo cambio |
| `/sdd-ff` | Fast-forward: propuesta → spec → diseño → tareas |
| `/sdd-continue` | Retoma desde la última fase completada |
| `/sdd-apply` | Implementa las tareas |
| `/sdd-verify` | Valida la implementación contra las specs |
| `/sdd-archive` | Sincroniza specs y cierra el ciclo |

---

## Build local

```bash
git clone https://github.com/dallay/opencode-docker.git
cd opencode-docker

docker build \
  --build-arg OPENCODE_VERSION=1.4.3 \
  -t opencode:local \
  .
```

Para usar una versión diferente de opencode:

```bash
docker build \
  --build-arg OPENCODE_VERSION=1.5.0 \
  -t opencode:custom \
  .
```

---

## Arquitectura

```
Dockerfile (multi-stage)
├── Stage 1: downloader  — debian:bookworm-slim
│   └── Descarga el binario de opencode desde GitHub releases
│       (detección de arch: x64 para amd64, arm64 para arm64)
└── Stage 2: runtime     — debian:bookworm-slim
    ├── Dependencias runtime: git, curl, nodejs, npm, ca-certificates
    ├── Usuario non-root: opencode (uid 1001)
    ├── Binario: /usr/local/bin/opencode
    ├── Config: /home/opencode/.config/opencode/
    └── Workdir: /workspace
```

---

## Versionado

Este repo usa [Semantic Release](https://github.com/semantic-release/semantic-release) con
[Conventional Commits](https://www.conventionalcommits.org/):

| Prefijo de commit | Bump de versión |
|---|---|
| `fix:` | Patch — `1.0.x` |
| `feat:` | Minor — `1.x.0` |
| `feat!:` o `BREAKING CHANGE` | Major — `x.0.0` |

Cada push a `main` con commits releaseables automáticamente:
1. Incrementa la versión y crea un GitHub Release
2. Construye y publica la imagen multi-arch en Docker Hub y GHCR
3. Ejecuta un escaneo de seguridad con Trivy y sube los resultados al tab de Security de GitHub

---

## Seguridad

- Todas las API keys se inyectan via variables de entorno — **nunca dentro de la imagen**
- El contenedor corre como usuario non-root `opencode` (uid 1001)
- Cada release se escanea con [Trivy](https://github.com/aquasecurity/trivy) en busca de CVEs HIGH y CRITICAL
- Los resultados son visibles en el [tab de Security de GitHub](https://github.com/dallay/opencode-docker/security)

---

## Contribuir

1. Haz un fork del repo
2. Aplica tus cambios usando conventional commits
3. Abre un PR — el CI validará el build

---

## Licencia

MIT — ver [LICENSE](LICENSE)

---

<div align="center">

Hecho con ❤️ por [Yuniel Acosta](https://github.com/yacosta738)

</div>
