Get-SkParams

$PageTitle   = "AD User"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

switch ($TabSelected) {
    'General' {
        try {
            $user = Get-SkAdUsers | Where-Object {$_.UserName -eq "$SearchValue"}
            $columns = $user.psobject.properties | Select-Object -ExpandProperty Name
            $content = "<table id=table2>"
            foreach ($col in $columns) {
                $fvx = Get-SkValueLinkAD -PropertyName $col -Value $($user."$col" | Out-String)
                $content += "<tr><td class=`"t2td1`">$col</td><td class=`"t2td2`">$fvx</td></tr>"
            }
            $content += "</table>"
        }
        catch {
            $content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Groups' {
        $content = "<table id=table1>"
        $content += "<tr><th>Name</th><th>LDAP Path</th><th></th></tr>"
        try {
            $groups = Get-SkAdUserGroups -UserName "$SearchValue"
            $rowcount = 0
            $groups | ForEach-Object {
                $rmvlink = "<a href=`"admod2.ps1?userid=$SearchValue&groupid=$($_.Name)&op=delmember`" title=`"Remove from Group`">Remove</a>"
                $content += "<tr>"
                $xlink = "<a href=`"adgroup.ps1?f=name&v=$($_.Name)&x=equals`" title=`"Details`">$($_.Name)</a>"
                $content += "<td style=`"width:250px`">$xlink</td>"
                $content += "<td>$($_.DN)</td>"
                $content += "<td style=`"width:80px;text-align:center;`">$rmvlink</td>"
                $content += "</tr>"
                $rowcount++
            }
            if ($rowcount -gt 0) {
                $content += "<tr><td colspan=`"3`" class=`"lastrow`">$rowcount groups found</td></tr>"
            }
            else {
                $content += "<tr><td colspan=`"3`" style=`"text-align:center`">No groups found</td></tr></table>"
            }
            $content += "</table><br/>"
            $content += "<form name=`"form11`" id=`"form11`" method=`"POST`" action=`"admod.ps1`">"
            $content += "<input type=`"hidden`" name=`"userid`" id=`"userid`" value=`"$SearchValue`" />"
            $content += "<input type=`"hidden`" name=`"op`" id=`"op`" value=`"addmember`" />"
            $content += "<input type=`"submit`" name=`"ok`" id=`"ok`" value=`"Add to Group`" class=`"button1`" title=`"Add to Group`"/>"
            $content += "</form>"
        }
        catch {}
        break;
    }
    'Devices' {
        try {
            $query = "SELECT DISTINCT
                v_R_System.Name0 AS ADComputerName, 
                v_GS_USER_PROFILE.LocalPath0 AS LocalPath, 
                v_R_System.AD_Site_Name0 AS ADSite, 
                v_GS_COMPUTER_SYSTEM.Model0 AS Model, 
                v_GS_OPERATING_SYSTEM.Caption0 AS OperatingSystem, 
                v_GS_OPERATING_SYSTEM.BuildNumber0 AS OSBuild, 
                v_GS_USER_PROFILE.TimeStamp
                FROM v_GS_USER_PROFILE INNER JOIN
                v_R_System ON dbo.v_GS_USER_PROFILE.ResourceID = v_R_System.ResourceID INNER JOIN
                v_GS_COMPUTER_SYSTEM ON 
                v_GS_USER_PROFILE.ResourceID = v_GS_COMPUTER_SYSTEM.ResourceID INNER JOIN
                v_GS_OPERATING_SYSTEM ON 
                v_GS_USER_PROFILE.ResourceID = v_GS_OPERATING_SYSTEM.ResourceID
                WHERE (v_GS_USER_PROFILE.LocalPath0 LIKE '%$SearchValue')
                ORDER BY v_GS_USER_PROFILE.TimeStamp DESC"
            $result = @(Invoke-DbaQuery -SqlInstance $CmDbHost -Database "CM_$CmSiteCode" -Query $query -ErrorAction Stop)
            $rowcount = 0
            $content = "<table id=table1><tr>"
            if ($result.Count -gt 0) {
                $columns  = $result[0].Table.Columns.ColumnName
                $colcount = $columns.Count
                $columns | ForEach-Object { $content += "<th>$_</th>" }
                $content += "</tr>"
                foreach ($rs in $result) {
                    $content += "<tr>"
                    foreach ($fn in $columns) {
                        $fv = $rs."$fn"
                        $fvx = Get-SKDbValueLink -ColumnName $col -Value $fv
                        $content += "<td>$fvx</td>"
                    }
                    $content += "</tr>"
                    $rowcount++
                }
            }
            if ($rowcount -gt 0) {
                $content += "<tr><td colspan=$colcount class=lastrow>$rowcount rows returned</td></tr>"
            }
            else {
                $content += "<tr><td colspan=$colcount style=`"text-align:center`">No records found</td></tr></table>"
            }
            $content += "</table>"
        }
        catch {
            $content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
}

$tabs = @('General','Groups','Devices')
$tabset = New-SkMenuTabSet2 -MenuTabs $tabs -BaseLink "aduser.ps1"
$content += Write-SkDetailView -PageRef "aduser.ps1" -Mode $Detailed

Show-SkPage
