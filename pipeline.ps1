param(
    [Parameter(Position=0)]
    [ValidateSet("client")]
    [string]$Target
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$pipeline = @()
switch ($Target.ToLower()) {
    "client" { $pipeline = @("build-client", "patch-client", "run-client") }
     default {
        Write-Host "Unknown target: $Target" -ForegroundColor Magenta
        exit 1
    }
}

$total = $pipeline.Count
$current = 0
foreach ($stage in $pipeline) {
    Write-Host ">> controller.ps1 $stage" -ForegroundColor Cyan
    try {
        & "$PSScriptRoot\controller.ps1" $stage
    }
    catch { throw }
}
