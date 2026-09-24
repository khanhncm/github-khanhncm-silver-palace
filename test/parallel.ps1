
Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

function Invoke1 {
  Write-Host "1111"
  'hang.ps1 a', 'hang.ps1 b' | ForEach-Object -Parallel {
    $script = $_
    pwsh -NoProfile -Command "& ./$script" | ForEach-Object {
        "[$script] $_"
    }
  } -ThrottleLimit 5
}

function Invoke2 {
  Write-Host "2222"
  $script = "hang.ps1"
  Write-Host "`$PSScriptRoot  $PSScriptRoot"
  Write-Host "`$PSCommandPath $PSCommandPath"
  ('a', 'bb') | ForEach-Object -Parallel {
    Write-Host "Parallel `$PSScriptRoot  $PSScriptRoot"
    Write-Host "Parallel `$PSCommandPath $PSCommandPath"
    Write-Host "Parallel `$using:PSCommandPath $using:PSCommandPath"
    $target = $_
    pwsh -File $using:script $target 2>&1 | ForEach-Object { "[$target] $_" }
  } -ThrottleLimit 5
}

Push-Location -Path $PSScriptRoot
try {
  # Invoke1
  Invoke2
}
catch { throw }
finally { Pop-Location }
