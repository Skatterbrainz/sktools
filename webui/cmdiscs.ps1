Get-SkParams

$PageTitle   = "CM Discovery Methods"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adusers.ps1"

$content = Get-SkQueryTableMultiple -QueryFile "cmdiscoveries.sql" -PageLink "cmdiscs.ps1" -Columns ('ItemType','SiteNumber','SourceTable')
$content += Write-SkDetailView -PageRef "cmdiscs.ps1" -Mode $Detailed

Write-SkWebContent
