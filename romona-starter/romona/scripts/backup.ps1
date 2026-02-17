# Romona Backup Script (Windows)
# Run: .\scripts\backup.ps1
#
# Backs up everything that matters into a timestamped folder.
# Model weights are NOT backed up (re-download with ollama pull).

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupDir = ".\backups\$timestamp"

Write-Host ""
Write-Host "Backing up Romona..." -ForegroundColor Cyan
Write-Host "  Target: $backupDir" -ForegroundColor Gray
Write-Host ""

New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# Chat history and Open WebUI settings (most important!)
if (Test-Path ".\data\open-webui") {
    Write-Host "  [1/4] Chat history & settings..." -ForegroundColor Gray
    Copy-Item -Recurse ".\data\open-webui" "$backupDir\open-webui"
}

# Her personality
Write-Host "  [2/4] Personality (modelfile)..." -ForegroundColor Gray
Copy-Item -Recurse ".\modelfile" "$backupDir\modelfile"

# Preference data
Write-Host "  [3/4] Preference data..." -ForegroundColor Gray
Copy-Item -Recurse ".\preferences" "$backupDir\preferences"

# Knowledge docs
if (Test-Path ".\knowledge\about-me.md") {
    Write-Host "  [4/4] Knowledge docs..." -ForegroundColor Gray
    Copy-Item -Recurse ".\knowledge" "$backupDir\knowledge"
}

# Calculate size
$size = (Get-ChildItem -Recurse $backupDir | Measure-Object -Property Length -Sum).Sum / 1MB
$sizeStr = "{0:N1} MB" -f $size

Write-Host ""
Write-Host "  Backup complete: $backupDir ($sizeStr)" -ForegroundColor Green
Write-Host ""
Write-Host "  NOTE: Model weights are NOT backed up (re-download with 'ollama pull')." -ForegroundColor Gray
Write-Host "  To back up models too, copy .\data\ollama\ (~8-15 GB)" -ForegroundColor Gray
Write-Host ""
