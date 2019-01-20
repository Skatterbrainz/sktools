Get-SkParams

$PageTitle   = "CM AD Forest Discovery"
#$SearchValue = ""
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmforestdisc.ps1"
$params = @{
	QueryFile = "cmforests.sql" 
	PageLink  = $pagelink
}
$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
