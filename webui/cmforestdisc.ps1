Get-SkParams

$PageTitle   = "CM AD Forest Discovery"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmforestdisc.ps1"

$content = Get-SkQueryTableMultiple -QueryFile "cmforests.sql" -PageLink "cmforests.ps1" -Columns ('ForestID','SMSSiteCode','SMSSiteName','LastDiscoveryTime','LastDiscoveryStatus','LastPublishingTime','PublishingStatus','DiscoveryEnabled','PublishingEnabled')
$content += Write-SkDetailView -PageRef "cmforestdisc.ps1" -Mode $Detailed

Show-SkPage
