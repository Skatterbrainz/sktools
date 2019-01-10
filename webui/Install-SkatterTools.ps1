function Install-SkatterTools {
    [CmdletBinding()]
    param (
        [parameter()]
        [string] $Port = "8080"
    )
    try {
        $mpath = Split-Path $(Get-Module sktools).path
        $wpath = Join-Path -Path $mpath -ChildPath "webui"
        Write-Host "unblocking scripts in skattertools folder..." -ForegroundColor Cyan
        Get-ChildItem -Path $mpath -Filter "*.ps1" -Recurse | Unblock-File -Confirm:$False
        Write-Host "setting default configuration..." -ForegroundColor Cyan
        Set-SkDefaults
        # C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 
        # Start-PoSHServer -HomeDirectory `"C:\Program Files\WindowsPowerShell\Modules\sktools\1901.8.6\webui`" -Port 8080
        Write-Verbose "creating desktop shortcuts..."
        New-SkDesktopShortcut -Name "Start SkatterTools Web Service" -Target "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" -Arguments "Start-PoSHServer -Port $Port -HomeDirectory `"$wpath`""
        New-SkDesktopShortcut -Name "SkatterTools" -Target "http://localhost`:$Port/" -ShortcutType web
        Write-Host "SkatterTools setup is complete!" -ForegroundColor Green
    }
    catch {
        Write-Warning "Welcome to pukeville! Something just puked and died. Better find a mop."
        Write-Error $Error[0].Exception.Message
    }
}

Export-ModuleMember -Function Install-SkatterTools