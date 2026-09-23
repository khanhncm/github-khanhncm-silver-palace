<#
folder structure
  YOU ARE HERE
  test\
    THIS-SCRIPT.ps1
  cilent\
  server\
  zig\

#>

Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

Write-Host "Begin"
Write-Host "`$PWD         $PWD"
Write-Host "`$pwd         $pwd"
Write-Host "pwd          $(pwd)"
Write-Host "Get-Location $(Get-Location)"
Push-Location -Path client
Write-Host "- atfer push"
Write-Host "`$PWD         $PWD"
Write-Host "`$pwd         $pwd"
Write-Host "pwd          $(pwd)"
Write-Host "Get-Location $(Get-Location)"
Write-Host "---------------"
try {
  Write-Host "Try"
  Write-Host "`$PWD         $PWD"
  Write-Host "`$pwd         $pwd"
  Write-Host "pwd          $(pwd)"
  Write-Host "Get-Location $(Get-Location)"
  Write-Host "- before return"
  # return
  Write-Host "- after return"
  Write-Host "- before exit"
  # [Environment]::Exit(1)  # immediate, finally does NOT run, avoid this
  exit
  Write-Host "- after exit" # this WON'T run
  Write-Host "exit"
}
catch { throw }
finally { 
  # finally ALWAYS run. despite return or exit
  Write-Host "---------------"
  Write-Host "Final"
  Write-Host "`$PWD         $PWD"
  Write-Host "`$pwd         $pwd"
  Write-Host "Get-Location $(Get-Location)"
  Pop-Location
  Write-Host "- atfer pop"
  Write-Host "`$PWD         $PWD"
  Write-Host "`$pwd         $pwd"
  Write-Host "pwd          $(pwd)"
  Write-Host "Get-Location $(Get-Location)"
}
Write-Host "---------------"
Write-Host "End"
