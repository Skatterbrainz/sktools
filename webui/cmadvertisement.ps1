Get-SkParams

$PageTitle   = "CM Advertisement"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $itemName = Get-SkCmObjectName -TableName "v_Advertisement" -SearchProperty "AdvertisementID" -SearchValue $Script:SearchValue -ReturnProperty "AdvertisementName"
    $PageTitle += ": $itemName"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmadvertisement.ps1"
$queryfile = "cmadvertisement.sql"

$params = @{
    QueryFile = $queryfile
    PageLink  = $pagelink
}
$content = Get-SkQueryTableSingle @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent