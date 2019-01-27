Get-SkParams
$Caption = $Script:CustomName -replace '.sql',''

$PageTitle   = "Custom Report: $Caption"

$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "skreport.ps1"
$queryfile = "$Script:CustomName"
$params = @{
    QueryFile  = $queryfile 
    PageLink   = $pagelink 
    QueryType  = 'reports'
	NoUnFilter = $True
}

if ($Script:CustomName -match 'bar chart') {
	$chart1 = Write-SkBarChart -QueryFile $Script:CustomName -Title $Caption -ChartHeight 200 -ChartWidth 400
	$content += "<table id=table2><tr style=`"background-color:#fff`"><td>$chart1</td></tr></table>"
}
elseif ($Script:CustomName -match 'pie chart') {
	$chart1 = Write-SkPieChart -QueryFile $Script:CustomName -Title $Caption -ChartHeight 200 -ChartWidth 400
	$content += "<table id=table2><tr style=`"background-color:#fff`"><td>$chart1</td></tr></table>"
}
elseif ($Script:CustomName -match 'summary chart') {
	$chart1 = Write-SkPieChart -QueryFile $Script:CustomName -Title $Caption -ChartHeight 200 -ChartWidth 400
	$chart2 = Write-SkBarChart -QueryFile $Script:CustomName -Title $Caption -ChartHeight 200 -ChartWidth 400
	$content += "<table id=table2><tr style=`"background-color:#fff`"><td>$chart1</td><td>$chart2</td></tr></table>"
}
$content += Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
