Get-SkParams

$PageTitle   = "CM Maintenance Tasks"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$domainname = $env:USERDOMAIN
[adsi]$domain = "WinNT://$domainname"

$pwa1 = $($domain.MinPasswordAge) / 86400
$pwa2 = $($domain.MaxPasswordAge) / 86400
$pwln = $domain.MinPasswordLength
$mbpa = $domain.MaxBadPasswordsAllowed
$phln = $domain.PasswordHistoryLength
$alin = $domain.AutoUnlockInterval

$content = "<table id=table2>"
$content += "<tr><th>Option / Setting</th><th style=`"width:100px`">Value</th></tr>"
$content += "<tr><td>Minimum Password Age</td><td style=`"text-align:right`">$pwa1 days</td></tr>"
$content += "<tr><td>Maximum Password Age</td><td style=`"text-align:right`">$pwa2 days</td></tr>"
$content += "<tr><td>Minimum Password Length</td><td style=`"text-align:right`">$pwln</td></tr>"
$content += "<tr><td>Max Bad Passwords Allowed</td><td style=`"text-align:right`">$mbpa</td></tr>"
$content += "<tr><td>Password History Length</td><td style=`"text-align:right`">$phln</td></tr>"
$content += "<tr><td>Account Lockout Interval</td><td style=`"text-align:right`">$alin</td></tr>"
$content += "</table>"

Show-SkPage
