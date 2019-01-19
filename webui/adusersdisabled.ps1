Get-SkParams

$PageTitle   = "AD Reports: Disabled Users"
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adusersdisabled.ps1"

try {
    $dusers = Get-SkAdUserDisabled
    $content = "<table id=table1>"
    $content += "<tr><th>UserName</th><th>Full Name</th><th>Distinguished Name</th></tr>"
    $rowcount = 0
    foreach ($user in $dusers) {
        $name  = $user.FullName
        $uname = $user.UserName
        $dn    = $user.DN
        $ulink = "<a href=`"aduser.ps1?f=username&v=$uname&x=equals&tab=general`" title=`"Details`">$uname</a>"
        $content += "<tr><td>$ulink</td><td>$name</td><td>$dn</td></tr>"
        $rowcount++
    }
    if ($rowcount -eq 0) {
        $content += "<tr><td colspan=3>No user accounts were found that are expiring within 14 days</td></tr>"
    }
    $content += "<tr><td class=lastrow colspan=3>$rowcount accounts</td></tr>"
    $content += "</table>"
}
catch {}

Write-SkWebContent