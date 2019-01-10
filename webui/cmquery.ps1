Get-SkParams

$PageTitle   = "CM Query"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $itemName = Get-SkCmObjectName -TableName "v_Query" -SearchProperty "QueryID" -SearchValue $Script:SearchValue -ReturnProperty "Name"
    $PageTitle += ": $itemName"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmquery.ps1"
$queryfile = "cmquery.sql"

$params = @{
    QueryFile = $queryfile
    PageLink  = $pagelink
    Columns   = ('QueryName','Comments','QueryKey','Architecture','Lifetime','QryFmtKey','QueryType','CollectionID','WQL','SQL')
}
$content = Get-SkQueryTableSingle @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Show-SkPage