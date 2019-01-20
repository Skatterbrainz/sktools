Get-SkParams

$PageTitle   = "Custom Reports"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "skreports.ps1"
<#$queryfile = "query.sql"
$params = @{
    QueryFile = $queryfile 
    PageLink  = $pagelink 
    Columns   = () 
    Sorting   = 'FieldName'
}

$content = Get-SkQueryTableMultiple @params
#>
try {
    $rpath    = $(Join-Path -Path $PSScriptRoot -ChildPath "reports")
    $rfiles   = Get-ChildItem -Path $rpath -Filter "*.sql" | Sort-Object Name
    $content  = "<table id=table1><tr><th>Report Name</th></tr>"
    $rowcount = $rfiles.Count
    $rfiles | ForEach-Object {$content += "<tr><td><a href=`"skreport.ps1?n=$($_.Name)`" title=`"Run Report`">$($_.Name -replace '.sql','')</a></td></tr>"}
    $content  += "<tr><td class=lastrow>$rowcount reports</td></tr>"
    $content  += "</table>"
}
catch {}
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
