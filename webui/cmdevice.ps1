Get-SkParams | Out-Null
$Script:SearchField = "Name"
$Script:SearchType  = "equals"

$PageTitle   = "CM Device"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$plist = @('General','Collections','Disks','Network','OptionalFeatures','Software','CCM Logs','Tools')
$menulist = New-SkMenuList -PropertyList $plist -TargetLink "$pagelink`?v=$Script:SearchValue" -Default $Script:TabSelected
$tabset = $menulist
$output = $null

function Get-SkCmLogFiles {
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    )
    $output = ""
    try {
        $rootPath = "\\$ComputerName\c`$\windows\ccm\logs"
        if (!(Test-Path $rootPath)) {
            throw "Error: Path not found $rootPath"
        }
        $files = Get-ChildItem -Path $rootPath -File -ErrorAction Stop
        $output = "<table id=table1>"
        $output += "<tr><th>Filename</th><th>Size</th><th>Date Modified</th></tr>"
        $rowcount = 0
        $files | Select Name,Length,LastWriteTime | % {
            $flink = "<a href=`"openfile.ps1?path=$( Join-Path -Path $rootPath -ChildPath $_.Name)`">$($_.Name)</a>"
            $output += "<tr><td>$flink</td><td>$($_.Length)</td><td>$($_.LastWriteTime)</td></tr>"
            $rowcount++
        }
        $output += "<tr><td colspan=`"3`" class=`"lastrow`">$rowcount files</td></tr></table>"
    }
    catch {
        $output += "<table id=table2><tr><td>Error: $_</td></tr></table>"
    }
    finally {
        Write-Output $output 
    }
}

try {
	switch ($TabSelected) {
		'General' {
			$params = @{
				QueryFile = "cmdevice.sql"
				PageLink  = $pagelink
				FieldName = $Script:SearchField
				Value     = $Script:SearchValue
				Columns   = ('Name','ResourceID','Manufacturer','Model','SerialNumber','OperatingSystem','OSBuild','Processor','Cores','TrustExec','VmCapable','ClientVersion','LastHwScan','LastDDR','LastPolicyRequest','ADSiteName')
			}
			$content = Get-SkQueryTableSingle2 @params
			break;
		}
		'Collections' {
			try {
				$params = @{
					QueryFile = "cmdevicecolls.sql"
					PageLink  = $pagelink
					Columns   = ('CollectionID','CollectionName')
				}
				$content = Get-SkQueryTableMultiple @params -NoUnFilter -NoCaption
				if ($SkCmCollectionManage -eq 'TRUE') {
					$dcolls  = Get-SkCmDeviceCollectionMemberships -ComputerName $Script:SearchValue -Inverse
					if ($dcolls.count -gt 0) {
						$content += "<form name='form1' id='form1' method='post' action='cmaddmember.ps1'>"
						$content += "<input type='hidden' name='resname' id='resname' value='$CustomName' />"
						$content += "<input type='hidden' name='resid' id='resid' value='$SearchValue' />"
						$content += "<input type='hidden' name='restype' id='restype' value='5' />"
						$content += "<table id=table2><tr><td>"
						$content += "<select name='collname' id='collname' size=1 style='width:500px;padding:5px'>"
						$content += "<option value=`"`"></option>"
						foreach ($row in $dcolls) {
							$cid = $row.CollectionID
							$cnn = $row.Name
							$content += "<option value=`"$cnn`">$cnn</option>"
						}
						$content += "</select> <input type='submit' name='ok' id='ok' value='Add' class='button1' />"
						$content += " (direct membership collections only)</td></tr></table></form>"
					}
				}
			}
			catch {
				$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
			}
			break;
		}
		'Network' {
			$content = Get-SkQueryTableMultiple -QueryFile "cmdevicenetconfigs.sql" -PageLink $pagelink
			break;
		}
		'Disks' {
			$params  = @{
				 QueryFile = "cmdevicedrives.sql"
				 PageLink  = $pagelink 
				 Columns   = ('Drive','DiskType','Description','DiskSize','Used','FreeSpace','PCT')
			}
			$content = Get-SkQueryTableMultiple @params
			break;
		}
		'OptionalFeatures' {
			$SearchField = 'ComputerName'
			$params = @{
				QueryFile  = "cmdevicefeatures.sql"
				PageLink   = $pagelink 
				Columns    = ('FeatureName','FeatureID','InstallState') 
				Sorting    = "FeatureName" 
				NoUnFilter = $True 
				NoCaption  = $True
			}
			$content = Get-SkQueryTableMultiple @params
			break;
		}
		'Software' {
			$SearchField = 'Name0'
			$params = @{
				QueryFile  = "cmdeviceapps.sql" 
				PageLink   = $pagelink 
				Columns    = ('ProductName','Publisher','Version') 
				Sorting    = "ProductName" 
				NoUnFilter = $True
				NoCaption  = $True
			}
			$content = Get-SkQueryTableMultiple @params
			break;
		}
		'CCM Logs' {
			$content = Get-SkCmLogFiles -ComputerName $SearchValue
			break;
		}
		'Tools' {
			$content = Write-SkRemoteTools -ComputerName $SearchValue -CallSource 'cm'
			break;
		}
	}
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}

$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent