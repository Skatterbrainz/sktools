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
            Write-Verbose "creating shortcut for All Users"
            $ShortcutFile = "$env:ALLUSERSPROFILES\Desktop\$Name.lnk"
        }
        else {
            Write-Verbose "creating shortcut for Current User"
            $ShortcutFile = "$env:USERPROFILE\Desktop\$Name.lnk"
        }
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        $Shortcut.TargetPath = $Target
        if ($ShortcutType -eq 'file' -and $Arguments -ne "") {
            Write-Verbose "file based shortcut target"
            $Shortcut.Arguments = $Arguments
            $Shortcut.IconLocation = "$env:SystemRoot\System32\shell32.dll,167"
        }
        else {
            Write-Verbose "web based shortcut target"
            $Shortcut.IconLocation = "$env:SystemRoot\System32\shell32.dll,174"
        }
        [void]$Shortcut.Save()
        Write-Verbose "shortcut saved"
    }
    catch {
        Write-Error $Error[0].Exception.Message
    }
}

function Set-SkDefaults {
    [CmdletBinding()]
    param()
    Write-Host "setting default configuration" -ForegroundColor Cyan
    try {
        $cfgfile = "$($env:USERPROFILE)\Documents\skconfig.txt"
        Write-Verbose "config file: $cfgfile"
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
        Write-Verbose "writing to $cfgfile"
        $params.Keys | %{ "$($_) = $($params.Item($_))" } | Out-File $cfgfile
        Write-Host "configuration saved to: $cfgfile" -ForegroundColor Cyan
        $result = "success"
    }
    catch {
        #Write-Error $Error[0].Exception.Message
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
    Write-Verbose "checking for poshserver module"
    if (!(Test-Path "$env:ProgramFiles\PoSHServer\modules\PoSHServer\PoSHServer.psd1")) {
        Write-Warning "PoSHServer *HAS* to be installed first!"
        break
    }
    Write-Verbose "poshserver verified. building configuration"
    try {
        #$mpath = Split-Path $(Get-Module sktools).path
        $startfile = Join-Path $PSScriptRoot -ChildPath "Start-SkTools.ps1"
        Write-Verbose "startfile = $startfile"
        Write-Host "unblocking scripts in skattertools folder..." -ForegroundColor Cyan
        Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1" -Recurse | Unblock-File -Confirm:$False
        Write-Host "setting default configuration..." -ForegroundColor Cyan
        if ($(Set-SkDefaults) -ne "success") {
            Write-Warning "Failed to update skconfig.txt file under user documents folder"
            break
        }
        Write-Host "creating desktop shortcuts..." -ForegroundColor Cyan
        $params = @{
            Name      = "Start Web Service" 
            Target    = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" 
            Arguments = "-File `"$startfile`""
        }
        New-SkDesktopShortcut @params | Out-Null
        $params = @{
            Name   = "SkatterTools" 
            Target = "http://localhost`:$Port/" 
            ShortcutType = "web"
        }
        New-SkDesktopShortcut @params | Out-Null
        Write-Host "SkatterTools setup is complete!" -ForegroundColor Green
    }
    catch {
        Write-Error $Error[0].Exception.Message
        Write-Warning "Welcome to pukeville! Something just puked and died. Better find a mop."
    }
}

#Export-ModuleMember -Function Install-SkatterTools