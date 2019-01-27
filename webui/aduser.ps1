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
}

$tabs = @('General','Groups')
$tabset = Write-SkMenuTabSetNameList -MenuTabs $tabs -BaseLink $pagelink
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
