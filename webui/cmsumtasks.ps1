Get-SkParams

$PageTitle   = "CM Summary Tasks"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmsumtasks.ps1"
$queryfile = ""
$query = 'SELECT DISTINCT 
TaskName,
LastRunResult,
Enabled,
LastStartTime,
NextStartTime 
FROM v_SummaryTasks'

$params = @{
    Query         = $query
    PageLink      = $pagelink 
    Columns       = ('TaskName','LastRunResult','Enabled','LastStartTime','NextStartTime')
    Sorting       = 'TaskName'
    SortType      = 'asc'
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
