Get-SkParams

$PageTitle   = "PageTitle"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    #$itemName = Get-SkCmObjectName -TableName "vSMS_Scripts" -SearchProperty "ScriptGuid" -SearchValue $Script:SearchValue -ReturnProperty "ScriptName"
    $PageTitle += ": $itemName"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "page.ps1"
$queryfile = "query.sql"

$params = @{
    QueryFile = $queryfile
    PageLink  = $pagelink
    Columns   = @()
}
$content = Get-SkQueryTableSingle @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent