$action = $args[0]
Write-Host $action
switch ($action) {
    "start" {}
    "run" { continue }
    "up" {
        Write-Host "starting..."
    }
    { $_ -in "create", "add", "new" } {
        Write-Host "Action: Resource Creation"
    }
    "stop" {}
    "down" {
        Write-Host "stopping..."
    }
    default {
        Write-Host "unknown: $action"
    }
}
