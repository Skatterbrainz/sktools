try {
    $files = Get-ChildItem $PSScriptRoot\webui\Install-SkatterTools.ps1 -ErrorAction Stop
    $files | ForEach-Object { . $_.FullName }
}
catch {
    Write-Error "Failed to import: $($Error[0].Exception.Message)"
}