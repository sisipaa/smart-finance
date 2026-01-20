param(
    [switch]$Build,
    [int]$Port = 8000,
    [switch]$Open = $true,
    [switch]$FlutterRun
)

# Change to the repository root (script located in ./scripts)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Resolve-Path (Join-Path $scriptDir "..")
Set-Location $repoRoot

function Run-Command($cmd, $args) {
    Write-Host "-> $cmd $args"
    & $cmd $args
    return $LASTEXITCODE
}

if ($Build) {
    Write-Host "Building web (flutter build web)..."
    $rc = Run-Command flutter 'build web'
    if ($rc -ne 0) {
        Write-Error "flutter build web failed with exit code $rc"
        exit $rc
    }
}

$webDir = Join-Path $repoRoot 'build\web'
if (-not (Test-Path $webDir)) {
    Write-Host "build\\web not found. Running 'flutter build web' now..."
    $rc = Run-Command flutter 'build web'
    if ($rc -ne 0) { Write-Error "flutter build web failed with exit code $rc"; exit $rc }
}

Write-Host "Serving: $webDir"
Push-Location $webDir

if ($FlutterRun) {
    if ($Open) {
        Start-Sleep -Milliseconds 700
        Write-Host "Opening http://localhost:$Port in default browser..."
        Start-Process "http://localhost:$Port"
    }

    Write-Host "Running 'flutter run -d web-server --web-port $Port --web-hostname=localhost' (press Ctrl+C to stop)..."
    # Run flutter run directly so it remains interactive in the terminal (supports hot reload)
    & flutter run -d web-server --web-port $Port --web-hostname=localhost

    $exitCode = $LASTEXITCODE
    Pop-Location
    exit $exitCode
}

if ($Open) {
    Start-Sleep -Milliseconds 500
    Write-Host "Opening http://localhost:$Port in default browser..."
    Start-Process "http://localhost:$Port"
}

Write-Host "Starting simple HTTP server (python -m http.server $Port). Press Ctrl+C to stop."
# Run python server (blocking) so logs are shown in this terminal
& python -m http.server $Port

$exitCode = $LASTEXITCODE
Pop-Location
exit $exitCode
