<#
folder structure
  YOU ARE HERE
  THIS-SCRIPT.ps1
  client\
  server\
  zig\
#>

param(
  [Parameter(Position=0)]
  [ValidateSet(
    "build-client", "patch-client", "run-client", 
    "build-server", 
    "run-dir-server", "run-sdk-server", "run-scene-server", "run-all-server"
  )]
  [string]$Action
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$Zig = "$PSScriptRoot\zig\zig-x86_64-windows-0.17.0-dev.2251\zig.exe"

# client
$PatchDir = "client\bloom\"
$BinDir = "$PSScriptRoot\client\Silver_Palace-CBT2-0.10.82.1\SilverPalace\Binaries\Win64\"
$Game = "red_rose.exe"

#server
$ServerDir = "server\roze\"

try {
  switch -Regex ($Action) {
    "build-client" {
      Push-Location -Path $PatchDir
      try {
        & $Zig build
      }
      catch { throw }
      finally { Pop-Location }
    }
    "patch-client" {
      Push-Location -Path $PatchDir\zig-out\bin
      try {
        foreach ($file in @($Game, "bloom.dll")) {
          Copy-Item -Path $file -Destination $BinDir -Force -Verbose
        }
      }
      catch { throw }
      finally { Pop-Location }
    }     
    "run-client" { Start-Process -FilePath $Game -WorkingDirectory $BinDir }
    "build-server" {
      Push-Location -Path $ServerDir
      try {
        & $Zig build
      }
      catch { throw }
      finally { Pop-Location }
    }
    "^(run-dir-server|run-sdk-server|run-scene-server)" {
      Push-Location -Path $ServerDir
      try {
        & $Zig build  $Action -- --concurrency 5
      }
      catch { throw }
      finally { Pop-Location }
    }
    "run-all-server" {
      try {
        $j1 = Start-Job { .\1controller.ps1 run-dir-server }
        $j2 = Start-Job { .\1controller.ps1 run-sdk-server }
        $j3 = Start-Job { .\1controller.ps1 run-scene-server }
        
        # Stream logs in real-time
        Receive-Job -Job $j1,$j2,$j3 -Wait -AutoRemoveJob
      }
      catch { throw }
      finally { 
        Write-Host "Stopping..."
        Get-Job | Stop-Job
      }
    }
    default {
      Write-Host  "No handler for action: '$Action'" -ForegroundColor Magenta
      exit 1
    }
  }
}
catch { throw }

Write-Host "Finish $($MyInvocation.Line)" -ForegroundColor Green
