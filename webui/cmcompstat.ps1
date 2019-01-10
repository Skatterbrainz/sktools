Get-SkParams

$PageTitle   = "CM Component Status"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmcompstat.ps1"
$queryfile = "cmcomponentstatus.sql"
$params = @{
    QueryFile = $queryfile 
    PageLink  = $pagelink 
    Columns   = ('ComponentName','Status','State','LastContacted','Info','Warning','Error') 
    Sorting   = 'ComponentName'
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Show-SkPage
