<#
folder structure
  YOU ARE HERE
  THIS-SCRIPT.ps1
  controller.ps1
#>

param(
  [Parameter(Position=0)]
  [ValidateSet("client", "server")]
  [string]$Target
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$PipelineMap = @{
    client = "build-patch", "patch-client", "run-client"
    server = "build-server", "run-all-server"
}

$pipeline = $PipelineMap.$Target
if (-not $pipeline) {
    Write-Host "Unknown target: $Target" -ForegroundColor Magenta
    exit 1
}

Push-Location -Path $PSScriptRoot
try {
  $controller = "1controller.ps1"
  $total = $pipeline.Count
  $current = 0
  foreach ($stage in $pipeline) {
      Write-Host ">> $controller $stage" -ForegroundColor Cyan
      & .\$controller $stage
  }
}
catch { throw }
finally { Pop-Location }

Write-Host "Finish $($MyInvocation.Line)" -ForegroundColor Green
