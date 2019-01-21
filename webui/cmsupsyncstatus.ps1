Get-SkParams

$PageTitle   = "CM SUP Synchronization Status"
$content     = ""
$menulist    = ""
$tabset      = ""
$pagelink    = "cmsupsyncstatus.ps1"
$queryfile   = "cmsupsyncstatus.sql"
$SearchField = ""
$SearchValue = ""

$params = @{
    QueryFile = $queryfile
    PageLink  = $pagelink
}
try {
	$content = Get-SkQueryTableSingle @params
	$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}
Write-SkWebContent