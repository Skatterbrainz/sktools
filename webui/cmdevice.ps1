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

$plist = @('General','Collections','Disks','Network','OptionalFeatures','Software','Tools')
$menulist = New-SkMenuList -PropertyList $plist -TargetLink "$pagelink`?v=$Script:SearchValue" -Default $Script:TabSelected
$tabset = $menulist
$output = $null

switch ($TabSelected) {
    'General' {
        $params = @{
            QueryFile = "cmdevice.sql"
            PageLink  = "cmdevice.ps1"
            Columns   = ('Name','ResourceID','Manufacturer','Model','SerialNumber','OperatingSystem','OSBuild','Processor','Cores','TrustExec','VmCapable','ClientVersion','LastHwScan','LastDDR','LastPolicyRequest','ADSiteName')
        }
        $content = Get-SkQueryTableSingle @params
        break;
    }
    'Collections' {
        try {
            $params = @{
                QueryFile = "cmdevicecolls.sql"
                PageLink  = "cmdevice.ps1"
                Columns   = ('CollectionID','CollectionName')
            }
            $content = Get-SkQueryTableMultiple @params -NoUnFilter -NoCaption
            
            if ($CmCollectionManage -eq 'TRUE') {
                $dcolls  = Get-SkCmDeviceCollectionMemberships -ComputerName $Script:SearchValue -Inverse
                if ($dcolls.count -gt 0) {
                    $content += "<form name='form1' id='form1' method='post' action='cmaddmember.ps1'>"
                    $content += "<input type='hidden' name='resname' id='resname' value='$CustomName' />"
                    $content += "<input type='hidden' name='resid' id='resid' value='$SearchValue' />"
                    $content += "<input type='hidden' name='restype' id='restype' value='5' />"
                    $content += "<table id=table2><tr><td>"
                    $content += "<select name='collid' id='collid' size=1 style='width:500px;padding:5px'>"
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
        $content = Get-SkQueryTableMultiple -QueryFile "cmdevicedrives.sql" -PageLink $pagelink -Columns ('Drive','DiskType','Description','DiskSize','Used','FreeSpace','PCT')
        break;
    }
    'OptionalFeatures' {
        $SearchField = 'ComputerName'
        $content = Get-SkQueryTableMultiple -QueryFile "cmdevicefeatures.sql" -PageLink $pagelink -Columns ('FeatureName','FeatureID','InstallState') -Sorting "FeatureName" -NoUnFilter -NoCaption
        break;
    }
    'Software' {
        $SearchField = 'Name0'
        $content = Get-SkQueryTableMultiple -QueryFile "cmdeviceapps.sql" -PageLink $pagelink -Columns ('ProductName','Publisher','Version') -Sorting "ProductName" -NoUnFilter -NoCaption
        break;
    }
	'Tools' {
		$content = "<table id=table2><tr><td>Coming Soon!</td></tr></table>"
		break;
	}
}

$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent