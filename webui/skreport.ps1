Get-SkParams
$Caption = $Script:CustomName -replace '.sql',''

$PageTitle   = "Custom Report: $Caption"

$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "skreport.ps1"
$queryfile = "$Script:CustomName"
$params = @{
    QueryFile  = $queryfile 
    PageLink   = $pagelink 
    QueryType  = 'reports'
	NoUnFilter = $True
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
