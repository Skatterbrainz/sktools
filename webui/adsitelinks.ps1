Get-SkParams

$PageTitle   = "AD Site Links"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "page.ps1"
$queryfile = "query.sql"

try {
	$content = (Get-SkADSiteLinks | Select Name,SiteLinks,Subnets,SiteLinksCost,ReplicationInterval,Servers | ConvertTo-Html -Fragment) -replace '<table>', '<table id=table1>'
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
