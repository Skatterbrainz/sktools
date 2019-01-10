Get-SkParams

$PageTitle   = "CM Discovery Method: $CustomName"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adusers.ps1"

$content = Get-SkQueryTableMultiple -QueryFile "cmdiscovery.sql" -PageLink "cmdisc.ps1" -Columns ('ItemType','ID','Sitenumber','Name','Value1','Value2','Value3','SourceTable') -NoUnFilter -NoCaption
$content += Write-SkDetailView -PageRef "cmdisc.ps1" -Mode $Detailed

Show-SkPage
