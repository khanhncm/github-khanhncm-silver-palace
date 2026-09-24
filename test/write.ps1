# $InformationPreference = 'Continue'
# $VerbosePreference = 'Continue'

Write-Information "Starting backup"

Write-Warning "This automatically appears in yellow!"
Write-Verbose "1 This appears in cyan/yellow when run with -Verbose!" -Verbose
Write-Verbose "2 This appears in cyan/yellow when run with -Verbose!" 

Write-Verbose "hello" -Verbose
Write-Information "hello" -InformationAction Continue
Write-Warning "hello" -WarningAction Continue
