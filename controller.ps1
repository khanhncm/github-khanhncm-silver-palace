
[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ValidateSet("build-client", "patch-client", "run-client", "build-server")]
    [string]$Action
)

$Zig = "$PSScriptRoot\zig\zig-x86_64-windows-0.17.0-dev.2251\zig.exe"
$PatchDir = "$PSScriptRoot\client\bloom\"
$BinDir = "$PSScriptRoot\client\Silver_Palace-CBT2-0.10.82.1\SilverPalace\Binaries\Win64\"
$Game = "red_rose.exe"

switch ($Action) {
    "build-client" {
        Push-Location -Path $PatchDir
        try {
            Write-Host "Current Directory: $($PWD.Path)" -ForegroundColor Green
            & $Zig build
        }
        finally { Pop-Location }
    }
    "patch-client" {
        & {
            $builtDir =  "$PatchDir\zig-out\bin"
            $exePath      = "$builtDir\$Game"
            $dllPath      = "$builtDir\bloom.dll"
            if (!(Test-Path $exePath)) { throw "exe not found: $exePath" }
            if (!(Test-Path $dllPath)) { throw "dll not found: $dllPath" }
            Copy-Item -Path $exePath, $dllPath -Destination $BinDir -Force -Verbose
        }
    }
    "run-client" { Start-Process -FilePath $Game -WorkingDirectory $BinDir }
    "build-server" {
        Push-Location -Path .\server\zetsa
        try {
            Start-Process zig -ArgumentList "build run-cdnsv -Doptimize=ReleaseSmall" -NoNewWindow
            zig build run-gamesv -Doptimize=ReleaseSmall
        }
        finally { Pop-Location }
    }
    default {
        & $Zig version
        throw "Unknown action: '$Action'"
    }
}

Write-Host "Done" -ForegroundColor Green
