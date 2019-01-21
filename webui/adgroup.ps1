Get-SkParams

$PageTitle   = "AD Group: $SearchValue"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adgroup.ps1"

$tabs = @('General','Members')

switch ($TabSelected) {
    'General' {
        try {
            $group   = Get-SkAdGroups | Where-Object {$_."$SearchField" -eq $SearchValue}
            $content = "<table id=table2>
            <tr><td class=`"t2td1`">Name</td><td class=`"t2td2`">$($group.Name)</td></tr>
            <tr><td class=`"t2td1`">LDAP Path</td><td class=`"t2td2`">$($group.DN)</td></tr>
            <tr><td class=`"t2td1`">OU Path</td><td class=`"t2td2`">$($group.OU)</td></tr>
            <tr><td class=`"t2td1`">Description</td><td class=`"t2td2`">$($group.Description)</td></tr>
            <tr><td class=`"t2td1`">Date Created</td><td class=`"t2td2`">$($group.Created)</td></tr>
            <tr><td class=`"t2td1`">Last Modified</td><td class=`"t2td2`">$($group.Changed)</td></tr>
            </table>"    
        }
        catch {
            $content += $Error[0].Exception.Message
        }
        break;
    }
    'Members' {
        try {
            $rowcount = 0
            $columns = @('UserName','Title','Type','LDAP Path', '...')
            $members = Get-SkAdGroupMembers -GroupName $SearchValue | Sort-Object UserName
            $xxx = "members: $($members.count)"
            $content += "<table id=table1>"
            $content += "<tr>"
            $content += $columns | ForEach-Object { "<th>$_</th>" }
            $content += "</tr>"
            foreach ($member in $members) {
                $uname = $member.UserName
                if ($member.Type -eq 'User') {
                    $xlink = "aduser.ps1?f=UserName&v=$uname&x=equals&tab=general"
                }
                else {
                    $xlink = "adgroup.ps1?f=name&v=$uname&x=equals&tab=general"
                }
                $rmvlink = "<a href=`"admod2.ps1?userid=$uname&groupid=$SearchValue&op=delmember`" title=`"Remove from Group`">Remove</a>"
                $content += "<tr><td><a href=`"$xlink`" title=`"Details`">$uname</a></td>"
                $content += "<td>$($member.Title)</td>"
                $content += "<td>$($member.Type)</td>"
                $content += "<td>$($member.DN)</td>"
                $content += "<td style=`"width:80px;text-align:center;`">$rmvlink</td>"
                $content += "</tr>"
                $rowcount++
            }
            $content += "<tr><td colspan=`"5`" class=`"lastrow`">$rowcount members found</td></tr>"
            $content += "</table><br/>"
            $content += "<form name=`"form11`" id=`"form11`" method=`"POST`" action=`"admod.ps1`">"
            $content += "<input type=hidden name=`"groupid`" id=`"groupid`" value=`"$SearchValue`" />"
            $content += "<input type=hidden name=`"op`" id=`"op`" value=`"addmember`" />"
            $content += "<input type=submit name=`"ok`" id=`"ok`" value=`"Add Members`" class=`"button1`" title=`"Add Members`"/>"
            $content += "</form>"
        }
        catch {
            $content += $Error[0].Exception.Message
        }
        break;
    }
} # switch
$tabset  = New-SkMenuTabSet2 -MenuTabs $tabs -BaseLink $pagelink
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
