# github-khanhncm-silver-palace

winget install --id Microsoft.PowerShell --source winget -e
creat desktop shortcut. vscode and search bar will see it. then, you can add it to task bar. start menu , vscode 


PowerShell
if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force -Verbose }
notepad $PROFILE
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Get-NetTCPConnection -LocalPort 300001 | Format-List LocalAddress, LocalPort, State, OwningProcess

F:\ghidra\ghidra_12.1.3_PUBLIC\support\launch.properties
VMARGS_WINDOWS=-Dsun.java2d.uiScale=2
