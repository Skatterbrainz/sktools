try {
    $files = Get-ChildItem $PSScriptRoot\webui\config.ps1 -ErrorAction Stop
    $files | ForEach-Object { . $_.FullName }
    Write-Host "loaded"
}
catch {
    Write-Error "Failed to import: $($Error[0].Exception.Message)"
}
Get-SkToolsInfo