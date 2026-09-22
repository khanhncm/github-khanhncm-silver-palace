param(
    [Parameter(Position=0)]
    [ValidateSet("build-client", "patch-client", "run-client", "build-server")]
    [string]$Action
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$Zig = "$PSScriptRoot\zig\zig-x86_64-windows-0.17.0-dev.2251\zig.exe"
$PatchDir = "$PSScriptRoot\client\bloom\"
$BinDir = "$PSScriptRoot\client\Silver_Palace-CBT2-0.10.82.1\SilverPalace\Binaries\Win64\"
$Game = "red_rose.exe"

switch ($Action) {
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
        Push-Location -Path .\server\zetsa
        try {
            Start-Process zig -ArgumentList "build run-cdnsv -Doptimize=ReleaseSmall" -NoNewWindow
            zig build run-gamesv -Doptimize=ReleaseSmall
        }
        catch { throw }
        finally { Pop-Location }
    }
    default {
        & $Zig version
        Write-Host  "Unknown action: '$Action'" -ForegroundColor Magenta
        exit 1
    }
}

Write-Host "Done" -ForegroundColor Green
