Get-SkParams

$PageTitle   = "CM Boundary Group: $CustomName"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmbgroup.ps1"

try {
	switch ($TabSelected) {
		'General' {
			$params = @{
				 QueryFile = "cmboundarygroup.sql" 
				 PageLink  = $pagelink 
				 FieldName = $SearchField
				 Value     = $SearchValue
				 Columns   = ('BGName','DefaultSiteCode','GroupID','GroupGUID','Description','Flags','CreatedBy','CreatedOn','ModifiedBy','ModifiedOn','MemberCount','SiteSystemCount','Shared') 
			}
			$content = Get-SkQueryTableSingle2 @params
			break;
		}
		'Boundaries' {
			$xxx += ";queryfile: cmboundaries.sql"
			$params = @{
				QueryFile  = "cmboundaries.sql" 
				PageLink   = $pagelink 
				Columns    = ('DisplayName','BoundaryID','BValue','BoundaryType','BoundaryFlags','CreatedBy','CreatedOn','ModifiedBy','ModifiedOn','GroupID','BGName') 
				NoUnFilter = $True
				NoCaption  = $True
			}
			$content = Get-SkQueryTableMultiple @params
			break;
		}
		default {
			$query = "SELECT vSMS_BoundaryGroupSiteSystems.GroupID, 
					vSMS_BoundaryGroupSiteSystems.ServerNALPath, 
					vSMS_BoundaryGroupSiteSystems.SiteCode, 
					case when (vSMS_BoundaryGroupSiteSystems.Flags = 0) then 'Fast' else 'Slow' end as Flags, 
					vSMS_BoundaryGroup.Name AS BGName
					FROM vSMS_BoundaryGroupSiteSystems INNER JOIN
                    vSMS_BoundaryGroup ON vSMS_BoundaryGroupSiteSystems.GroupID = vSMS_BoundaryGroup.GroupID 
					WHERE vSMS_BoundaryGroup.Name = '$SearchValue' ORDER BY ServerNALPath"
			$ss = @(Invoke-DbaQuery -SqlInstance $SkCmDBHost -Database "CM_$SkCmSiteCode" -Query $query -ErrorAction SilentlyContinue)
			$rowcount = 0
			$content = "<table id=table1>"
			$content += "<tr><th>GroupID</th><th>ServerName</th><th>Flags</th></tr>"
			foreach ($row in $ss) {
				$svr = $row.ServerNALPath # '["Display=\\CM02.contoso.local\"]MSWNET:["SMS_SITE=P02"]\\CM02.contoso.local\'
				$svr = $($svr -split '\\') | Where-Object {![string]::IsNullOrEmpty($_)} | Select -Last 1
				if (($svr -split '\.').Count -gt 1) {
					$svx = $svr -split '\.' | Select -First 1
				}
				else {
					$svx = $svr
				}
				$content += "<tr>"
				$content += "<td>$($row.GroupID)</td>"
				$content += "<td><a href=`"cmdevice.ps1?f=name&v=$svx&tab=general`">$svr</a></td>"
				$content += "<td>$($row.Flags)</td>"
				$content += "</tr>"
				$rowcount++
			}
			$content += "<tr><td colspan=`"3`" class=`"lastrow`">$rowcount site servers</td></tr>"
			$content += "</table>"
			break;
		}
	}
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}
$tabs   = @('General','Boundaries','Systems')
$tabset = Write-SkMenuTabSetNameList -MenuTabs $tabs -BaseLink $pagelink
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
