Get-SkParams

$PageTitle   = "CM Discovery Method: $CustomName"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmdisc.ps1"

$params = @{
	QueryFile  = "cmdiscovery.sql" 
	PageLink   = $pagelink
	Columns    = ('ItemType','ID','Sitenumber','Name','Value1','Value2','Value3','SourceTable') 
	NoUnFilter = $True
	NoCaption  = $True
}
$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
