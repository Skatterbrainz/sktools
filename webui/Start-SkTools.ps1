#if (!(Get-Module sktools)) { Import-Module sktools }
#if (!(Get-Module sktools)) {
#    Import-Module $(Join-Path -Path $(Split-Path $PSScriptRoot) -ChildPath "sktools.psm1")
#}
$wpath = Join-Path -Path $(Split-Path $PSScriptRoot) -ChildPath "webui"
Write-Host "web path: $wpath"
#Write-Host "15 second pause..."
#Start-Sleep -Seconds 15
Start-PoSHServer -Port 8080 -HomeDirectory "$wpath" -CustomConfig "$wpath\config.ps1"
