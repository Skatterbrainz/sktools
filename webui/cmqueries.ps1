Get-SkParams

$PageTitle   = "CM Queries"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmqueries.ps1"
$queryfile = "cmqueries.sql"
$params = @{
    QueryFile = $queryfile 
    PageLink  = $pagelink 
    Columns   = ('QueryName','QueryID','Comments','TargetClassName','LimitToCollectionID')
    Sorting   = 'QueryName'
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
