[CmdletBinding()]
param()

function New-SkDesktopShortcut {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
        [string] $Name,
        [parameter(Mandatory=$True)]
        [string] $Target,
        [parameter(Mandatory=$False)]
        [string] $Arguments = "",
        [parameter(Mandatory=$False)]
        [ValidateSet('file','web')]
        [string] $ShortcutType = 'file',
        [switch] $AllUsers
    )
    if ($ShortcutType -eq 'file' -and (!(Test-Path $Target))) {
        Write-Warning "Target not found: $Target"
        break
    }
    try {
        if ($AllUsers) {
            $ShortcutFile = "$env:ALLUSERSPROFILES\Desktop\$Name.lnk"
        }
        else {
            $ShortcutFile = "$env:USERPROFILE\Desktop\$Name.lnk"
        }
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        $Shortcut.TargetPath = $Target
        if ($ShortcutType -eq 'file' -and $Arguments -ne "") {
            $Shortcut.Arguments = $Arguments
            $Shortcut.IconLocation = "$env:SystemRoot\System32\shell32.dll,167"
        }
        else {
            $Shortcut.IconLocation = "$env:SystemRoot\System32\shell32.dll,174"
        }
        [void]$Shortcut.Save()
    }
    catch {
        Write-Error $Error[0].Exception.Message
    }
}

function Set-SkDefaults {
    [CmdletBinding()]
    param()
    try {
        $cfgfile = "$($env:USERPROFILE)\Documents\skconfig.txt"
        $params = [ordered]@{
            _Comment = "SkatterTools configuration file. Created by Set-SkDefaults"
            _LastUpdated         = (Get-Date)
            _UpdatedBy           = $env:USERNAME
            _LocalHost           = $env:COMPUTERNAME
            SkAPPNAME            = "SkatterTools"
            SkTheme              = "stdark.css"
            SkADEnabled          = "TRUE"
            SkADGroupManage      = "TRUE"
            SkCMEnabled          = "TRUE"
            SkCmDBHost           = "cm01.contoso.local"
            SkCmSMSProvider      = "cm01.contoso.local"
            SkCmSiteCode         = "P01"
            SkCmCollectionManage = "TRUE"
        }
        $params.Keys | %{ "$($_) = $($params.Item($_))" } | Out-File $cfgfile
        Write-Verbose "configuration saved to: $cfgfile"
        $result = "success"
    }
    catch {
        Write-Error $Error[0].Exception.Message
        $result = "error"
    }
    finally {
        Write-Output $result
    }
}

function Install-SkatterTools {
    [CmdletBinding()]
    param (
        [parameter()]
        [string] $Port = "8080"
    )
    if (!(Test-Path "$env:ProgramFiles\PoSHServer\modules\PoSHServer\PoSHServer.psd1")) {
        Write-Warning "PoSHServer *HAS* to be installed first!"
        break
    }
    try {
        $mpath = Split-Path $(Get-Module sktools).path
        $wpath = Join-Path -Path $mpath -ChildPath "webui"
        $startfile = Join-Path $wpath -ChildPath "Start-SkTools.ps1"
        Write-Host "unblocking scripts in skattertools folder..." -ForegroundColor Cyan
        Get-ChildItem -Path $mpath -Filter "*.ps1" -Recurse | Unblock-File -Confirm:$False
        Write-Host "setting default configuration..." -ForegroundColor Cyan
        if (Set-SkDefaults -ne "success") {
            Write-Warning "Failed to update skconfig.txt file under user documents folder"
            break
        }
        Write-Verbose "creating desktop shortcuts..."
        $params = @{
            Name      = "Start Web Service" 
            Target    = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" 
            Arguments = "-File `"$startfile`""
        }
        New-SkDesktopShortcut @params
        $params = @{
            Name   = "SkatterTools" 
            Target = "http://localhost`:$Port/" 
            ShortcutType = "web"
        }
        New-SkDesktopShortcut @params
        Write-Host "SkatterTools setup is complete!" -ForegroundColor Green
    }
    catch {
        Write-Warning "Welcome to pukeville! Something just puked and died. Better find a mop."
        Write-Error $Error[0].Exception.Message
    }
}

Export-ModuleMember -Function Install-SkatterTools