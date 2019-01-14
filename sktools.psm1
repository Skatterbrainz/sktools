$files = @('Install-SkatterTools.ps1','Start-SkatterTools.ps1')
try {
	Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1" -Recurse -ErrorAction Stop | 
		Where {$_.Name -in $files} | %{ . $_.FullName }
}
catch {
    Write-Error "Failed to import: $($Error[0].Exception.Message)"
}
