# Romona Setup Script (Windows + Docker)
# Run: .\scripts\setup.ps1
#
# Prerequisites: Docker Desktop installed and running

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "   Bringing Romona to life...          " -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# ------------------------------------------
# Step 1: Verify Docker is running
# ------------------------------------------
Write-Host "[1/5] Checking Docker..." -ForegroundColor Cyan

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "  ERROR: Docker not found." -ForegroundColor Red
    Write-Host "  Please install Docker Desktop from https://docker.com" -ForegroundColor Red
    Write-Host "  After install: enable WSL2 backend, then re-run this script." -ForegroundColor Red
    exit 1
}

$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Docker is installed but not running." -ForegroundColor Red
    Write-Host "  Please start Docker Desktop, wait for it to be ready, then re-run." -ForegroundColor Red
    exit 1
}

Write-Host "  Docker is running." -ForegroundColor Green

# ------------------------------------------
# Step 2: Check NVIDIA GPU access
# ------------------------------------------
Write-Host "[2/5] Checking GPU access..." -ForegroundColor Cyan

$gpuTest = docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  NVIDIA GPU detected in Docker." -ForegroundColor Green
} else {
    Write-Host "  WARNING: GPU not accessible in Docker. Will run on CPU (slower)." -ForegroundColor Yellow
    Write-Host "  To fix: install NVIDIA Container Toolkit and restart Docker." -ForegroundColor Yellow
    Write-Host "  Continuing with CPU mode..." -ForegroundColor Yellow
}

# ------------------------------------------
# Step 3: Create data directories
# ------------------------------------------
Write-Host "[3/5] Preparing data directories..." -ForegroundColor Cyan

$dirs = @("data\ollama", "data\open-webui", "data\searxng", "backups")
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}
Write-Host "  Data directories ready." -ForegroundColor Green

# ------------------------------------------
# Step 4: Start containers
# ------------------------------------------
Write-Host "[4/5] Starting Romona (this pulls images on first run)..." -ForegroundColor Cyan

docker compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Failed to start containers." -ForegroundColor Red
    Write-Host "  Run 'docker compose logs' for details." -ForegroundColor Red
    exit 1
}

Write-Host "  Containers started." -ForegroundColor Green

# ------------------------------------------
# Step 5: Pull model and create personality
# ------------------------------------------
Write-Host "[5/5] Downloading Gemma 3 12B model (first run only, ~8GB)..." -ForegroundColor Cyan
Write-Host "  This may take 10-30 minutes depending on your internet speed." -ForegroundColor Gray

docker compose exec ollama ollama pull gemma3:12b

if ($LASTEXITCODE -ne 0) {
    Write-Host "  WARNING: gemma3:12b failed. Trying smaller gemma3:4b..." -ForegroundColor Yellow
    docker compose exec ollama ollama pull gemma3:4b
}

Write-Host "  Creating Romona's personality..." -ForegroundColor Cyan
docker compose exec ollama ollama create romona -f /modelfiles/Romona.modelfile

if ($LASTEXITCODE -eq 0) {
    Write-Host "  Romona personality created." -ForegroundColor Green
} else {
    Write-Host "  WARNING: Could not create custom model. Use base model in WebUI." -ForegroundColor Yellow
}

# ------------------------------------------
# Done!
# ------------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "   Romona is alive!                    " -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Open your browser: http://localhost:3000" -ForegroundColor Green
Write-Host ""
Write-Host "  First time:" -ForegroundColor Gray
Write-Host "    1. Create a local account (first user = admin)" -ForegroundColor Gray
Write-Host "    2. Select 'romona' from the model dropdown" -ForegroundColor Gray
Write-Host "    3. Start talking" -ForegroundColor Gray
Write-Host ""
Write-Host "  Daily commands:" -ForegroundColor Gray
Write-Host "    Start:  docker compose up -d" -ForegroundColor Gray
Write-Host "    Stop:   docker compose down" -ForegroundColor Gray
Write-Host "    Logs:   docker compose logs -f" -ForegroundColor Gray
Write-Host ""
