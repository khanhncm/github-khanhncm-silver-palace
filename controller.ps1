
[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ValidateSet("build-client", "patch-client", "run-client", "build-server")]
    [string]$Action
)


function Add-Zig {
    $ZigPath = "$PSScriptRoot\zig\zig-x86_64-windows-0.17.0-dev.2251"
    if (Test-Path $ZigPath) {
        $env:Path = "$ZigPath;$env:Path"
    } else {
        Write-Host "Zig folder not found: $ZigPath"  -ForegroundColor Magenta
        exit 1
    }
}

$PatchDir = "$PSScriptRoot\client\bloom\"
$ClientDir = "$PSScriptRoot\client\Silver_Palace-CBT2-0.10.82.1\"
$BinDir = "$ClientDir\Binaries\Win64\"
$GameExe = "$BinDir\red_rose.exe"

switch ($Action) {
    "build-client" {
        Push-Location -Path $PatchDir
        try {
            Write-Host "Current Directory: $($PWD.Path)" -ForegroundColor Green
            Add-Zig
            Write-Host "www $env:Path"
            Write-Host "trst $ZigPath"
            zig build
        }
        finally {
            Pop-Location
        }
    }
    "patch-client" {
        & {
            $sourceDir =  "$PatchDir\zig-out\bin"
            $exePath      = "$SourceDir\red_rose.exe"
            $dllPath      = "$SourceDir\bloom.dll"
            if (!(Test-Path $exePath)) { 
                throw "Exe not found: $exePath" 
            }
            if (!(Test-Path $dllPath)) { 
                throw "Exe dll not found: $dllPath" 
            }
            Copy-Item -Path $exePath -Destination $BinDir -Force
        }
    }
    "run-client" {
        Start-Process -FilePath $GameExe
    }
    "build-server" {
        Push-Location -Path .\server\zetsa
        try {
            Start-Process zig -ArgumentList "build run-cdnsv -Doptimize=ReleaseSmall" -NoNewWindow
            zig build run-gamesv -Doptimize=ReleaseSmall
        }
        finally {
            Pop-Location
        }
    }
    default {
        (Get-Command zig).Definition
        zig version
        Write-Host "Unknown action: '$Action'" -ForegroundColor Red
    }
}
