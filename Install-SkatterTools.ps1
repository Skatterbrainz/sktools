function Install-SkatterTools {
    [CmdletBinding()]
    param()
    Write-Host "setting default configuration" -ForegroundColor Cyan
    try {
        $cfgfile = "$($env:USERPROFILE)\Documents\skconfig.txt"
        Write-Verbose "config file: $cfgfile"
        if (Test-Path $cfgfile) {
            Write-Warning "overwriting $cfgfile with default settings!"
        }
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
		Write-Host "use the SETTINGS option within the console to change defaults" -ForegroundColor Green
        $result = "success"
    }
    catch {
        $result = "error"
    }
    finally {
        Write-Output $result
    }
}
Export-ModuleMember -Function Install-SkatterTools