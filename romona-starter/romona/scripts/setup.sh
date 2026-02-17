#!/bin/bash
# Romona Setup Script (macOS / Linux + Docker)
# Usage: chmod +x scripts/setup.sh && ./scripts/setup.sh

set -e

echo ""
echo "========================================"
echo "   Bringing Romona to life...           "
echo "========================================"
echo ""

# Check Docker
echo "[1/5] Checking Docker..."
if ! command -v docker &> /dev/null; then
    echo "  ERROR: Docker not found. Install from https://docker.com"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "  ERROR: Docker not running. Start Docker Desktop first."
    exit 1
fi
echo "  ✓ Docker is running."

# Check GPU
echo "[2/5] Checking GPU..."
if docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi &> /dev/null; then
    echo "  ✓ NVIDIA GPU available."
else
    echo "  ⚠ No GPU detected. Will use CPU (slower but works)."
fi

# Create directories
echo "[3/5] Preparing data directories..."
mkdir -p data/ollama data/open-webui data/searxng backups
echo "  ✓ Ready."

# Start containers
echo "[4/5] Starting containers..."
docker compose up -d
echo "  ✓ Containers started."

# Pull model & create personality
echo "[5/5] Downloading model & creating personality..."
docker compose exec ollama ollama pull gemma3:12b || {
    echo "  ⚠ gemma3:12b failed, trying gemma3:4b..."
    docker compose exec ollama ollama pull gemma3:4b
}

docker compose exec ollama ollama create romona -f /modelfiles/Romona.modelfile && \
    echo "  ✓ Romona personality created." || \
    echo "  ⚠ Could not create custom model."

echo ""
echo "========================================"
echo "   Romona is alive!                     "
echo "========================================"
echo ""
echo "  Open: http://localhost:3000"
echo "  Start: docker compose up -d"
echo "  Stop:  docker compose down"
echo ""
