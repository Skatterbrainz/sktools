Get-SkParams
$Script:RoleCode    = Get-SkPageParam -TagName 'rc' -Default ""

$PageTitle   = "CM Site Systems"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmservers.ps1"

switch($Script:RoleCode) {
    'dp' {
        $queryfile = "cmdps.sql"
        $columns   = ('DPID','DPName','Description','SMSSiteCode','IsPXE','DPType','Type')
        $Script:PageTitle += ": Distribution Points"
        break;
    }
    default {
        $content = "<table id=table2><tr><td>Not implemented</td></tr></table>"
        break;
    }
}

$params = @{
    QueryFile     = $queryfile 
    Query         = ""
    Columns       = $columns
    PageLink      = $pagelink 
    Sorting       = 'DPName'
    SortType      = 'asc'
    ColumnSorting = $False 
    NoUnFilter    = $False 
    NoCaption     = $False
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Show-SkPage
