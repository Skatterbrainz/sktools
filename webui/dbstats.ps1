$Script:PageTitle   = "CM SQL Server Report"
$content     = ""
$tabset      = ""
$outree      = $null
$query       = $null
$xxx         = ""

try {
    $content = "<h3>Database State</h3>"
    $content += (Get-DbaDbState -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" | ConvertTo-Html -Fragment) -replace '<table>','<table id=table1>'

    $content += "<h3>Maximum Memory Allocation</h3>"
    $content += (Get-DbaMaxMemory -SqlInstance $SkCmDbHost -ErrorAction Continue | ConvertTo-Html -Fragment) -replace '<table>', '<table id=table1>'

    $content += "<h3>Memory Usage</h3>"
    $content += (Get-DbaMemoryUsage -ComputerName $SkCmDbHost -ErrorAction Continue | ConvertTo-Html -Fragment) -replace '<table>', '<table id=table1>'

    $content += "<h3>Startup Parameters</h3>"
    $content += (Get-DbaStartupParameter -SqlInstance $SkCmDbHost | ConvertTo-Html -Fragment) -replace '<table>', '<table id=table1>'

    $content += "<h3>Disk Allocation</h3>"
    $content += (Test-DbaDiskAllocation -ComputerName $SkCmDbHost -ErrorAction Continue | ConvertTo-Html -Fragment) -replace '<table>','<table id=table1>'

    $content += "<h3>Latency</h3>"
    $content += (Get-DbaIoLatency -SqlInstance $SkCmDbHost -ErrorAction Continue | ConvertTo-Html -Fragment) -replace '<table>', '<table id=table1>'

}
catch {
    $content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}

Show-SkPage
