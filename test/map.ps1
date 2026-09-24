$PipelineMap = @{
    client = "build-patch", "patch-client", "run-client"
    server = @("build-server", "run-all-server")
}

$PipelineMap.client
Write-Host "client         $($PipelineMap["client"])"
$PipelineMap.server
Write-Host "server         $($PipelineMap.server)"
$PipelineMap["client"]

$Target = "client"
$PipelineMap.$Target
Write-Host "`$Target         $($PipelineMap.$Target)"
