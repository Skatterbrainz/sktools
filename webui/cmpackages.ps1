Get-SkParams

$PageTitle   = "CM Software"
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmpackages.ps1"

$Script:TabSelected = $Script:SearchValue
if ($Script:SearchValue -eq 'all') {
    $Script:SearchValue = ""
}
if ($Script:SearchField -in ('PackageType','PkgType')) {
    $cap = Get-SkCmPackageTypeName -PkgType $Script:SearchValue
    $PageTitle += ": $cap"
}
elseif (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$xxx = "requesting query result"
$content = Get-SkQueryTableMultiple -QueryFile "cmpackages.sql" -PageLink "cmpackages.ps1" -Columns ('PackageID','PkgName','PackageType','PkgType','Description','Version') -NoCaption
$tabset  = Write-SkMenuTabSetAlphaNumeric -BaseLink 'cmpackages.ps1?x=begins&f=name&v=' -DefaultID $TabSelected
$content += Write-SkDetailView -PageRef "cmpackages.ps1" -Mode $Detailed

Write-SkWebContent