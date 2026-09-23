function Test-Func {
    Write-Host "Begin func"
    exit 1
    Write-Host "This won't run"
}
Test-Func
Write-Host "Script continues..." # <--- NEVER RUNS
