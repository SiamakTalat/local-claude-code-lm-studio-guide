# Example: environment variables for pointing Claude Code at a local LM Studio server.
# LM Studio must be running with the local server enabled (default port often 1234).
#
# Usage:
#   . .\examples\powershell-profile.ps1
# Or merge the $env: lines into your PowerShell profile:
#   notepad $PROFILE

# Base URL for Anthropic-compatible clients routing to LM Studio.
# Adjust port/path if your LM Studio server uses different settings.
$env:ANTHROPIC_BASE_URL = "http://localhost:1234"

# LM Studio commonly expects a non-empty API key; many local setups use any placeholder.
if (-not $env:ANTHROPIC_API_KEY) {
    $env:ANTHROPIC_API_KEY = "lm-studio"
}

# Optional: increase HTTP timeouts for slow CPU prompt ingestion (if your client reads these).
# Names vary by client version; uncomment and tune if supported.
# $env:ANTHROPIC_TIMEOUT_MS = "300000"
# $env:HTTP_TIMEOUT_MS = "300000"

Write-Host "ANTHROPIC_BASE_URL = $env:ANTHROPIC_BASE_URL" -ForegroundColor Cyan
Write-Host "ANTHROPIC_API_KEY   = (set)" -ForegroundColor Cyan
