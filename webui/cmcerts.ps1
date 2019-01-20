Get-SkParams

$PageTitle   = "CM Certificates"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmcerts.ps1"

$content = Get-SkQueryTableMultiple -QueryFile "cmcerts.sql" -PageLink $PageTitle -Columns ('ServerName','IssuedTo','CertType','KeyType','ValidFrom','ValidUntil','Approved','Blocked')

Write-SkWebContent