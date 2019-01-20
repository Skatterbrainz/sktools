Get-SkParams

$PageTitle   = "CM Custom Report"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": Assignment $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmreport1.ps1"
$queryfile = "cmassignment.sql"

$params = @{
	QueryFile = $queryfile
    PageLink  = $pagelink 
	Columns   = ""
}

$content = Get-SkQueryTableSingle @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
