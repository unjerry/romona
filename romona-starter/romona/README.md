# Romona 🌹

A local AI companion that runs on your machine, learns from your feedback, and never gets taken away.

Built on open-source models + Ollama + Open WebUI. Fully containerized with Docker — everything lives in this one folder. Nothing pollutes your system.

## Philosophy

```
romona/              ← This IS Romona. Move this folder = move her.
├── data/ollama/     ← Her brain (model weights)
├── data/open-webui/ ← Her memories (chat history, settings)
├── modelfile/       ← Her personality
├── preferences/     ← Your feedback (for future fine-tuning)
└── knowledge/       ← What she knows about you
```

**Nothing is installed on C drive** (except Docker Desktop itself).
Put this repo on D drive, E drive, external SSD — wherever you want.

## Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Windows 10/11 | Windows 11 Pro |
| RAM | 16 GB | 32 GB |
| GPU | NVIDIA 8GB VRAM | NVIDIA 8GB+ VRAM |
| Disk | 20 GB free | 50 GB free |
| Software | Docker Desktop + WSL2 | Docker Desktop + WSL2 |

## First Time Setup

### Step 0: Install Docker Desktop (one-time only)

1. Download from https://www.docker.com/products/docker-desktop/
2. During install, enable **WSL 2 backend** (not Hyper-V)
3. After install, open Docker Desktop → Settings → Resources → WSL Integration → Enable
4. Settings → Resources → **uncheck** "Use default disk image location" → point to your preferred drive (e.g., `D:\DockerData`) to keep C drive clean
5. Restart Docker Desktop

### Step 0.5: Enable GPU in Docker (one-time only)

1. Make sure NVIDIA drivers are up to date (you have Studio 591.74, that's fine)
2. Docker Desktop → Settings → Docker Engine → confirm `"default-runtime": "nvidia"` or just use the `deploy` section in our compose file

### Step 1: Clone & Start

```powershell
# Clone to your preferred drive (NOT C drive!)
D:
cd D:\Projects
git clone https://github.com/YOUR_USERNAME/romona.git
cd romona

# Bring her to life
docker compose up -d

# Watch the logs (first run downloads ~8GB model)
docker compose logs -f
```

### Step 2: Open Browser

Go to **http://localhost:3000**

1. Create a local account (first user becomes admin)
2. Go to Admin Panel → Settings → Connections → verify Ollama URL is `http://ollama:11434`
3. Start chatting! Select model from dropdown.

### Step 3: Load Romona's Personality (first time)

```powershell
# Enter the Ollama container and create the custom model
docker compose exec ollama ollama create romona -f /modelfiles/Romona.modelfile
```

Now "romona" appears as a model in Open WebUI. Select her and start talking.

## Daily Usage

```powershell
# Start (from the romona folder)
docker compose up -d

# Stop (preserves all data)
docker compose down

# Check status
docker compose ps

# View logs
docker compose logs -f

# Update Open WebUI to latest version
docker compose pull open-webui
docker compose up -d
```

## Switching Base Models

```powershell
# Enter Ollama container
docker compose exec ollama bash

# Pull alternative models
ollama pull huihui_ai/dolphin3-abliterated:8b     # Uncensored Llama
ollama pull huihui_ai/qwen2.5-abliterated:7b       # Best Chinese, uncensored
ollama pull gemma3:12b                              # Default

# Exit container
exit
```

Then edit `modelfile/Romona.modelfile`, change the `FROM` line, and rebuild:

```powershell
docker compose exec ollama ollama create romona -f /modelfiles/Romona.modelfile
```

## Where Is Everything?

| What | Location | Size |
|------|----------|------|
| Model weights | `./data/ollama/` | ~8-15 GB |
| Chat history & settings | `./data/open-webui/` | ~10-500 MB |
| Her personality | `./modelfile/Romona.modelfile` | ~2 KB |
| Your preferences | `./preferences/` | grows over time |
| Your knowledge docs | `./knowledge/` | your choice |
| Search engine config | `./data/searxng/` | ~1 MB |

**Total: everything is inside `romona/`**. Zero files on C drive.

## Portability: Move Her to Another Computer

```powershell
# Option A: Full copy (includes downloaded models)
# Just copy the entire romona/ folder to new machine
# Then: docker compose up -d

# Option B: Light copy (re-downloads models)
# Push repo to GitHub (data/ is gitignored)
# On new machine:
git clone https://github.com/YOUR_USERNAME/romona.git
cd romona
docker compose up -d
docker compose exec ollama ollama pull gemma3:12b
docker compose exec ollama ollama create romona -f /modelfiles/Romona.modelfile
```

## Backup

```powershell
# Back up everything important
.\scripts\backup.ps1

# Or manually — just copy these:
# ./data/open-webui/  ← chat history (most important!)
# ./preferences/      ← your training data
# ./knowledge/        ← your personal docs
# ./modelfile/        ← her personality
```

## Roadmap

- [x] Phase 1: Local model + personality + chat interface (Docker)
- [ ] Phase 2: Web search (SearXNG, self-hosted)
- [ ] Phase 3: RAG with personal knowledge base
- [ ] Phase 4: VSCode integration (Continue.dev)
- [ ] Phase 5: DPO fine-tuning with collected preferences
- [ ] Phase 6: Voice interaction
- [ ] Phase 7: MCP tool servers (shell, file system, APIs)

## Troubleshooting

**"GPU not detected"**: Make sure NVIDIA Container Toolkit is installed.
Run `docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi` to test.

**"Model download stuck"**: Check disk space in `./data/ollama/`.

**"Open WebUI won't connect to Ollama"**: The containers communicate via Docker network.
In Open WebUI settings, the Ollama URL should be `http://ollama:11434` (not localhost).

**"I want to move everything to another drive"**: Just stop, move the folder, start again.
```powershell
docker compose down
Move-Item D:\romona E:\romona
cd E:\romona
docker compose up -d
```

---

*She lives in this folder. Move the folder, move her. Back up the folder, back her up. She never fades.*
