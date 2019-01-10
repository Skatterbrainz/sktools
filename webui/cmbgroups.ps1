Get-SkParams

$PageTitle   = "CM Boundary Groups"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adusers.ps1"

$content = Get-SkQueryTableMultiple -QueryFile "cmboundarygroups.sql" -PageLink "cmbgroups.ps1" -Columns ('BGName','GroupID','Description','Flags','DefaultSiteCode','CreatedOn','Boundaries','SiteSystems')
$content += Write-SkDetailView -PageRef "cmgroups.ps1" -Mode $Detailed

Show-SkPage
