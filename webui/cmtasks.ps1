Get-SkParams | Out-Null

$PageTitle   = "CM Maintenance Tasks"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$content = Get-SkQueryTableMultiple -QueryFile "cmtasks.sql" -PageLink "cmtasks.ps1" -NoUnFilter -Sorting "TaskName"
$content += Write-SkDetailView -PageRef "cmtasks.ps1" -Mode $Detailed

Write-SkWebContent
