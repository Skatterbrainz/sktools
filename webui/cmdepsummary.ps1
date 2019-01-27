Get-SkParams

$PageTitle = "CM Deployments Summary"
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmdepsummary.ps1"
$queryfile = "cmdeploymentsummary.sql"

$Script:TabSelected = $Script:SearchValue
if ($Script:SearchValue -eq 'all') {
    $Script:SearchValue = ""
}
elseif (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$xxx = "requesting query result"
$params = @{
	QueryFile = $queryfile 
	PageLink  = $pagelink 
	Columns   = ('SoftwareName','AssignmentID','CollectionName','CollectionID','FeatureType','DeployIntent','Total','Success','Failed')
	NoCaption = $True
}
$content = Get-SkQueryTableMultiple @params
$tabset  = Write-SkMenuTabSetAlphaNumeric -BaseLink "$pagelink`?x=begins`&f=softwarename`&v=" -DefaultID $TabSelected
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent