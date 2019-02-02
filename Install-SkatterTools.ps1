<#
.DESCRIPTION

	Creates initial (default) SkTools configuration file

.PARAMETER (none)

.INPUTS (none)

.OUTPUTS (none)

.HUMOR (none)

.EXAMPLE

	Just use the damn thing already
#>

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
			_Comment               = "SkatterTools configuration file. Lines with underscore prefix are comments."
			_LastUpdated           = (Get-Date)
			_ModuleVersion         = (Get-Module sktools).Version -join '.'
			_UpdatedBy             = $env:USERNAME
			_LocalHost             = $env:COMPUTERNAME
			_UserDomain            = $env:USERDOMAIN
			SkAPPNAME              = "SkatterTools"
			SkTheme                = "stdark.css"
			SkADEnabled            = "TRUE"
			SkADGroupManage        = "TRUE"
			SkCMEnabled            = "TRUE"
			SkCmDBHost             = "cm01.contoso.local"
			SkCmSMSProvider        = "cm01.contoso.local"
			SkCmSiteCode           = "P01"
			SkCmCollectionManage   = "TRUE"
			SkDebug                = "FALSE"
			SkTabSelectAdUsers     = "A"
			SkTabSelectAdGroups    = "A"
			SkTabSelectAdComputers = "A"
			SkTabSelectCmFiles     = "A"
			SkTabSelectCmUsers     = "A"
			SkTabSelectCmDevices   = "A"
			SkTabSelectCmDevColls  = "A"
			SkTabSelectCmUserColls = "A"
			SkCmCollectionCheck    = "TRUE"
			SkUseDashboard         = "TRUE"
			SkToolsPath            = Join-Path -Path $env:USERPROFILE -ChildPath "Documents"
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