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

$Controller = ".\1controller.ps1"

try {
  switch ($Target) {
    "client" { 
      $pipeline = @("build-client", "patch-client", "run-client") 
      $total = $pipeline.Count
      $current = 0
      foreach ($stage in $pipeline ) {
        $current += 1
        Write-Host "$current/$total> $Controller $stage" -ForegroundColor Cyan
        & $Controller $stage
      }
    }
    "server" {
      & $Controller build-server
    }
    default {
      Write-Host "Unknown target: $Target" -ForegroundColor Magenta
      exit 1
    }
  }
}
catch { throw }

Write-Host "Finish $($MyInvocation.Line)" -ForegroundColor Green
