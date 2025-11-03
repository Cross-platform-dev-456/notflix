<#
Start PocketBase for local development (PowerShell)

Place this file next to the `pocketbase.exe` binary and run it from PowerShell.
It will create a `pb_data` folder if missing and start PocketBase with that dir.

Usage:
  Open PowerShell, cd to the folder, then:
    .\start-pocketbase.ps1
#>

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $scriptDir

if (-not (Test-Path -Path ".\pb_data")) {
    New-Item -ItemType Directory -Path ".\pb_data" | Out-Null
    Write-Host "Created pb_data directory."
}

Write-Host "Starting PocketBase (http://localhost:8090). Press Ctrl+C to stop."

# Run the binary in the current window so logs are visible
& ".\pocketbase.exe" serve --dir ".\pb_data"

Pop-Location
