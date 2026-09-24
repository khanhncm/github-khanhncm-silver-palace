# [System.Threading.ManualResetEvent]::new($false).WaitOne() # ctrl c useless, have to kill terminal
# [System.Threading.Tasks.Task]::Delay(-1).Wait() # ctrl c useless

Write-Host "hang `$PSCommandPath               $PSCommandPath"
Write-Host "hang `$MyInvocation.MyCommand.Name $($MyInvocation.MyCommand.Name)"
$name = $args[0]
while ($true) {
  Write-Host $name AA
  Write-Host $name B
  Start-Sleep -Milliseconds 1000
}
