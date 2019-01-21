Get-SkParams

$PageTitle   = "CM Component Status"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmcompstats.ps1"
$queryfile = "cmcompstat.sql"
$params = @{
    QueryFile  = $queryfile 
    PageLink   = $pagelink 
    Columns    = ('RecordID','MessageID','MessageType','Severity','MachineName','Time','SiteCode','TopLevelSiteCode','ProcessID','ThreadID','ReportFunction')
    Sorting    = 'RecordID'
    NoUnFilter = $True
    NoCaption  = $True
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
