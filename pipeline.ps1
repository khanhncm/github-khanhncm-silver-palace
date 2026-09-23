<#
folder structure
  YOU ARE HERE
  THIS-SCRIPT.ps1
  controller.ps1
#>

param(
[Parameter(Position=0)]
[ValidateSet("client")]
[string]$Target
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

try {
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
    $current += 1
    Write-Host "$current/$total> controller.ps1 $stage" -ForegroundColor Cyan
    & "$PSScriptRoot\controller.ps1" $stage
  }
  Write-Host "Done $($MyInvocation.Line)" -ForegroundColor Green
}
catch { throw }

