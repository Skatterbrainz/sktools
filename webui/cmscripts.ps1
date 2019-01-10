Get-SkParams

$PageTitle   = "CM Scripts"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmscripts.ps1"
$queryfile = "cmscripts.sql"
$params = @{
    QueryFile = $queryfile 
    PageLink  = $pagelink 
    Columns   = ('ScriptName','ScriptGuid','ScriptVersion','Author','Approval','LastUpdateTime') 
    Sorting   = 'ScriptName'
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Show-SkPage
