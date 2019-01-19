Get-SkParams

$PageTitle   = "CM Deployments Summary"
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmdepsummary.ps1"

$Script:TabSelected = $Script:SearchValue
if ($Script:SearchValue -eq 'all') {
    $Script:SearchValue = ""
}
elseif (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$xxx = "requesting query result"
$content = Get-SkQueryTableMultiple -QueryFile "cmdeploymentsummary.sql" -PageLink $pagelink -Columns ('SoftwareName','CollectionName','CollectionID','FeatureType','DeployIntent','Total','Success','Failed') -NoCaption
$tabset  = New-SkMenuTabSet -BaseLink "$pagelink`?x=begins`&f=softwarename`&v=" -DefaultID $TabSelected
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent