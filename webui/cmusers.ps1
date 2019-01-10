Get-SkParams

$PageTitle   = "CM Users"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmusers.ps1"
$content  = Get-SkQueryTableMultiple -QueryFile "cmusers.sql" -PageLink "cmusers.ps1" -Columns ('ResourceID','UserName','AADUserID','Domain','UPN','Department','Title') -Sorting "UserName"
$tabset   = New-SkMenuTabSet -BaseLink 'cmusers.ps1?x=begins&f=UserName&v=' -DefaultID $TabSelected
$content += Write-SkDetailView -PageRef "cmusers.ps1" -Mode $Detailed

Show-SkPage
