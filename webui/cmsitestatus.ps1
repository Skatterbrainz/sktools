Get-SkParams | Out-Null

$PageTitle   = "CM Site Status"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition
$xxx         = ""

$content = Get-SkQueryTableMultiple -QueryFile "cmsitestatus.sql" -PageLink "cmsitestatus.ps1" -Columns ('SiteStatus','Role','SiteCode','SiteSystem','TimeReported')
$content += Write-SkDetailView -PageRef "cmsitestatus.ps1" -Mode $Detailed

Show-SkPage
