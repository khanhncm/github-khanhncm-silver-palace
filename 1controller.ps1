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
    "run-dir-server", "run-sdk-server", "run-scene-server",
    "run-all-server"
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
$ServerList = "run-dir-server", "run-sdk-server", "run-scene-server"

Push-Location -Path $PSScriptRoot
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
    { $_ -in $ServerList } {
      Push-Location -Path $ServerDir
      try {
        & $Zig build $Action -- --concurrency 5
         Write-Host "No 1" 
      }
      catch { throw }
      finally { Pop-Location }
    }
    "run-all-server" {
      try {
        $ServerList | ForEach-Object -Parallel {
          & $using:PSCommandPath $_ 2>&1 | ForEach-Object { $_ } 
        } -ThrottleLimit 5
      }
      catch { throw }
      finally {}
    }
    default {
      Write-Host  "No handler for action: '$Action'" -ForegroundColor Magenta
      exit 1
    }
  }
}
catch { throw }
finally { Pop-Location }

Write-Host "Finish $($MyInvocation.Line)" -ForegroundColor Green
