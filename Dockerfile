# ============================================================
# Stage 1: Download opencode binary
# ============================================================
FROM debian:bookworm-slim AS downloader

ARG OPENCODE_VERSION=1.4.3
ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Map Docker TARGETARCH to opencode release arch naming
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64) OC_ARCH="x64" ;; \
      arm64) OC_ARCH="arm64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac; \
    curl -fsSL \
      "https://github.com/anomalyco/opencode/releases/download/v${OPENCODE_VERSION}/opencode-linux-${OC_ARCH}.tar.gz" \
      -o /tmp/opencode.tar.gz; \
    tar -xzf /tmp/opencode.tar.gz -C /tmp; \
    chmod 755 /tmp/opencode

# ============================================================
# Stage 2: Runtime image
# ============================================================
FROM debian:bookworm-slim AS runtime

# Install runtime deps: git (many agents need it), curl, ca-certs, nodejs (for MCP npx tools)
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      nodejs \
      npm \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -g 1001 opencode \
    && useradd -u 1001 -g opencode -m -s /bin/bash opencode

# Copy binary from downloader stage
COPY --from=downloader --chown=opencode:opencode /tmp/opencode /usr/local/bin/opencode

# Copy opencode config (skills, commands, AGENTS.md, tui.json, opencode.json)
COPY --chown=opencode:opencode config/ /home/opencode/.config/opencode/

# /workspace is where the user mounts their project
# /home/opencode/.local/share/opencode is where opencode stores sessions
RUN mkdir -p /workspace \
    && mkdir -p /home/opencode/.local/share/opencode \
    && chown opencode:opencode /workspace \
    && chown -R opencode:opencode /home/opencode

USER opencode
WORKDIR /workspace

ENTRYPOINT ["opencode"]
