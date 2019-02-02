$ClassName = Get-SkPageParam -TagName "cn" -Default ""
$PageTitle = "CM Hardware Inventory Classes"
$tabset  = ""
$content = ""

function Get-CmHwInvClasses {
    [CmdletBinding()]
    param (
      [parameter(Mandatory=$True)]
      [ValidateNotNullOrEmpty()]
      [string] $SQLServerName,
      [parameter(Mandatory=$True)]
      [ValidateLength(3,3)]
      [string] $SiteCode
    )
    $output = ""
    try {
        $query = "SELECT DISTINCT irc.ClassName, irc.PropertyName, irc.SMSClassID, 
        CASE WHEN (cip.SettingName IS NOT NULL) THEN cip.SettingName 
        ELSE 'Default Client Settings'
        END AS 'SettingName',
        CASE WHEN cip.CollectionID IS NOT NULL THEN cip.CollectionID 
        ELSE 'SMS00001' END AS 'CollectionID'
        FROM v_InventoryReportClass irc
            LEFT JOIN v_InventoryClassProperty icp ON icp.SMSClassID = irc.SMSClassID
            LEFT JOIN v_CustomInventoryReport cip ON cip.InventoryReportID = irc.InventoryReportID
            ORDER BY SettingName, ClassName, PropertyName"
        $dataset = @(Invoke-DbaQuery -SqlInstance $SQLServerName -Database "CM_$SiteCode" -Query $query -ErrorAction SilentlyContinue)
		if ($ClassName -ne "") {
			$dataset = $dataset | Where-Object {$_.ClassName -eq $ClassName} | Sort-Object SettingName,ClassName
			$dataset | ForEach-Object {
				$props = [ordered]@{
					SettingName  = $_.SettingName
					ClassName    = $_.ClassName
					PropertyName = $_.PropertyName
					SMSClassID   = $_.SMSClassID
					CollectionID = $_.CollectionID
				}
				New-Object PSObject -Property $props
			}
		}
		else {
			$dataset = $dataset | Select-Object SettingName,ClassName -Unique | Sort-Object SettingName,ClassName,CollectionID
			$dataset | ForEach-Object {
				$props = [ordered]@{
					SettingName  = $_.SettingName
					ClassName    = "<a href=`"cmhwclasses.ps1?cn=$($_.ClassName)`">$($_.ClassName)</a>"
					CollectionID = $_.CollectionID
				}
				New-Object PSObject -Property $props
			}
		}
    }
    catch {
        Write-Error "ERROR: $($Error[0].Exception.Message)"
    }
}

try {
    $content = "<table id=table1>"
    $content += "<tr><th>SettingName</th><th>ClassName</th><th>Property</th><th>Class ID</th><th>Collection</th></tr>"
    $classdata = Get-CmHwInvClasses -SQLServerName $SkCmDbHost -SiteCode $SkCmSiteCode
    $classdata | ForEach-Object {
		$content += "<tr>
		<td>$($_.SettingName)</td>
		<td>$($_.ClassName)</td>
		<td>$($_.PropertyName)</td>
		<td>$($_.SMSClassID)</td>
		<td>$($_.CollectionID)</td>
		</tr>"
    }
    $content += "</table>"
}
catch {}

Write-SkWebContent