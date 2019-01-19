Get-SkParams

$PageTitle   = "PageTitle"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
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
    Sorting   = 'FieldName'
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
