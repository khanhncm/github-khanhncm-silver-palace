Write-Host 'while ($i -lt 5)'
$i = 0
do {
    Write-Host "`$i $i"
    $i++
} while ($i -lt 5)

Write-Host 'until ($i -ge 5)'
$i = 0
do {
    Write-Host "`$i $i"
    $i++
} until ($i -ge 5)
