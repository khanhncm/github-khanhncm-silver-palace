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

try {
  $pipeline = @()
  switch ($Target.ToLower()) {
    "client" { $pipeline = @("build-client", "patch-client", "run-client") }
    "server" { $pipeline = @("build-server", "run-server") }
    default {
      Write-Host "Unknown target: $Target" -ForegroundColor Magenta
      exit 1
    }
  }
  $total = $pipeline.Count
  $current = 0
  $controller = "1controller.ps1"
  foreach ($stage in $pipeline) {
    $current += 1
    Write-Host "$current/$total> $controller $stage" -ForegroundColor Cyan
    & "$PSScriptRoot\$controller" $stage
  }
}
catch { throw }
finally {
  Write-Host "Finish $($MyInvocation.Line)" -ForegroundColor Green
}